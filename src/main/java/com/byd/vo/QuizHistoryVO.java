package com.byd.vo;
import lombok.Data;

@Data
public class QuizHistoryVO {
    private int historySeq;
    private int userSeq;
    private String playDate;
    private String assignedQuestions;
    private String userAnswers;
    private int score;
    private String status;
    private String giftReceivedYn;
    private String regDate;
}