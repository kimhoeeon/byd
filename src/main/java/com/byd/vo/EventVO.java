package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class EventVO {
    private Long eventId;
    private String title;
    private String content;
    private String imageUrl;   // 대표 썸네일
    private String linkUrl;    // 외부 링크 주소
    private String linkType;   // 경로 타입 (BOARD, EXTERNAL)
    private String startDate;  // yyyy-MM-dd
    private String endDate;    // yyyy-MM-dd
    private String status;     // ACTIVE, INACTIVE
    private String createdAt;
    private String updatedAt;
}