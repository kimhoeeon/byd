package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class WinYoMentionVO {
    private Long mentionId;
    private String category;       // WIN_RATE, ATTENDANCE_COUNT, RECENT_TREND
    private String conditionCode;  // LEVEL1, CNT1, UP 등
    private String levelName;      // 레벨 명
    private String message;        // 노출 멘트
    private Integer minVal;        // 최소값
    private Integer maxVal;        // 최대값
    private Integer priority;      // 우선순위
    private String description;    // 관리자용 설명
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}