package com.byd.service;

import com.byd.mapper.EventMapper;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventMapper eventMapper;

    // 1. 차종별 최대 예약 가능 인원 (추후 DB 관리자 제어로 확장 가능)
    private final Map<String, Integer> carCapacityMap = new HashMap<String, Integer>() {{
        put("BYD DOLPHIN", 2);
        put("BYD ATTO 3", 2);
        put("BYD SEAL", 2);
        put("BYD SEALION 7", 2);
    }};

    // 차종 구분 없이 시간대별 총 정원 8명으로 통합 적용
    private static final int MAX_CAPACITY = 8;

    public int getMaxCapacity() {
        return MAX_CAPACITY;
    }

    public int getCarCapacity(String carModel) {
        if(carModel == null || carModel.isEmpty()) return 2; // 기본값 2
        return carCapacityMap.getOrDefault(carModel.toUpperCase(), 2);
    }

    public ParticipantVO getParticipantByPhone(String phone){
        return eventMapper.getParticipantByPhone(phone);
    }

    public ParticipantVO getParticipantByPhoneToday(String phone){
        return eventMapper.getParticipantByPhoneToday(phone);
    }

    public Map<String, Integer> getDriveTimeCountToday(String carModel) {
        List<Map<String, Object>> rawList = eventMapper.getDriveTimeCountToday(carModel);
        Map<String, Integer> resultMap = new HashMap<>();

        if (rawList != null) {
            for (Map<String, Object> row : rawList) {
                Object timeObj = row.get("testDriveTime");
                String time = "";

                if (timeObj instanceof byte[]) {
                    // 데이터가 바이트 배열([B)로 넘어왔을 경우 문자열로 안전하게 복원
                    time = new String((byte[]) timeObj);
                } else {
                    // 정상적으로 문자열이나 다른 객체로 넘어왔을 경우
                    time = String.valueOf(timeObj);
                }

                // cnt 값도 안전하게 파싱
                int count = 0;
                Object cntObj = row.get("cnt");
                if (cntObj != null) {
                    count = Integer.parseInt(String.valueOf(cntObj));
                }

                resultMap.put(time, count);
            }
        }
        return resultMap;
    }

    private void validateDriveTime(String testDriveTime, String carModel) {
        if (testDriveTime == null || "시승 미신청".equals(testDriveTime)) return;

        try {
            java.time.LocalTime now = java.time.LocalTime.now();
            java.time.LocalTime targetTime = java.time.LocalTime.parse(testDriveTime);
            int targetHour = targetTime.getHour();

            // 요일 확인 로직 추가 (토, 일요일 판별)
            java.time.DayOfWeek dayOfWeek = java.time.LocalDate.now().getDayOfWeek();
            boolean isWeekend = (dayOfWeek == java.time.DayOfWeek.SATURDAY || dayOfWeek == java.time.DayOfWeek.SUNDAY);

            // 1. 오전 회차 (1~3회차: 11:00 ~ 13:00 타임)
            if (targetHour >= 11 && targetHour <= 13) {
                if (now.getHour() < 10) {
                    throw new IllegalStateException("오전 회차(1~3회차)는 10:00부터 예약 가능합니다.");
                }
            }
            // 2. 오후 회차 (4~7회차: 14:00 ~ 17:00 타임)
            else if (targetHour >= 14 && targetHour <= 17) {

                // 평일 17시(7회차) 강제 접근 차단 방어
                if (!isWeekend && targetHour == 17) {
                    throw new IllegalStateException("17:00(7회차)는 주말에만 예약 가능합니다.");
                }

                if (isWeekend) {
                    if (now.getHour() < 14) {
                        throw new IllegalStateException("주말 오후 회차(4~7회차)는 14:00부터 예약 가능합니다.");
                    }
                } else {
                    if (now.getHour() < 13) {
                        throw new IllegalStateException("평일 오후 회차(4~6회차)는 13:00부터 예약 가능합니다.");
                    }
                }
            }

            // 2. 각 회차 시작 후 20분 마감 통제 로직
            if (now.getHour() > targetHour || (now.getHour() == targetHour && now.getMinute() >= 20)) {
                throw new IllegalStateException("해당 시승 시간은 예약이 마감되었습니다. (시작 후 20분까지만 신청 가능)");
            }
        } catch (java.time.format.DateTimeParseException e) {
            // 형식 오류 무시
        }

        // DB에서 현재 예약 인원 조회 (해당 시간 + 해당 차종)
        int currentCount = eventMapper.getDriveTimeCount(testDriveTime, carModel);
        if (currentCount >= MAX_CAPACITY) {
            // 🚨 정원 초과 시에도 IllegalStateException 사용
            throw new IllegalStateException("선택하신 시승 시간의 예약 인원(" + MAX_CAPACITY + "명)이 모두 마감되었습니다. 다른 시간을 선택해 주세요.");
        }
    }

    public void insertParticipant(ParticipantVO participantVO) {

        // [핵심 방어] 프론트에서 시간 파라미터를 강제로 지우고(Null) 보냈을 때 기본값 강제 할당
        if (participantVO.getTestDriveTime() == null || participantVO.getTestDriveTime().trim().isEmpty()) {
            participantVO.setTestDriveTime("시승 미신청");
        }

        // 백엔드 단위 4명 정원 검증 로직
        if(!"시승 미신청".equals(participantVO.getTestDriveTime())) {
            validateDriveTime(participantVO.getTestDriveTime(), participantVO.getCarModel());

            // 3일간 시승 행사 1회 참여 제한 검증 (이전 날짜 포함)
            int historyCount = eventMapper.checkTestDriveHistory(participantVO.getPhone(), null);
            if(historyCount > 0) {
                throw new IllegalArgumentException("행사 기간 중 시승 신청은 1회만 가능합니다.");
            }
        }

        // QR 코드 보안을 위해 난수(UUID) 토큰 생성 후 저장
        String qrToken = UUID.randomUUID().toString().replace("-", "");
        participantVO.setQrCodeUrl(qrToken);

        // 유입경로 기본값 세팅
        if(participantVO.getEntryType() == null || participantVO.getEntryType().isEmpty()){
            participantVO.setEntryType("4040");
        }

        eventMapper.insertParticipant(participantVO);
    }

    public ParticipantVO getParticipantBySeq(int seq) {
        return eventMapper.getParticipantBySeq(seq);
    }

    public void updateParticipant(ParticipantVO participantVO) {

        // 1. DB에서 기존 정보를 미리 조회합니다.
        ParticipantVO existing = eventMapper.getParticipantBySeq(participantVO.getSeq());
        if (existing == null) throw new IllegalArgumentException("존재하지 않는 회원 정보입니다.");

        // 시승 완료 고객(Y)은 화면에서 disabled 처리되어 testDriveTime이 null로 넘어옵니다.
        // 이를 '시승 미신청'으로 오해하여 에러를 뱉지 않도록 기존 시간을 강제로 유지시켜 줍니다.
        if ("Y".equals(existing.getDriveCheckYn())) {
            participantVO.setTestDriveTime(existing.getTestDriveTime());
        }

        // [핵심 방어] 넘겨받은 파라미터가 Null인지, 기존 DB 데이터가 Null인지 모두 점검
        if (participantVO.getTestDriveTime() == null || participantVO.getTestDriveTime().trim().isEmpty()) {
            participantVO.setTestDriveTime("시승 미신청");
        }
        String oldTime = existing.getTestDriveTime() == null ? "시승 미신청" : existing.getTestDriveTime();

        // 2. 시승 완료 고객 방어
        if ("Y".equals(existing.getDriveCheckYn())) {
            if (!oldTime.equals(participantVO.getTestDriveTime())) {
                throw new IllegalArgumentException("이미 시승 체험을 완료하신 고객은 시간을 변경할 수 없습니다.");
            }
        }

        // 3. 시승 시간이 변경된 경우, 마감 및 과거 시간 여부 철저히 검증
        boolean updateRegDate = false;
        if (!oldTime.equals(participantVO.getTestDriveTime())) {
            updateRegDate = true;

            // "시승 미신청"으로 빼는 경우가 아니라면,
            if (!"시승 미신청".equals(participantVO.getTestDriveTime())) {
                // 과거 시간 및 형식 검증
                validateDriveTime(participantVO.getTestDriveTime(), participantVO.getCarModel());
            }
        }

        // 4. 시승 신규 신청/변경 시 중복 이력 체크
        if(!"시승 미신청".equals(participantVO.getTestDriveTime())) {
            int historyCount = eventMapper.checkTestDriveHistory(participantVO.getPhone(), participantVO.getSeq());
            if(historyCount > 0) throw new IllegalArgumentException("행사 기간 중 시승 신청은 1회만 가능합니다.");
        }

        // 5. 매퍼 호출 시 플래그 전달
        eventMapper.updateParticipant(participantVO, updateRegDate);
    }

    // Aligo API SMS 발송 로직
    public boolean sendAligoSms(String receiverPhone, String name, String ticketUrl, String testDriveTime, boolean isUpdate) {
        try {
            String aligoKey = "ddefu9nx1etgljr1p1z1n9h7ri5u8mf0";          // 알리고 API KEY
            String aligoId = "meetingfan";           // 알리고 사용자 ID
            String sender = "07089498065";           // 사전에 등록된 발신자 번호 (ex. 0212345678)

            // 알리고 SMS 전송 API 엔드포인트
            String apiUrl = "https://apis.aligo.in/send/";

            String message = "";
            if (testDriveTime == null || "시승 미신청".equals(testDriveTime)) {
                // 일반 이벤트 참여자(시승 미신청) 전용 안내 문자
                String title = isUpdate ? "[BYD KOREA BIMOS 2026 참여 티켓 수정 안내]\n\n" : "[BYD KOREA BIMOS 2026 참여 티켓]\n\n";
                String greeting = isUpdate ? "예약 정보가 정상적으로 수정되었습니다." : "신청이 완료되었습니다.";

                message = title +
                        name + "님, " + greeting + "\n" +
                        "현장 데스크에서 아래 링크의 모바일 티켓(QR)을 보여주세요.\n\n" +
                        "▶ 모바일 티켓 보기:\n" + ticketUrl;
            } else {
                String title = isUpdate ? "[BYD KOREA BIMOS 2026 시승 수정 안내]\n\n" : "[BYD KOREA BIMOS 2026 시승 안내]\n\n";

                message = title +
                        name + "님, 예약하신 시승을 위해 시승부스로 바로 방문 부탁드립니다.\n\n" +
                        "접수 시 아래 모바일 티켓(QR)을 제시해 주세요.\n\n" +
                        "▶ 모바일 티켓 확인\n" + ticketUrl + "\n\n" +
                        "※ 예약 시간 이후 도착 시 시승이 취소되거나 대기 순서가 변경될 수 있습니다.\n" +
                        "※ 음주자는 시승에 참여하실 수 없습니다.\n" +
                        "※ 실물 운전면허증을 반드시 지참해 주시기 바랍니다.";
            }

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

            // 알리고 요청 파라미터 세팅
            Map<String, String> params = new LinkedHashMap<>();
            params.put("key", aligoKey);
            params.put("user_id", aligoId);
            params.put("sender", sender);
            params.put("receiver", receiverPhone);
            params.put("msg", message);
            // params.put("testmode_yn", "Y"); // 테스트 모드 (실제 발송 안 됨, 개발 시 주석 해제)

            StringBuilder postData = new StringBuilder();
            for (Map.Entry<String, String> param : params.entrySet()) {
                if (postData.length() != 0) postData.append('&');
                postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
                postData.append('=');
                postData.append(URLEncoder.encode(param.getValue(), "UTF-8"));
            }

            // 요청 데이터 전송
            OutputStream os = conn.getOutputStream();
            os.write(postData.toString().getBytes("UTF-8"));
            os.flush();
            os.close();

            // 응답 수신
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // 알리고 응답 성공 여부 판단 (성공 시 JSON에 "result_code": 1 포함)
            System.out.println("Aligo API Response: " + response.toString());
            return response.toString().contains("\"result_code\":1");

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 알리고 SMS 자유 메시지 발송 공통 메서드
     */
    public boolean sendAligoCustomMessage(String receiverPhone, String message) {
        try {
            String aligoKey = "ddefu9nx1etgljr1p1z1n9h7ri5u8mf0";
            String aligoId = "meetingfan";
            String sender = "07089498065";
            String apiUrl = "https://apis.aligo.in/send/";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

            Map<String, String> params = new LinkedHashMap<>();
            params.put("key", aligoKey);
            params.put("user_id", aligoId);
            params.put("sender", sender);
            params.put("receiver", receiverPhone);
            params.put("msg", message);

            StringBuilder postData = new StringBuilder();
            for (Map.Entry<String, String> param : params.entrySet()) {
                if (postData.length() != 0) postData.append('&');
                postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
                postData.append('=');
                postData.append(URLEncoder.encode(param.getValue(), "UTF-8"));
            }

            OutputStream os = conn.getOutputStream();
            os.write(postData.toString().getBytes("UTF-8"));
            os.flush();
            os.close();

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            return response.toString().contains("\"result_code\":1");

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * [시승 15분 전 리마인드 문자 자동 발송 스케줄러]
     * 매 분 0초마다 실행되어, 현재 시간 기준 15분 뒤에 시승 예약이 있는 대상자를 찾아 문자를 발송합니다.
     */
    @Scheduled(cron = "0 * * * * *")
    public void sendTestDriveReminders() {
        // 1. 현재 시간에서 정확히 15분 뒤의 시간을 구함 (예: 현재 09:45 이면 targetTime은 "10:00")
        LocalTime targetTime = LocalTime.now().plusMinutes(15);
        String targetTimeStr = targetTime.format(DateTimeFormatter.ofPattern("HH:mm"));

        // 2. 대상자 조회 (오늘자 + 15분 뒤 시간 예약자 + 미출석)
        List<ParticipantVO> targetList = eventMapper.getParticipantsForReminder(targetTimeStr);

        if (targetList == null || targetList.isEmpty()) {
            return; // 대상자가 없으면 조용히 종료
        }

        // 3. 대상자들에게 리마인드 문자 발송
        for (ParticipantVO p : targetList) {
            try {
                // 고유 토큰 생성
                com.byd.util.AES128 aes128 = new com.byd.util.AES128("bydEventTokenKey");
                String encryptedSeq = aes128.encrypt(String.valueOf(p.getSeq()));
                String encodedToken = URLEncoder.encode(encryptedSeq, "UTF-8");

                // 요청하신 도메인으로 URL 세팅
                String ticketUrl = "https://byd-bimos2026.kr/apply/ticket?token=" + encodedToken;

                // 문자 발송 시 시승 시간을 예쁘게 구간으로 텍스트 변환
                String displayTime = p.getTestDriveTime();
                switch (displayTime) {
                    case "11:00": displayTime = "11:00 ~ 12:00"; break;
                    case "12:00": displayTime = "12:00 ~ 13:00"; break;
                    case "13:00": displayTime = "13:00 ~ 14:00"; break;
                    case "14:00": displayTime = "14:00 ~ 15:00"; break;
                    case "15:00": displayTime = "15:00 ~ 16:00"; break;
                    case "16:00": displayTime = "16:00 ~ 17:00"; break;
                    case "17:00": displayTime = "17:00 ~ 18:00"; break;
                }

                // 요청하신 메시지 양식 완벽 매핑
                String msg = "[BYD KOREA BIMOS 2026 시승 안내]\n\n" + p.getName() + "님\n" +
                        "예약하신 시승이 15분 후 시작됩니다.\n\n" +
                        "원활한 진행을 위해 BYD 시승 부스로\n" +
                        "방문해 주시기 바랍니다.\n\n" +
                        "접수 시 아래 모바일 티켓(QR)을 제시해 주세요.\n\n" +
                        "▶ 모바일 티켓 확인\n" +
                        ticketUrl + "\n\n" +
                        "※ 예약 시간 이후 도착 시 시승이 취소되거나 대기 순서가 변경될 수 있습니다.\n" +
                        "※ 음주자는 시승에 참여하실 수 없습니다.\n" +
                        "※ 실물 운전면허증을 반드시 지참해 주시기 바랍니다.";

                // 문자 전송 호출
                sendAligoCustomMessage(p.getPhone(), msg);
                System.out.println("15분 전 리마인드 발송 완료: " + p.getPhone());

            } catch (Exception e) {
                System.err.println("리마인드 문자 발송 중 오류 발생: " + p.getPhone());
                e.printStackTrace();
            }
        }
    }
}