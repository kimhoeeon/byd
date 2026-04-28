package com.byd.dto;

import lombok.Data;
import java.util.List;
import java.util.Map;

@Data
public class NaverGameDTO {
    // 날짜별 경기 목록을 담은 맵 (key: "20250505" 형태)
    private Map<String, List<NaverGame>> meals; // 네이버 API 특성상 필드명이 유동적일 수 있으나 보통 리스트 형태

    @Data
    public static class NaverGame {
        private String gameId;        // 네이버 고유 경기 ID (예: 20250505LGKT0)
        private String gameDate;      // 2025-05-05
        private String gameTime;      // 18:30
        private String stadium;       // 잠실
        private String homeTeamName;  // LG
        private String awayTeamName;  // KT
        private Integer homeScore;    // 5
        private Integer awayScore;    // 2
        private String gameState;     // FINISHED, CANCEL, BEFORE
    }
}