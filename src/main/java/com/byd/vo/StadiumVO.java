package com.byd.vo;

import lombok.Data;

@Data
public class StadiumVO {
    private Integer stadiumId;    // PK
    private String name;          // 경기장 이름
    private String shortName;
    private String address;       // 주소
    private Integer capacity;     // 수용 인원
    private String teamCode;      // 홈 구단 코드 (NULL 가능)
    private Double lat; // 위도
    private Double lon; // 경도
}