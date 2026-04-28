package com.byd.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WinYoAnalysisDTO {
    // 1. 유저 기본 정보 (랭킹 및 프로필 조회용 추가)
    private Long memberId;
    private String nickname;
    private String profileImageUrl;
    private String myTeamCode;
    private Integer ranking;

    // 2. 기본 통계
    private int totalGames;         // 총 직관 수 (승률 산정 대상)
    private int winGames;           // 승리 수
    private int loseGames;          // 패배 수
    private int drawGames;          // 무승부 수

    // 3. 계산된 승률 (소수점 1자리까지, 예: 58.5)
    private double winRate;

    // 4. 분석 결과 코드
    private String winRateGrade;    // 승률 구간 코드
    private String countGrade;      // 직관 횟수 구간 코드
    private String trendCode;       // 최근 흐름 코드

    // 5. 노출용 멘트 및 타이틀 (DB 연동)
    private String rateLevelName;   // 승률 레벨명 (예: 🧢 멘탈 요원)
    private String rateMessage;     // 승률 멘트
    private String countLevelName;  // 직관 횟수 레벨명 (예: 🍼 응애 승요)
    private String countMessage;    // 횟수 멘트
    private String subMessage;      // 흐름 멘트

    // 6. 최다 방문 구장
    private String topStadium;
}