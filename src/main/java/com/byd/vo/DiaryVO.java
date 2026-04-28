package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class DiaryVO {
    private Long diaryId;
    private Long memberId;
    private Long gameId;
    private String nickname;
    private String memberName;
    private String memberEmail;
    private String profileImage;    // 작성자 프로필 이미지
    private String snapshotTeamCode; // 작성 당시 응원팀

    private String imageUrl;

    // [예측/결과 정보]
    private Integer predScoreHome;   // 예상 홈 점수
    private Integer predScoreAway;   // 예상 원정 점수
    private String predHero;         // 예상 히어로
    private String heroName;         // 오늘의 히어로

    private boolean isVerified;      // 직관 인증 여부
    private LocalDateTime verifiedAt;

    private String content;          // 본문
    private String oneLineComment;   // 한줄평
    private Integer rating;          // 평점 (1~5)

    private String status;           // PRE_SAVED, COMPLETED...
    private String isPublic;         // PUBLIC, FRIENDS, PRIVATE
    private String isPopular;        // 인기 게시물 여부 (Y/N)
    private int viewCount;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // [JOIN용 추가 필드] - 화면 표시용
    private String homeTeamCode;
    private String awayTeamCode;
    private String homeTeamName;
    private String awayTeamName;
    private String homeStarter;
    private String awayStarter;
    private int scoreHome;
    private int scoreAway;
    private String gameDate;         // yyyy-MM-dd
    private String gameTime;         // HH:mm
    private String gameType;
    private String stadiumName;
    private String gameResult;       // WIN, LOSE, DRAW (승요 서비스 계산용)
    private String gameStatus;

    private String shareUuid; // 공유용 UUID
    private String cancelReason;

    private String homeTeamLogo;
    private String awayTeamLogo;
}