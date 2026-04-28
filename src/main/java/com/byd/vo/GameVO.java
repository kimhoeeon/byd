package com.byd.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime; // Import 추가

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameVO {

    private Long gameId;
    private String apiGameId;

    private String gameDate;           // 경기 날짜 (YYYY-MM-DD)
    private String gameTime;           // 경기 시간 (HH:mm:ss)

    private Integer stadiumId;
    private String homeTeamCode;
    private String awayTeamCode;

    private Integer scoreHome;
    private Integer scoreAway;

    private String status;

    private String etcInfo;

    private String homeStarter;   // 홈팀 선발투수 (DB: home_starter)
    private String awayStarter;   // 원정팀 선발투수 (DB: away_starter)
    private String cancelReason;

    private Long diaryId;

    private String myHero;

    private String mvpPlayer;       // MVP 선수

    // [Audit Fields] - 데이터 관리용
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ---------------------------------------------------------
    // [화면 표시 & 로직 처리용 필드] (DB 컬럼 아님)
    // ---------------------------------------------------------
    private String homeTeamName;
    private String awayTeamName;
    private String stadiumName;

    private String winningTeam;
    private String myPredictedTeam;

    // 로고 이미지 경로 (Mapper에서 조회)
    private String homeTeamLogo;
    private String awayTeamLogo;

    private String season;        // 시즌 (2025)
    private String gameType;      // 경기 종류 (EXHIBITION, REGULAR, POST, ALLSTAR)
    private String dhCode;        // 더블헤더 (0:없음, 1:1차전, 2:2차전) - 필요 시

    private String dataSource;    // API

    private Integer diaryCount;
}