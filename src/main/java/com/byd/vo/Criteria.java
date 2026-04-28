package com.byd.vo;

import lombok.Data;

@Data
public class Criteria {
    private int pageNum;  // 현재 페이지
    private int amount;   // 한 페이지당 보여줄 개수

    private String type;  // 검색 조건 (E:이메일, N:닉네임 - 관리자용은 통합 검색이라 사용 안 할 수도 있음)
    private String keyword; // 검색어
    private String category;
    private String status;  // 필터 (ACTIVE, SUSPENDED, WITHDRAWN)

    private String isPopular;

    public Criteria() {
        this(1, 10);
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }
}