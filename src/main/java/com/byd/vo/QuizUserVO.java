package com.byd.vo;
import lombok.Data;
import java.util.List;

@Data
public class QuizUserVO {
    private int userSeq;
    private String name;
    private String phone;
    private String email;
    private String region;
    private String shopInfo;
    private String carModelCode;
    private String privacyAgree;
    private String regDate;

    // 관리자 페이지 조회를 위한 1:N 이력 리스트 매핑
    private List<QuizHistoryVO> historyList;
}