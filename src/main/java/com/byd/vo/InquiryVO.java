package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class InquiryVO {
    private Long inquiryId;
    private Long memberId;
    private String type;      // ACCOUNT, USE, BUG, ETC
    private String title;
    private String content;
    private String answer;
    private String status;    // WAITING, COMPLETED
    private LocalDateTime createdAt;
    private LocalDateTime answeredAt;

    // 조인 데이터 (작성자 정보)
    private String memberName;  // 닉네임
    private String memberEmail; // 이메일

    // 화면 표시용
    public String getTypeName() {
        if ("ACCOUNT".equals(type)) return "계정문의";
        if ("USE".equals(type)) return "이용문의";
        if ("BUG".equals(type)) return "오류신고";
        return "기타";
    }
}