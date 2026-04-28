package com.byd.vo;

import lombok.Data;

@Data
public class UserStatsVO {
    private Long memberId;
    private String nickname;
    private String myTeamCode;   // 응원 구단
    private String myTeamName;   // 구단명

    private int totalGames;      // 총 직관 수 (일기 수)
    private int winGames;        // 승리 횟수
    private int loseGames;       // 패배 횟수
    private int drawGames;       // 무승부/취소 등

    private double winRate;      // 승률 (%)
    private int ranking;         // 순위
}