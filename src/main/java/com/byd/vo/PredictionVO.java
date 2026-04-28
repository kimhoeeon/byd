package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class PredictionVO {
    private Long predictionId;
    private Long memberId;
    private Long gameId;
    private String predictedTeam; // 팀 코드
    private Boolean isCorrect;
    private Boolean isAlarmSent;
    private LocalDateTime createdAt; // 생성일
    private LocalDateTime updatedAt; // 수정일 (결과 처리 시 갱신됨)

    // [화면 표시용 JOIN 데이터]
    private String homeTeamCode;
    private String awayTeamCode;
    private String homeTeamName;
    private String awayTeamName;
    private int scoreHome;
    private int scoreAway;
    private String gameDate;
    private String gameTime;
    private String stadiumName;
    private String gameStatus; // PRE, LIVE, END, CANCEL
}