package com.byd.vo;
import lombok.Data;

import java.util.Date;

@Data
public class QuizLiveSessionVO {
    private String playDate;
    private int sessionNo;
    private int currentQuestionNo;
    private String status;
    private String assignedQuestions;
    private Date updatedAt;
}