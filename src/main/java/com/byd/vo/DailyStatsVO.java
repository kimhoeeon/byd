package com.byd.vo;

import lombok.Data;

@Data
public class DailyStatsVO {
    private String regDateStr; // 월.일 형식 (예: 04.21)
    private String entryType;  // EVENT 또는 DRIVE
    private int cnt;           // 해당 일자의 카운트
}