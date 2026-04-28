package com.byd.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class CommentDTO {
    private Long commentId;
    private Long diaryId;
    private Long memberId;      // 댓글 작성자
    private String content;
    private LocalDateTime createdAt;

    // JSP에서 사용하는 필드 추가
    private String email;       // 작성자 이메일
    private String delYn;       // 삭제 여부 (Y/N)

    // 리스트 표시용 (JOIN 데이터)
    private String diaryTeamCode; // 일기 당시 응원팀 (또는 현재 팀)
    private String diaryTitle;    // 일기 한줄평(제목)
    private String nickname;      // 댓글 작성자 닉네임 (필요 시)

    private String memberTeamCode;
    private String profileImage;  // 신규 추가: 프로필 이미지 경로

    private Long contentId;

    public String getRegDateStr() {
        if (this.createdAt == null) return "";
        return this.createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

}