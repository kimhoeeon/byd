package com.byd.vo;
import lombok.Data;

@Data
public class QuizQuestionVO {
    private int questionId;
    private String questionText;
    private String choice1;
    private String choice2;
    private String choice3;
    private String choice4;
    private int correctAnswer; // (주의: 프론트엔드로 내려줄 땐 정답을 숨겨야 함)
}