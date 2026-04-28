package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TermsVO {
    private Long termId;
    private String type;        // SERVICE, PRIVACY, LOCATION
    private String title;
    private String content;
    private String version;
    private String isRequired;  // Y, N
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 화면 표기용 헬퍼 메소드
    public String getTypeName() {
        if ("SERVICE".equals(type)) return "이용약관";
        if ("PRIVACY".equals(type)) return "개인정보처리방침";
        if ("LOCATION".equals(type)) return "위치정보 이용약관";
        return type;
    }
}