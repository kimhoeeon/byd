package com.byd.vo;

import com.byd.util.StringUtil;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class MemberVO {
    private Long memberId;          // PK
    private String email;           // 로그인 ID
    private String password;
    private String nickname;
    private String phoneNumber;     // 본인인증된 번호
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate birthdate;    // 생년월일 (통계용)
    private String gender;          // 'M', 'F', 'U'
    private String myTeamCode;      // 응원팀 코드
    private String myTeamName;      // 화면 표시용 팀 이름 (DB join 결과)
    private LocalDateTime teamChangeDate;
    private String socialProvider;  // 'NONE', 'KAKAO', 'APPLE'
    private String socialUid;
    private String role;            // 'USER', 'ADMIN'
    private String status;          // 'ACTIVE', 'INACTIVE' 등
    private String pushYn;        // 전체 알림 (push_yn)
    private String gameAlarm;     // 경기 알림 (game_alarm)
    private String friendAlarm;   // 친구 알림 (friend_alarm)
    private String marketingAgree;
    private String profileImage; // 프로필 이미지 경로
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private LocalDateTime nicknameUpdatedAt; // 닉네임 마지막 변경 일시

    // [Appify] 기기 정보 수집 필드
    private String fcmToken;
    private String devicePlatform; // device_platform
    private String deviceModel;    // device_model
    private String osVersion;      // os_version
    private String appVersion;     // app_version
    private String deviceUuid;     // device_uuid

    // [관리자 목록 표시용 통계 필드]
    private Integer monthlyVisitCount; // 이번 달 방문 횟수
    private String winRateStr;     // 승률 (예: "84% (7승 5패)")

    private Integer monthlyAttendanceCount; // 이번달 직관 횟수
    private Integer followingCount;         // 팔로잉 수 (내가 팔로우함)
    private Integer followerCount;          // 팔로워 수 (나를 팔로우함)
    private Integer winCount;               // 승리 횟수
    private Integer loseCount;              // 패배 횟수
    private Integer drawCount;              // 무승부 횟수

    private boolean isFollowing;

    private Integer totalAttendanceCount;   // 누적 직관 횟수
    private String mostVisitedStadium;      // 최다 방문 구장
    private Integer mutualFollowCount;      // 맞팔 수

    private String myTeamLogoUrl;

    // 화면 및 엑셀 출력 시 하이픈이 추가된 전화번호 반환
    public String getFormattedPhoneNumber() {
        return StringUtil.formatPhone(this.phoneNumber);
    }

}
