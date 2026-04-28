package com.byd.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SmsDTO {
    private String receiver; // 수신번호
    private String sender;   // 발신번호
    private String message;  // 내용
    private String testmode_yn; // 테스트 모드 여부 (Y/N)
}