package com.byd.service;

import com.byd.constants.CommConstants;
import com.byd.dto.MailRequestDTO;
import com.byd.dto.ResponseDTO;
import com.byd.vo.DevFileVO;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Slf4j
@Service
public class DirectSendService {

    // [설정] DirectSend 계정 정보 (상수 또는 properties 관리 권장)
    private final String SENDER_EMAIL = "jw.woo@creative-lab.ai";
    private final String SENDER_NAME = "승요일기"; // 발신자명
    private final String USERNAME = "meetingfan";
    private final String API_KEY = "L7QNsEQIyrAzNHO";
    private final String API_URL = "https://directsend.co.kr/index.php/api_v2/mail_change_word";

    @SuppressWarnings("unchecked")
    public ResponseDTO processMailSend(MailRequestDTO mailRequestDTO) {
        log.info("DirectSendService > processMailSend: {}", mailRequestDTO.getSubject());
        ResponseDTO responseDto = new ResponseDTO();

        try {
            URL obj = new URL(API_URL);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setRequestProperty("Cache-Control", "no-cache");
            con.setRequestProperty("Content-Type", "application/json;charset=utf-8");
            con.setRequestProperty("Accept", "application/json");

            // 1. 본문 구성 (첨부파일 개수 추가)
            String subject = mailRequestDTO.getSubject();
            StringBuilder bodyBuilder = new StringBuilder(mailRequestDTO.getBody());

            List<DevFileVO> files = mailRequestDTO.getFileUrl();
            if (files != null && !files.isEmpty()) {
                bodyBuilder.append("\n\n---------------------------------\n");
                bodyBuilder.append("※ 첨부파일: ").append(files.size()).append("개");
                // 필요하다면 파일명도 나열 가능
                // for(DevFileVO f : files) bodyBuilder.append("\n - ").append(f.getOrgFileName());
            }

            // 따옴표 처리 및 본문 완성
            String body = bodyBuilder.toString().replaceAll("\"", "'");

            // 2. 수신자 정보 (JSON Array)
            JSONArray jsonArray = new JSONArray();
            if (mailRequestDTO.getReceiver() != null) {
                for (MailRequestDTO.Receiver r : mailRequestDTO.getReceiver()) {
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("email", r.getEmail());
                    // 이름, 휴대폰 등 필요 시 추가
                    jsonArray.add(jsonObject);
                }
            }
            String receiver = jsonArray.toJSONString();

            // 3. JSON 파라미터 조립 (첨부파일 파라미터 제외됨)
            String urlParameters = "\"subject\":\"" + subject + "\" "
                    + ", \"body\":\"" + body + "\" "
                    + ", \"sender\":\"" + SENDER_EMAIL + "\" "
                    + ", \"sender_name\":\"" + SENDER_NAME + "\" "
                    + ", \"username\":\"" + USERNAME + "\" "
                    + ", \"receiver\":" + receiver;

            if (mailRequestDTO.getTemplate() != null && !mailRequestDTO.getTemplate().isEmpty()) {
                urlParameters += ", \"template\":\"" + mailRequestDTO.getTemplate() + "\" ";
            }

            urlParameters += ", \"key\":\"" + API_KEY + "\" ";
            urlParameters = "{" + urlParameters + "}";

            log.debug("DirectSend Params: {}", urlParameters);

            // 4. 전송 실행
            System.setProperty("jsse.enableSNIExtension", "false");
            con.setDoOutput(true);
            OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream(), StandardCharsets.UTF_8);
            wr.write(urlParameters);
            wr.flush();
            wr.close();

            // 5. 결과 처리
            int responseCode = con.getResponseCode();
            BufferedReader in = new BufferedReader(new java.io.InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            log.info("DirectSend Response: {}", response.toString());

            JSONParser parser = new JSONParser();
            JSONObject responseObj = (JSONObject) parser.parse(response.toString());

            if (responseObj.get("status") != null) {
                String mailResponseCode = String.valueOf(responseObj.get("status"));
                if ("0".equals(mailResponseCode)) {
                    responseDto.setResultCode(CommConstants.RESULT_CODE_SUCCESS);
                    responseDto.setResultMessage("성공");
                } else {
                    responseDto.setResultCode(CommConstants.RESULT_CODE_FAIL);
                    responseDto.setResultMessage("[" + mailResponseCode + "] " + responseObj.get("msg"));
                }
            } else {
                responseDto.setResultCode(CommConstants.RESULT_CODE_FAIL);
                responseDto.setResultMessage("응답 형식 오류");
            }

        } catch (IOException | ParseException e) {
            log.error("Mail Send Fail", e);
            responseDto.setResultCode(CommConstants.RESULT_CODE_FAIL);
            responseDto.setResultMessage(e.getMessage());
        }

        return responseDto;
    }
}