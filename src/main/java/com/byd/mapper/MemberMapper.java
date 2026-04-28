package com.byd.mapper;

import com.byd.dto.FollowDTO;
import com.byd.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface MemberMapper {

    // 1. 회원 가입 (Insert)
    int insertMember(MemberVO member);

    // 2. ID(Email) 중복 체크 및 로그인 정보 조회
    MemberVO selectMemberByEmail(String email);

    // 3. 닉네임 중복 체크
    int countByNickname(String nickname);

    // 연락처 중복 체크
    int countByPhoneNumber(@Param("phoneNumber") String phoneNumber);

    // 가입 제한 체크용: 전화번호로 모든 상태의 회원 이력 조회
    List<MemberVO> selectMembersByPhoneNumber(@Param("phoneNumber") String phoneNumber);

    // 4. 회원 정보 상세 조회 (PK 기준)
    MemberVO selectMemberById(Long memberId);

    // 5. 로그인 성공 시 최근 접속일 업데이트
    void updateLastLogin(Long memberId);

    // 6. 회원 정보 수정 (닉네임, 연락처, 생년월일, 성별 등)
    int updateMemberInfo(MemberVO member);

    // 7. 비밀번호 변경
    int updatePassword(@Param("memberId") Long memberId, @Param("newPassword") String newPassword);

    // 8. 응원팀 변경 (온보딩 및 설정 변경용) - [복구됨]
    int updateMemberTeam(MemberVO member);

    // 9. 회원 탈퇴 (상태값 변경)
    int withdrawMember(Long memberId);

    // [관리자] 회원 목록 조회
    List<MemberVO> selectMemberList(@Param("offset") int offset,
                                    @Param("limit") int limit,
                                    @Param("searchType") String searchType,
                                    @Param("keyword") String keyword);

    // [관리자] 전체 회원 수 조회
    int countMemberList(@Param("searchType") String searchType,
                        @Param("keyword") String keyword);

    // SMS 인증 관련 (auth_codes 테이블)
    void deleteAuthCode(@Param("phoneNumber") String phoneNumber);

    void insertAuthCode(@Param("phoneNumber") String phoneNumber,
                        @Param("authCode") String authCode,
                        @Param("type") String type);

    String selectAuthCode(@Param("phoneNumber") String phoneNumber);

    LocalDateTime selectAuthCodeExpireTime(@Param("phoneNumber") String phoneNumber);

    void updateAuthCodeVerified(@Param("phoneNumber") String phoneNumber);

    // 생년월일과 전화번호로 회원 찾기
    MemberVO findMemberByBirthAndPhone(@Param("birthdate") String birthdate,
                                       @Param("phoneNumber") String phoneNumber);

    // 이름과 전화번호로 회원 찾기
    MemberVO findMemberByNameAndPhone(@Param("userName") String userName, @Param("phoneNumber") String phoneNumber);

    // 닉네임 변경 전용 메소드
    void updateNickname(@Param("memberId") Long memberId, @Param("nickname") String nickname);

    // 알림 설정 변경
    void updateAlarmSetting(MemberVO member);

    // 팔로우 관련
    int checkFollow(@Param("followerId") Long followerId, @Param("followingId") Long followingId);

    int insertFollow(@Param("followerId") Long followerId, @Param("followingId") Long followingId);

    int deleteFollow(@Param("followerId") Long followerId, @Param("followingId") Long followingId);

    // 목록 조회
    List<FollowDTO> selectFollowerList(@Param("targetMemberId") Long targetMemberId, @Param("myMemberId") Long myMemberId);

    List<FollowDTO> selectFollowingList(@Param("targetMemberId") Long targetMemberId);

    List<MemberVO> searchMembers(@Param("keyword") String keyword, @Param("myMemberId") Long myMemberId);

    int countTodayMembers();

    MemberVO findMemberByEmailAndPhone(@Param("email") String email, @Param("phoneNumber") String phoneNumber);

    void updatePushToken(@Param("memberId") Long memberId, @Param("token") String token);

    // 기기 정보 업데이트
    void updateDeviceInfo(MemberVO member);

    // 소셜 로그인 조회
    MemberVO selectBySocialId(@Param("socialProvider") String socialProvider,
                              @Param("socialUid") String socialUid);

    // 소셜 회원 가입
    void insertSocialMember(MemberVO member);

    // 소셜 정보 업데이트 (계정 연동)
    void updateSocialInfo(MemberVO member);

    // 경기 상태 알림을 받을 대상 회원 조회
    List<MemberVO> selectMembersForGameAlarm(@Param("homeTeamCode") String homeTeamCode, @Param("awayTeamCode") String awayTeamCode);

    void insertAccessLog(Long memberId);

    List<MemberVO> selectGameParticipants(@Param("gameId") Long gameId, @Param("homeTeam") String homeTeam, @Param("awayTeam") String awayTeam);

}