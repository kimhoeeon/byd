package com.byd.vo;

import lombok.Data;

@Data
public class ParticipantVO {
    private int seq;
    private String entryType;    // 신청 구분 (EVENT: 일반참여, DRIVE: 시승신청)
    private String name;         // 이름
    private String phone;        // 연락처
    private String address;      // 주소
    private String shopInfo;     // 전시장 정보 (추가됨)
    private String carModel;     // 관심차량 정보
    private String testDriveTime;// 시승 시간 (시승 신청 시에만)
    private String mktAgree;     // 마케팅 동의 여부 (Y/N)
    private String safetyAgree;  // 시승 안전 동의 여부 (Y/N)
    private String qrCodeUrl;    // QR코드 URL
    private String qrScanTime;   // QR 스캔 시간 (관리자 도착 확인용)
    private String regDate;      // 등록일
}