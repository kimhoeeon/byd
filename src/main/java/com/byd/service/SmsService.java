package com.byd.service;

import com.google.gson.Gson;
import com.byd.dto.SmsDTO;
import com.byd.dto.SmsResponseDTO;
import com.byd.mapper.MemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.HttpClients;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Slf4j
@Service
@RequiredArgsConstructor
public class SmsService {

    private final MemberMapper memberMapper;

    // 알리고 API 설정
    private final String SMS_URL = "https://apis.aligo.in/send/";
    private final String API_USER_ID = "meetingfan"; // 전달받은 ID
    private final String API_KEY = "ddefu9nx1etgljr1p1z1n9h7ri5u8mf0"; // 전달받은 Key
    private final String SENDER_PHONE = "07080953937"; // [설정필요] 알리고에 등록된 발신번호

    /**
     * 인증번호 발송 (API 호출 + DB 저장)
     */
    @Transactional
    public String sendVerificationCode(String phoneNumber) {
        // 1. 인증번호 생성 (6자리 난수)
        String authCode = generateRandomCode();

        // 2. 문자 내용 구성
        String message = "[승요일기] 인증번호는 [" + authCode + "] 입니다.";

        SmsDTO smsDTO = SmsDTO.builder()
                .receiver(phoneNumber)
                .sender(SENDER_PHONE)
                .message(message)
                .testmode_yn("N") // 실제 발송 시 "N", 테스트 시 "Y"
                .build();

        // 3. 알리고 API 전송 (전달받은 로직 활용)
        SmsResponseDTO response = smsSend(smsDTO);

        // 4. 결과 처리 및 DB 저장
        if ("1".equals(response.getResult_code())) {
            // 기존 인증 내역 삭제 (재요청 시)
            memberMapper.deleteAuthCode(phoneNumber);
            // 새 인증번호 저장 (만료시간 3분, 타입: SIGNUP)
            memberMapper.insertAuthCode(phoneNumber, authCode, "SIGNUP");
            return "ok";
        } else {
            log.error("SMS 전송 실패: code={}, msg={}", response.getResult_code(), response.getMessage());
            return "fail: " + response.getMessage();
        }
    }

    /**
     * 실제 알리고 API 호출 로직
     */
    public SmsResponseDTO smsSend(SmsDTO smsDTO) {
        String senderParam = smsDTO.getSender().replaceAll("-", "");
        String receiverParam = smsDTO.getReceiver().replaceAll("-", "");

        String result = "";
        try {
            final String encodingType = "UTF-8";
            final String boundary = "____boundary____";

            Map<String, String> sms = new HashMap<>();
            sms.put("user_id", API_USER_ID);
            sms.put("key", API_KEY);
            sms.put("msg", smsDTO.getMessage());
            sms.put("receiver", receiverParam);
            sms.put("sender", senderParam);
            sms.put("testmode_yn", smsDTO.getTestmode_yn() == null ? "" : smsDTO.getTestmode_yn());

            // MultipartEntityBuilder 설정
            MultipartEntityBuilder builder = MultipartEntityBuilder.create();
            builder.setBoundary(boundary);
            builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
            builder.setCharset(Charset.forName(encodingType));

            for (Map.Entry<String, String> entry : sms.entrySet()) {
                builder.addTextBody(entry.getKey(), entry.getValue(),
                        ContentType.create("Multipart/related", Charset.forName(encodingType)));
            }

            HttpClient client = HttpClients.createDefault();
            HttpPost post = new HttpPost(SMS_URL);
            post.setEntity(builder.build());

            HttpResponse res = client.execute(post);

            if (res != null) {
                BufferedReader in = new BufferedReader(new InputStreamReader(res.getEntity().getContent(), encodingType));
                String buffer;
                while ((buffer = in.readLine()) != null) {
                    result += buffer;
                }
                in.close();
            }

        } catch (Exception e) {
            log.error("Aligo API 연동 중 오류 발생", e);
            return new SmsResponseDTO();
        }

        Gson gson = new Gson();
        SmsResponseDTO responseDTO = gson.fromJson(result, SmsResponseDTO.class);
        log.info("Msg Send Response : {}", responseDTO);

        return responseDTO;
    }

    /**
     * 인증번호 검증
     */
    @Transactional
    public boolean verifyCode(String phoneNumber, String inputCode) {
        String savedCode = memberMapper.selectAuthCode(phoneNumber);
        LocalDateTime expireTime = memberMapper.selectAuthCodeExpireTime(phoneNumber);

        if (savedCode == null) return false; // 요청 내역 없음
        if (expireTime.isBefore(LocalDateTime.now())) return false; // 시간 만료
        if (!savedCode.equals(inputCode)) return false; // 불일치

        // 인증 성공 처리
        memberMapper.updateAuthCodeVerified(phoneNumber);
        return true;
    }

    // ... 기존 코드 ...

    /**
     * 임시 비밀번호 발송
     */
    public void sendTempPassword(String phoneNumber, String tempPassword) {
        String message = "[승요일기] 임시 비밀번호는 [" + tempPassword + "] 입니다. 로그인 후 변경해주세요.";

        SmsDTO smsDTO = SmsDTO.builder()
                .receiver(phoneNumber)
                .sender(SENDER_PHONE) // 기존 상수 사용
                .message(message)
                .testmode_yn("N")
                .build();

        smsSend(smsDTO); // 기존 전송 메서드 재사용
    }

    private String generateRandomCode() {
        Random rand = new Random();
        StringBuilder numStr = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            numStr.append(rand.nextInt(10));
        }
        return numStr.toString();
    }
}