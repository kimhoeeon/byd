package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class LockerVO {
    private Long postId;
    private String type;
    private Long memberId;
    private String category;    // TALK, MEETUP, MARKET
    private String title;
    private String content;
    private String imageUrl;
    private int viewCount;
    private int commentCount;
    private String createdDate; // 작성일 (화면 표시용)
    private int offset;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // [필수 추가] 이벤트 기간
    private String startDate;
    private String endDate;

    // [화면 표시용 JOIN 데이터]
    private String nickname;        // 작성자 닉네임
    private String teamCode;        // 작성자 응원팀
    private String memberImage;     // 작성자 프로필 사진 (필요 시)

    // [화면용 유틸]
    private String timeAgo;         // "1시간 전", "방금 전" 등 표시용

    // [페이징용 필드 추가]
    private int page = 1;       // 현재 페이지 (기본 1)
    private int size = 10;      // 페이지당 개수 (기본 10)

    // 쿼리에서 사용할 offset 계산
    public int getOffset() {
        return (page - 1) * size;
    }
}