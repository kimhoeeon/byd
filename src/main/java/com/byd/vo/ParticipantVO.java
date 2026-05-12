package com.byd.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ParticipantVO {
    private Integer seq;                // PK
    private String entryType;           // 신청 구분
    private String name;                // 이름 (AES128 암호화/복호화 적용 대상)
    private String phone;               // 연락처 (AES128 암호화/복호화 적용 대상)
    private String email;               // 이메일 (기존 address 대체)
    private String shopInfo;            // 방문 가능 전시장
    private String carModel;            // 관심차량 정보 정보
    private String testDriveTime;       // 시승 신청 시간
    private String privacyAgree;        // 개인정보 수집·이용 동의
    private String thirdPartyAgree;     // 개인정보 제3자 제공 동의
    private String entrustAgree;        // 개인정보 처리 위탁 안내 및 동의
    private String mktAgree;            // 마케팅 활용 동의
    private String qrCodeUrl;           // QR 코드 URL
    private String challengeCheckYn;    // 챌린지 도착 여부 (Y/N)
    private String driveCheckYn;        // 시승 도착 여부 (Y/N)
    private String giftCheckYn;         // 경품 수령 여부 (Y/N)
    private Date regDate;               // 등록 일시
}