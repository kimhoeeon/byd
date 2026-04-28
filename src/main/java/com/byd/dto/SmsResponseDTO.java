package com.byd.dto;

import lombok.Data;

@Data
public class SmsResponseDTO {
    private String result_code; // 결과코드 (1:성공, 그외:실패)
    private String message;     // 결과문구
    private String msg_id;      // 메세지ID
    private int success_cnt;    // 성공갯수
    private int error_cnt;      // 에러갯수
    private String msg_type;    // SMS, LMS, MMS
}