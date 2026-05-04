package com.byd.service;

import com.byd.mapper.EventMapper;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventMapper eventMapper;

    public ParticipantVO getParticipantByPhone(String phone){
        return eventMapper.getParticipantByPhone(phone);
    }

    public ParticipantVO getParticipantByPhoneToday(String phone){
        return eventMapper.getParticipantByPhoneToday(phone);
    }

    public Map<String, Integer> getDriveTimeCountToday() {
        List<Map<String, Object>> countList = eventMapper.getDriveTimeCountToday();
        Map<String, Integer> resultMap = new HashMap<>();

        for(Map<String, Object> map : countList) {
            String time = (String) map.get("testDriveTime");
            Number cnt = (Number) map.get("cnt");
            resultMap.put(time, cnt.intValue());
        }
        return resultMap;
    }

    public int getDriveTimeCount(String testDriveTime) {
        return eventMapper.getDriveTimeCount(testDriveTime);
    }

    public void insertParticipant(ParticipantVO participantVO) {

        // 백엔드 단위 4명 정원 검증 로직
        if(!"시승 미신청".equals(participantVO.getTestDriveTime())) {
            int currentCount = eventMapper.getDriveTimeCount(participantVO.getTestDriveTime());
            if(currentCount >= 4) {
                throw new IllegalStateException("해당 시간대는 이미 마감되었습니다.");
            }

            // 2. 3일간 시승 행사 1회 참여 제한 검증 (이전 날짜 포함)
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
            participantVO.setEntryType("오프라인코드 4040");
        }

        eventMapper.insertParticipant(participantVO);
    }

    public ParticipantVO getParticipantBySeq(int seq) {
        return eventMapper.getParticipantBySeq(seq);
    }

    public void updateParticipant(ParticipantVO participantVO) {

        // 정보 수정 시에도 시승을 새롭게 신청/변경하는 경우 1회 제한 검증
        if(!"시승 미신청".equals(participantVO.getTestDriveTime())) {
            int historyCount = eventMapper.checkTestDriveHistory(participantVO.getPhone(), participantVO.getSeq());
            if(historyCount > 0) {
                throw new IllegalArgumentException("행사 기간 중 시승 신청은 1회만 가능합니다.");
            }
        }

        eventMapper.updateParticipant(participantVO);
    }

    // Aligo API SMS 발송 로직
    public boolean sendAligoSms(String receiverPhone, String name, String ticketUrl) {
        try {
            String aligoKey = "ddefu9nx1etgljr1p1z1n9h7ri5u8mf0";          // 알리고 API KEY
            String aligoId = "meetingfan";           // 알리고 사용자 ID
            String sender = "07089498065";           // 사전에 등록된 발신자 번호 (ex. 0212345678)

            // 알리고 SMS 전송 API 엔드포인트
            String apiUrl = "https://apis.aligo.in/send/";

            String message = "[BYD 시승 신청]\n" +
                    name + "님, 시승 신청이 완료되었습니다.\n" +
                    "현장 데스크에서 아래 링크의 모바일 티켓(QR)을 보여주세요.\n\n" +
                    "▶ 모바일 티켓 보기:\n" + ticketUrl;

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
}