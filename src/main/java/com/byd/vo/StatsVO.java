package com.byd.vo;

import lombok.Data;

@Data
public class StatsVO {
    private int totalCnt;       // 누적 신청자 수
    private int todayCnt;       // 금일 신규 신청
    private int qrCheckCnt;     // QR 현장 확인 (이벤트 참여자 중 도착자)
    private int driveWaitCnt;   // 시승 대기 (시승 신청자 중 미도착자)
    private int eventCnt;       // 일반 이벤트 누적 수
    private int driveCnt;       // 시승 신청 누적 수
}