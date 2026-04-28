package com.byd.dto;

import lombok.Data;

@Data
public class FollowDTO {
    private Long memberId;      // 회원 PK
    private String nickname;    // 닉네임
    private String myTeamCode;  // 팀 코드 (LG, KT...)
    private String myTeamName;  // 팀 이름 (LG 트윈스...)

    private int winRate;        // 승요력 (승률 %)
    private boolean isMutual;   // 맞팔 여부 (서로 팔로우 중)

    // 관계 상태
    // 1. 내가 팔로잉 목록을 볼 때 -> 항상 true (취소 버튼)
    // 2. 내가 팔로워 목록을 볼 때 -> 맞팔이면 true, 아니면 false (팔로우 버튼)
    private boolean isFollowing;
}