package com.byd.vo;

import lombok.Data;

@Data
public class StatsVO {
    private int totalCnt;       // 누적 신청자 수
    private int todayCnt;       // 금일 신규 신청
    private int qrCheckCnt;     // 현장 확인(도착) 완료
    private int driveWaitCnt;   // 미도착 (대기)
}