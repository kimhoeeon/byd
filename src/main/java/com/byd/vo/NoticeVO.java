package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class NoticeVO {
    private Long noticeId;
    private String category;
    private String title;
    private String content;
    private String imageUrl;
    private String isTop;      // Y, N
    private Integer viewCount;
    private String status;     // ACTIVE, HIDDEN
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}