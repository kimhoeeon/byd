package com.byd.vo;

import lombok.Data;

@Data
public class Criteria {
    private int pageNum;      // 현재 페이지 번호
    private int amount;       // 페이지당 출력 데이터 수
    private String searchType;// 검색 조건 (name, phone)
    private String keyword;   // 검색어
    private String arrivalStatus; // 방문 상태 필터 (Y/N)
    private String startDate; // 검색 시작일 (예: yyyy-mm-dd)
    private String endDate; // 검색 종료일 (예: yyyy-mm-dd)

    public Criteria() {
        this.pageNum = 1;
        this.amount = 10;
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }

    // MyBatis 쿼리에서 #{pageStart}로 호출하여 사용
    public int getPageStart() {
        return (this.pageNum - 1) * this.amount;
    }
}