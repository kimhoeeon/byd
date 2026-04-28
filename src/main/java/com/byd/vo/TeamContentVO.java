package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TeamContentVO {
    private Long contentId;
    private String teamCode;
    private String title;
    private String content;
    private String contentUrl;
    private Integer sortOrder;
    private int clickCount;
    private String status; // ACTIVE, INACTIVE
    private String imageUrl;
    private LocalDateTime createdAt;

    // 구단 로고 및 정보 매핑용 변수 추가
    private String logoImageUrl;
    private String teamNameKr;

    private int likeCount;
    private int sadCount;
    private int angryCount;

}