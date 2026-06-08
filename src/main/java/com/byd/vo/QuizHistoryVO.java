package com.byd.vo;
import lombok.Data;

@Data
public class QuizHistoryVO {
    private int historySeq;
    private int userSeq;
    private String playDate;
    private int sessionNo;
    private String assignedQuestions;
    private int score;
    private String status;
    private String giftReceivedYn;
    private String regDate;
}