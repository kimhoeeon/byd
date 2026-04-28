package com.byd.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.List;

@Data
public class ApiBaseballDTO {
    private List<ResponseData> response;

    @Data
    public static class ResponseData {
        private Fixture fixture;
        private Teams teams;
        private Scores scores;
        private Status status;
    }

    @Data
    public static class Fixture {
        private int id; // API 자체 게임 ID
        private String date; // 경기 일시 (ISO 8601)
    }

    @Data
    public static class Teams {
        private Team home;
        private Team away;
    }

    @Data
    public static class Team {
        private int id;
        private String name; // "LG Twins" 등
    }

    @Data
    public static class Scores {
        private TeamScore home;
        private TeamScore away;
    }

    @Data
    public static class TeamScore {
        private Integer total; // 현재 점수 (null일 수 있음)
    }

    @Data
    public static class Status {
        @JsonProperty("short")
        private String shortStatus; // "NS"(시작전), "LIVE", "FT"(종료) 등
    }
}