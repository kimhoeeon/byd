package com.byd.service;

import com.byd.mapper.EventMapper;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

@Slf4j
@Service
@RequiredArgsConstructor
public class EventService {

    private final EventMapper eventMapper;

    public ParticipantVO getParticipantByPhone(String phone) {
        return eventMapper.getParticipantByPhone(phone);
    }

    public ParticipantVO getParticipantByPhoneToday(String phone) {
        return eventMapper.getParticipantByPhoneToday(phone);
    }

    public ParticipantVO getParticipantBySeq(int seq) {
        return eventMapper.getParticipantBySeq(seq);
    }

    public void insertParticipant(ParticipantVO participantVO) {
        eventMapper.insertParticipant(participantVO);
    }

    public void updateParticipant(ParticipantVO vo, boolean updateRegDate) {
        eventMapper.updateParticipant(vo, updateRegDate);
    }

    // Aligo API SMS 발송 로직
    public void sendNotificationSms(ParticipantVO p, String ticketUrl) {
        try {
            String aligoKey = "ddefu9nx1etgljr1p1z1n9h7ri5u8mf0";          // 알리고 API KEY
            String aligoId = "meetingfan";           // 알리고 사용자 ID
            String sender = "07089498065";           // 사전에 등록된 발신자 번호 (ex. 0212345678)

            // 일반 이벤트 참여자 전용 안내 문자
            String title = "[2026 부산 모빌리티쇼 BYD 참여 티켓]\n\n";
            String greeting = "신청이 완료되었습니다.";
            String message = title +
                    p.getName() + "님, " + greeting + "\n" +
                    "현장 데스크에서 아래 링크의 모바일 티켓(QR)을 보여주세요.\n\n" +
                    "▶ 모바일 티켓 보기:\n" + ticketUrl;

            // 알리고 요청 파라미터 세팅
            Map<String, String> params = new LinkedHashMap<>();
            params.put("key", aligoKey);
            params.put("user_id", aligoId);
            params.put("sender", sender);
            params.put("receiver", p.getPhone());
            params.put("msg", message);
            // params.put("testmode_yn", "Y"); // 테스트 모드 (실제 발송 안 됨, 개발 시 주석 해제)

            StringBuilder postData = new StringBuilder();
            for (Map.Entry<String, String> param : params.entrySet()) {
                if (postData.length() != 0) postData.append('&');
                postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
                postData.append('=');
                postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
            }

            // 알리고 SMS 전송 API 엔드포인트
            URL url = new URL("https://apis.aligo.in/send/");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

            // 요청 데이터 전송
            try (OutputStream os = conn.getOutputStream()) {
                os.write(postData.toString().getBytes("UTF-8"));
                os.flush();
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                    String inputLine;
                    StringBuilder response = new StringBuilder();
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    log.info("▶ [알리고 문자 전송 완료] 수신자: {}, 결과: {}", p.getPhone(), response.toString());
                }
            } else {
                log.error("▶ [알리고 에러] HTTP 응답 코드 오류: {}", responseCode);
            }
        } catch (Exception e) {
            log.error("▶ [알리고 예외 발생] 문자 발송 실패: {}", e.getMessage());
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
}