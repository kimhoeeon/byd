package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class FaqVO {
    private Long faqId;
    private String category;   // MEMBER, DIARY, GAME, ETC
    private String question;
    private String answer;
    private Integer sortOrder;
    private String isVisible;  // Y, N
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getCategoryName() {
        if ("MEMBER".equals(category)) return "회원/계정";
        if ("DIARY".equals(category)) return "일기/기록";
        if ("GAME".equals(category)) return "경기/데이터";
        return "기타";
    }
}