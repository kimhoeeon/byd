package com.byd.vo;

import lombok.Data;

@Data
public class ParticipantVO {
    private int seq;               // 일련번호
    private String entryType;      // 신청 구분 (EVENT/DRIVE)
    private String name;           // 이름
    private String phone;          // 연락처
    private String address;        // 주소
    private String shopInfo;       // 전시장 정보
    private String carModel;       // 관심/시승 차량 정보
    private String testDriveTime;  // 시승 신청 시간
    private String mktAgree;       // 마케팅 동의 (Y/N)
    private String safetyAgree;    // 시승 안전 동의 (Y/N)
    private String qrCodeUrl;      // QR 코드 URL
    private String qrScanTime;     // QR 스캔(현장 확인) 일시
    private String regDate;        // 등록 일시
}