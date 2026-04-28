package com.byd.vo;

import lombok.Data;

@Data
public class TeamVO {
    private String teamCode;    // PK (LG, KIA, ...)
    private String nameKr;      // 한글 팀명
    private String nameEn;      // 영문 팀명
    private String shortName;   // 약어
    private String logoUrl;     // 로고 이미지 경로
    private String mainColor;   // 메인 컬러 (#FFFFFF)
    private Integer sortOrder;  // 정렬 순서
    private String homepageUrl; // 구단 홈페이지
    private String logoImageUrl; // 로고이미지경로
    private String colorMainHex; // Color
}