package com.byd.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ParticipantVO {
    private Integer seq;                // PK
    private String entryType;           // 신청 구분
    private String name;                // 이름 (AES128 암호화/복호화 적용 대상)
    private String phone;               // 연락처 (AES128 암호화/복호화 적용 대상)
    private String address;             // 주소
    private String shopInfo;            // 전시장 정보
    private String carModel;            // 관심/시승 차량 정보
    private String testDriveTime;       // 시승 신청 시간
    private String mktAgree;            // 마케팅 동의 (Y/N)
    private String safetyAgree;         // 시승 안전 동의 (Y/N)
    private String qrCodeUrl;           // QR 코드 URL
    private String challengeCheckYn;    // 챌린지 도착 여부 (Y/N)
    private String driveCheckYn;        // 시승 도착 여부 (Y/N)
    private Date regDate;               // 등록 일시
}