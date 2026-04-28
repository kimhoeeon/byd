package com.byd.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.firebase.messaging.*;
import com.byd.dto.FollowDTO;
import com.byd.dto.SmsDTO;
import com.byd.exception.AlertException;
import com.byd.mapper.MemberMapper;
import com.byd.util.SHA512;
import com.byd.util.StringUtil;
import com.byd.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberMapper memberMapper;
    private final SHA512 sha512;
    private final SmsService smsService; // 문자 발송을 위해 주입
    private final AlarmService alarmService; // 알림 서비스 주입

    /**
     * 회원 가입 처리
     */
    @Transactional
    public void registerMember(MemberVO member) throws Exception {

        // [애플 심사 대응] 소셜 유저인데 이메일이 비어있는 경우(이메일 숨기기 등) 더미 이메일 발급
        if (member.getSocialProvider() != null && !member.getSocialProvider().equals("NONE")) {
            if (member.getEmail() == null || member.getEmail().trim().isEmpty()) {
                String dummyEmail = member.getSocialProvider().toLowerCase() + "_" + member.getSocialUid() + "@dummy.viotory.com";
                member.setEmail(dummyEmail);
            }
        }
        
        // [금칙어 검사 추가]
        if (StringUtil.containsBannedWord(member.getEmail())) {
            throw new AlertException("이메일에 부적절한 단어가 포함되어 있습니다.");
        }
        if (StringUtil.containsBannedWord(member.getNickname())) {
            throw new AlertException("닉네임에 부적절한 단어가 포함되어 있습니다.");
        }

        // 1. 만 14세 미만 가입 불가 체크
        if (member.getBirthdate() != null) {
            int age = Period.between(member.getBirthdate(), LocalDate.now()).getYears();
            if (age < 14) {
                throw new AlertException("만 14세 미만은 가입할 수 없습니다.");
            }
        }

        // 비밀번호 복잡도 체크는 일반 가입일 경우에만 체크
        if ("NONE".equals(member.getSocialProvider()) || member.getSocialProvider() == null) {
            if (!isValidPassword(member.getPassword())) {
                throw new AlertException("비밀번호는 8~14자이며, 영문/숫자/특수문자 중 2개 이상을 포함해야 합니다.");
            }
        }

        // 3. 중복 체크
        if (memberMapper.selectMemberByEmail(member.getEmail()) != null) {
            throw new AlertException("이미 가입된 이메일입니다.");
        }
        if (memberMapper.countByNickname(member.getNickname()) > 0) {
            throw new AlertException("이미 사용 중인 닉네임입니다.");
        }

        // 연락처 중복 및 가입 제한 2차 체크 (이메일 / 카카오 공통 적용)
        if (member.getPhoneNumber() != null && !member.getPhoneNumber().isEmpty()) {
            String cleanPhone = member.getPhoneNumber().replaceAll("-", "");

            List<MemberVO> historyMembers = memberMapper.selectMembersByPhoneNumber(cleanPhone);

            for (MemberVO hist : historyMembers) {
                if ("SUSPENDED".equals(hist.getStatus())) {
                    throw new AlertException("운영정책 위반으로 영구 정지된 연락처이므로 가입할 수 없습니다.");
                }
                if ("ACTIVE".equals(hist.getStatus())) {
                    throw new AlertException("이미 가입된 연락처입니다.\n다른 연락처를 사용해 주세요.");
                }
            }

            for (MemberVO hist : historyMembers) {
                if ("WITHDRAWN".equals(hist.getStatus())) {
                    // 탈퇴 후 7일 경과 여부 확인
                    if (hist.getUpdatedAt() != null && LocalDateTime.now().isBefore(hist.getUpdatedAt().plusDays(7))) {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분");
                        String availableDate = hist.getUpdatedAt().plusDays(7).format(formatter);
                        throw new AlertException("탈퇴 후 7일간은 동일한 연락처로 가입할 수 없습니다.\n(" + availableDate + " 이후 가입 가능)");
                    }
                }
            }
            member.setPhoneNumber(cleanPhone); // DB 저장 시 하이픈(-) 제거하여 깔끔하게 저장
        }

        // 비밀번호 암호화 (소셜은 더미값 부여)
        if (member.getPassword() != null && !member.getPassword().isEmpty()) {
            String encryptedPassword = sha512.hash(member.getPassword());
            member.setPassword(encryptedPassword);
        } else {
            // DB 제약조건 오류 방지용 랜덤 텍스트 삽입
            member.setPassword(UUID.randomUUID().toString());
        }

        // 5. 기본값 설정 (DDL 및 스토리보드 반영)
        if (member.getMyTeamCode() == null || member.getMyTeamCode().isEmpty()) {
            member.setMyTeamCode("NONE"); // 팀 선택 전
        }

        // 소셜 제공자가 없는 경우에만 NONE으로 설정 (기존 데이터 보존)
        String sp = member.getSocialProvider();
        if (sp == null || sp.trim().isEmpty() || "null".equalsIgnoreCase(sp) || "undefined".equalsIgnoreCase(sp)) {
            member.setSocialProvider("NONE");
        } else {
            // DB 제약조건에 걸리지 않도록 공백을 제거하고 대문자로 통일
            member.setSocialProvider(sp.trim().toUpperCase());
        }

        member.setRole("USER");
        member.setStatus("ACTIVE");

        // 성별이 없으면 기본값 U 설정
        if (member.getGender() == null || member.getGender().isEmpty()) {
            member.setGender("U");
        }

        // 6. DB 저장
        memberMapper.insertMember(member);
        log.info("회원가입 완료: {}", member.getEmail());
    }

    public int countByNickname(String nickname) {
        return memberMapper.countByNickname(nickname); // Mapper에 해당 메서드 존재 확인 필요
    }

    /**
     * 로그인 처리 (단순 예시)
     */
    public MemberVO login(String email, String password) throws Exception {
        // 1. 회원 조회
        MemberVO member = memberMapper.selectMemberByEmail(email);
        if (member == null) {
            throw new AlertException("아이디 또는 비밀번호가 틀렸습니다."); // 보안상 "아이디 또는 비밀번호가 틀렸습니다" 권장
        }

        if ("WITHDRAWN".equals(member.getStatus())) {
            throw new AlertException("탈퇴한 회원입니다.");
        }
        if ("SUSPENDED".equals(member.getStatus())) {
            throw new AlertException("운영정책 위반으로 활동이 정지된 계정입니다. 고객센터로 문의해 주세요.");
        }

        // 2. 비밀번호 비교 (입력받은 비밀번호를 암호화하여 DB 값과 비교)
        String encryptedInputPassword = sha512.hash(password);
        if (!member.getPassword().equals(encryptedInputPassword)) {
            throw new AlertException("비밀번호가 일치하지 않습니다.");
        }

        // 3. 마지막 로그인 시간 갱신
        memberMapper.updateLastLogin(member.getMemberId());

        // 비밀번호 정보 제거 후 반환
        member.setPassword(null);

        return member;
    }

    /**
     * 회원 최신 정보 조회 (마이페이지용)
     */
    public MemberVO getMemberInfo(Long memberId) {
        return memberMapper.selectMemberById(memberId);
    }

    /**
     * 연락처 중복 여부 확인 (회원가입 SMS 발송 전 선제 차단용)
     */
    public boolean checkDuplicatePhone(String phoneNumber) {
        // 이미 가입된 번호가 있으면 true 반환
        return memberMapper.countByPhoneNumber(phoneNumber) > 0;
    }

    /**
     * 회원 정보 수정 (닉네임, 연락처 등)
     */
    @Transactional
    public void updateMemberInfo(MemberVO member) throws Exception {
        // [금칙어 검사 추가]
        if (StringUtil.containsBannedWord(member.getNickname())) {
            throw new AlertException("닉네임에 부적절한 단어가 포함되어 있습니다.");
        }

        // 1. 닉네임 중복 체크 (기존 닉네임과 다를 경우에만 수행)
        MemberVO currentMember = memberMapper.selectMemberById(member.getMemberId());
        if (currentMember == null) {
            throw new AlertException("회원 정보를 찾을 수 없습니다.");
        }

        // 닉네임 정보가 넘어왔고, 기존과 다를 때만 중복 검사
        if (member.getNickname() != null) {
            if (!currentMember.getNickname().equals(member.getNickname())) {
                if (memberMapper.countByNickname(member.getNickname()) > 0) {
                    throw new AlertException("이미 사용 중인 닉네임입니다.");
                }
            } else {
                // 변경되지 않은 닉네임이 넘어온 경우 null로 만들어 Mapper에서 업데이트(및 30일 제한 리셋) 방지
                member.setNickname(null);
            }
        }

        // 연락처 변경 시 중복 체크 방어 로직
        if (member.getPhoneNumber() != null && !member.getPhoneNumber().isEmpty()) {
            String cleanPhone = member.getPhoneNumber().replaceAll("-", "");

            // 현재 내 연락처와 다르게 변경하려는 경우에만 중복 체크
            if (currentMember.getPhoneNumber() != null && !cleanPhone.equals(currentMember.getPhoneNumber().replaceAll("-", ""))) {
                if (memberMapper.countByPhoneNumber(cleanPhone) > 0) {
                    throw new AlertException("이미 다른 계정에서 사용 중인 연락처입니다.");
                }
            }
            member.setPhoneNumber(cleanPhone); // 통일성을 위해 하이픈 제거 저장
        }

        // 2. 정보 수정 실행
        memberMapper.updateMemberInfo(member);
        log.info("회원정보 수정 완료: memberId={}", member.getMemberId());
    }

    /**
     * 비밀번호 변경
     */
    @Transactional
    public void changePassword(Long memberId, String currentPassword, String newPassword) throws Exception {
        // 1. 현재 회원 정보 조회
        MemberVO member = memberMapper.selectMemberById(memberId);
        if (member == null) {
            throw new AlertException("회원 정보가 없습니다.");
        }

        // 2. 현재 비밀번호 검증
        String encryptedCurrent = sha512.hash(currentPassword);
        if (!member.getPassword().equals(encryptedCurrent)) {
            throw new AlertException("현재 비밀번호가 일치하지 않습니다.");
        }

        // 3. 새 비밀번호 유효성 검사
        if (!isValidPassword(newPassword)) {
            // 메시지도 프론트엔드와 일치시킴
            throw new AlertException("비밀번호는 영문, 숫자, 특수문자(!@#$%^&*-_?) 중 2종 이상을 조합하여 8~14자로 입력해주세요.");
        }

        // 4. 새 비밀번호 암호화 및 저장
        String encryptedNew = sha512.hash(newPassword);
        memberMapper.updatePassword(memberId, encryptedNew);
        log.info("비밀번호 변경 완료: memberId={}", memberId);
    }

    /**
     * 응원팀 설정/변경
     */
    @Transactional
    public void updateTeam(Long memberId, String teamCode) throws Exception {
        // 1. 회원 검증
        MemberVO member = memberMapper.selectMemberById(memberId); // 기존에 있던 selectMemberById 사용
        if (member == null) {
            throw new AlertException("회원 정보를 찾을 수 없습니다.");
        }

        // 2. 팀 코드 유효성 검사 (예시: KBO 10개 구단 코드)
        if (teamCode == null || teamCode.isEmpty()) {
            throw new AlertException("팀을 선택해주세요.");
        }

        // 3. 팀 변경 제한 체크 (고도화: 최초 1회 즉시 가능, 이후 월 1회 제한)
        // teamChangeDate가 NULL이면(가입 후 한 번도 변경 안 함) 조건문 패스 -> 즉시 변경
        if (member.getTeamChangeDate() != null) {
            // 마지막 변경일로부터 1달이 지났는지 확인
            LocalDateTime limitDate = member.getTeamChangeDate().plusMonths(1);

            if (LocalDateTime.now().isBefore(limitDate)) {
                // 날짜 포맷팅을 통해 언제부터 가능한지 안내 (선택사항)
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
                String dateStr = limitDate.format(formatter);

                throw new AlertException("응원 팀은 한 달에 한 번만 변경할 수 있어요.\n(" + dateStr + "부터 변경 가능)");
            }
        }

        // 4. 업데이트 수행 (Mapper에서 team_change_date를 NOW()로 업데이트함)
        member.setMyTeamCode(teamCode);
        memberMapper.updateMemberTeam(member);

        log.info("팀 변경 완료: memberId={}, teamCode={}", memberId, teamCode);
    }

    /**
     * 회원 탈퇴 (사용자 직접 요청)
     */
    @Transactional
    public void withdraw(Long memberId) throws Exception {
        MemberVO member = memberMapper.selectMemberById(memberId);
        if (member == null) throw new AlertException("회원 정보가 없습니다.");

        // 이미 탈퇴 상태인지 체크
        if ("WITHDRAWN".equals(member.getStatus())) {
            throw new AlertException("이미 탈퇴 처리된 회원입니다.");
        }

        memberMapper.withdrawMember(memberId);
        log.info("회원 탈퇴 완료: memberId={}", memberId);
    }

    // 비밀번호 규칙 검증 로직
    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8 || password.length() > 14) {
            return false;
        }
        int typeCount = 0;
        // 영문
        if (Pattern.compile("[a-zA-Z]").matcher(password).find()) typeCount++;
        // 숫자
        if (Pattern.compile("[0-9]").matcher(password).find()) typeCount++;
        // 특수문자 (프론트엔드와 동일하게 '-' 포함, '~' 제외 등 규칙 통일)
        // [!@#$%^&*_\-?]
        if (Pattern.compile("[!@#$%^&*_\\-?]").matcher(password).find()) typeCount++;

        return typeCount >= 2;
    }

    // --- [New] 관리자용 메서드 ---

    /**
     * [관리자] 회원 목록 조회 (페이징 + 검색)
     */
    public List<MemberVO> getMemberList(int offset, int limit, String searchType, String keyword) {
        return memberMapper.selectMemberList(offset, limit, searchType, keyword);
    }

    /**
     * [관리자] 회원 수 카운트 (페이징용)
     */
    public int countMembers(String searchType, String keyword) {
        return memberMapper.countMemberList(searchType, keyword);
    }

    /**
     * [관리자] 회원 강제 탈퇴 처리
     * 상태를 'WITHDRAWN'으로 변경합니다.
     */
    @Transactional
    public void forceWithdrawMember(Long memberId) throws Exception {
        // 1. 존재 여부 확인
        MemberVO member = memberMapper.selectMemberById(memberId);
        if (member == null) {
            throw new AlertException("존재하지 않는 회원입니다.");
        }

        // 2. 이미 탈퇴한 회원인지 확인
        if ("WITHDRAWN".equals(member.getStatus())) {
            throw new AlertException("이미 탈퇴 처리된 회원입니다.");
        }

        // 3. 탈퇴 처리
        memberMapper.withdrawMember(memberId);
        log.info("관리자에 의한 강제 탈퇴 처리 완료: memberId={}", memberId);
    }

    /**
     * 아이디 찾기
     * @param birthdate 생년월일 (YYYY-MM-DD)
     * @param phoneNumber 휴대폰 번호 (하이픈 포함 가능)
     * @return MemberVO (email, nickname 포함) 또는 null
     */
    public MemberVO findId(String birthdate, String phoneNumber) {
        // 하이픈 제거 (DB에는 숫자만 저장되어 있다고 가정)
        String cleanPhone = phoneNumber.replaceAll("-", "");
        return memberMapper.findMemberByBirthAndPhone(birthdate, cleanPhone);
    }

    /**
     * 비밀번호 초기화 및 임시 비밀번호 발송
     * 1. 회원 정보 확인
     * 2. 임시 비밀번호 생성 및 암호화 업데이트
     * 3. SMS 발송
     */
    @Transactional
    public boolean resetAndSendPassword(String userName, String phoneNumber) throws Exception {
        // 1. 회원 조회 (이름 + 전화번호)
        // MemberMapper에 해당 메소드 추가 필요
        MemberVO member = memberMapper.findMemberByEmailAndPhone(userName, phoneNumber);

        if (member == null) {
            return false;
        }

        // 2. 임시 비밀번호 생성 (UUID 앞 8자리 사용)
        String tempPw = UUID.randomUUID().toString().substring(0, 8);

        // 3. 비밀번호 암호화 (기존 sha512 빈 사용)
        String encryptedPassword = sha512.hash(tempPw);

        // 4. DB 업데이트 (기존에 존재하는 updatePassword 메소드 재사용)
        // 기존 Mapper의 파라미터명은 newPassword 입니다.
        memberMapper.updatePassword(member.getMemberId(), encryptedPassword);

        // 5. SMS 발송
        String message = "[승요일기] 고객님의 임시 비밀번호는 [" + tempPw + "] 입니다. 로그인 후 변경해주세요.";

        // SmsService에 sendOne 같은 간편 메소드가 있다면 사용하고, 없다면 DTO 빌드
        SmsDTO smsDTO = SmsDTO.builder()
                .receiver(phoneNumber)
                // 발신번호는 SmsService 내부 상수를 쓰거나 설정파일에서 가져옴
                .sender("07080953937") // 실제 운영시 등록된 발신번호 필수
                .message(message)
                .testmode_yn("N")
                .build();

        smsService.smsSend(smsDTO);

        log.info("비밀번호 초기화 및 발송 완료: memberId={}", member.getMemberId());
        return true;
    }

    /**
     * [안전] 닉네임 변경 전용 서비스
     * 다른 필드(전화번호 등)에 영향 없이 닉네임만 수정합니다.
     */
    @Transactional
    public void updateNickname(Long memberId, String newNickname) throws Exception {
        // [금칙어 검사 추가]
        if (StringUtil.containsBannedWord(newNickname)) {
            throw new AlertException("닉네임에 부적절한 단어가 포함되어 있습니다.");
        }

        // 1. 기존 닉네임과 동일한지 확인 (DB 조회)
        MemberVO currentMember = memberMapper.selectMemberById(memberId);
        if (currentMember == null) {
            throw new AlertException("회원 정보를 찾을 수 없습니다.");
        }

        if (newNickname.equals(currentMember.getNickname())) {
            return; // 변경 사항 없음
        }

        // 2. 중복 체크
        if (memberMapper.countByNickname(newNickname) > 0) {
            throw new AlertException("이미 사용 중인 닉네임입니다.");
        }

        // 3. 닉네임 업데이트 실행
        memberMapper.updateNickname(memberId, newNickname);
        log.info("닉네임 변경 완료: memberId={}, newNickname={}", memberId, newNickname);
    }

    /**
     * 알림 설정 변경 (개별 토글 처리용)
     */
    @Transactional
    public void updateAlarm(Long memberId, String type, String value) throws Exception {
        // 1. 현재 회원 정보 조회
        MemberVO member = memberMapper.selectMemberById(memberId);
        if (member == null) throw new AlertException("회원 정보가 없습니다.");

        // 2. 타입에 따라 값 변경 (Controller에서 대문자로 넘겨줌)
        switch (type) {
            case "PUSH":
                member.setPushYn(value);
                member.setGameAlarm(value);
                member.setFriendAlarm(value);
                member.setMarketingAgree(value);
                break;      // 전체 알림
            case "GAME": member.setGameAlarm(value); break;
            case "FRIEND": member.setFriendAlarm(value); break;
            case "MARKETING": member.setMarketingAgree(value); break;
            default: throw new AlertException("잘못된 알림 타입입니다: " + type);
        }

        memberMapper.updateAlarmSetting(member);
    }

    // 팔로우 여부 확인
    public boolean isFollowing(Long followerId, Long followingId) {
        return memberMapper.checkFollow(followerId, followingId) > 0;
    }

    /**
     * 팔로우 토글 (이미 팔로우 중이면 취소, 아니면 추가)
     * 리턴: true(팔로우 상태가 됨), false(언팔로우 상태가 됨)
     */
    @Transactional
    public boolean toggleFollow(Long followerId, Long followingId) {
        if (isFollowing(followerId, followingId)) {
            memberMapper.deleteFollow(followerId, followingId);
            return false; // 언팔로우됨
        } else {
            memberMapper.insertFollow(followerId, followingId);

            // 팔로우 알림 발송
            sendFollowAlarm(followerId, followingId);

            return true; // 팔로우됨
        }
    }

    // 팔로워 목록 조회
    public List<FollowDTO> getFollowerList(Long targetMemberId, Long myMemberId) {
        return memberMapper.selectFollowerList(targetMemberId, myMemberId);
    }

    // 팔로잉 목록 조회
    public List<FollowDTO> getFollowingList(Long targetMemberId) {
        return memberMapper.selectFollowingList(targetMemberId);
    }

    // 팔로우 알림 발송 메소드
    // 알림 및 FCM 기기 푸시 동시 발송
    private void sendFollowAlarm(Long followerId, Long followeeId) {
        try {
            MemberVO target = memberMapper.selectMemberById(followeeId); // 알림을 받을 사람 (팔로우 당한 사람)
            MemberVO actor = memberMapper.selectMemberById(followerId);  // 알림을 발생시킨 사람 (팔로우 한 사람)

            if (target == null || actor == null) return;

            // 상대방의 '친구 알림' 수신 설정이 켜져 있는지 확인
            if ("Y".equals(target.getFriendAlarm())) {
                String title = "새로운 팔로워";
                String message = actor.getNickname() + "님이 회원님을 팔로우했습니다.";
                String linkUrl = "/member/follow/list?tab=follower"; // 알림 클릭 시 이동할 URL

                // 1. 사용자 앱 내 알림(종 모양 아이콘) DB 저장
                alarmService.sendAlarm(followeeId, "FRIEND", title, message, linkUrl);

                // 2. FCM 기기 푸시 발송 (전체 푸시 동의 'Y' 및 fcmToken이 존재하는 경우에만)
                if ("Y".equals(target.getPushYn()) && target.getFcmToken() != null && !target.getFcmToken().trim().isEmpty()) {
                    Message fcmMessage = Message.builder()
                            .setToken(target.getFcmToken()) // 단일 유저에게 발송

                            // 1. 공통 알림 내용 (iOS/Android 공통 배너 텍스트)
                            .setNotification(Notification.builder()
                                    .setTitle(title)
                                    .setBody(message)
                                    .build())

                            // 2. 딥링크 데이터 (Appify 규격에 맞춘 화면 이동 URL)
                            .putData("title", title)
                            .putData("body", message)
                            .putData("link", linkUrl)

                            // 3. 안드로이드(Android) 전용 설정 (Appify 필수 규격)
                            .setAndroidConfig(AndroidConfig.builder()
                                    .setPriority(AndroidConfig.Priority.HIGH)
                                    .setNotification(AndroidNotification.builder()
                                            .setChannelId("default")
                                            .setVisibility(AndroidNotification.Visibility.PUBLIC)
                                            .setSound("default")
                                            .build())
                                    .build())

                            // 4. 아이폰(iOS) 전용 설정 (진동/소리 강제 활성화)
                            .setApnsConfig(ApnsConfig.builder()
                                    .putHeader("apns-priority", "10")
                                    .setAps(Aps.builder()
                                            .setSound("default") // 아이폰에서 무음으로 오지 않도록 설정
                                            .setContentAvailable(true)
                                            .build())
                                    .build())

                            .build();

                    FirebaseMessaging.getInstance().send(fcmMessage);
                    log.info("FCM 푸시 발송 성공 - Target: {}", target.getMemberId());
                }
            }
        } catch (Exception e) {
            log.error("팔로우 알림 발송 중 시스템 오류 발생", e);
        }
    }

    // 회원 검색
    public List<MemberVO> searchMembers(String keyword, Long myMemberId) {
        return memberMapper.searchMembers(keyword, myMemberId);
    }

    public int countTodayMembers() {
        return memberMapper.countTodayMembers();
    }

    public MemberVO getMemberByEmail(String userEmail) {
        return memberMapper.selectMemberByEmail(userEmail);
    }

    // 소셜 로그인 ID 기준 회원 조회
    public MemberVO getMemberBySocialId(String provider, String uid) {
        return memberMapper.selectBySocialId(provider, uid);
    }

    // 소셜 연동 정보 업데이트
    @Transactional
    public void updateSocialInfo(MemberVO member) {
        memberMapper.updateSocialInfo(member);
    }

    @Transactional
    public void updatePushToken(Long memberId, String token) {
        // 기존 토큰과 동일한지 체크하는 로직이 있으면 좋지만, 여기선 무조건 업데이트 (단순화)
        memberMapper.updatePushToken(memberId, token);
    }

    // ==========================================
    // 카카오 로그인 로직 시작
    // ==========================================

    // 1. 카카오 로그인 메인 프로세스
    public MemberVO processKakaoLogin(String code) throws Exception {
        // 1) 토큰 발급
        String accessToken = getKakaoAccessToken(code);

        // 2) 사용자 정보 조회
        MemberVO kakaoUser = getKakaoUserInfo(accessToken);

        // 3) DB 조회: 이미 가입된 소셜 계정인지 확인
        MemberVO member = memberMapper.selectBySocialId("KAKAO", kakaoUser.getSocialUid());

        if (member == null) {
            // 4-1) 기존 이메일 가입자라면 계정 통합 (이메일이 같을 경우)
            MemberVO existingMember = memberMapper.selectMemberByEmail(kakaoUser.getEmail());

            if (existingMember != null) {
                existingMember.setSocialProvider("KAKAO");
                existingMember.setSocialUid(kakaoUser.getSocialUid());
                if (existingMember.getProfileImage() == null) {
                    existingMember.setProfileImage(kakaoUser.getProfileImage());
                }
                memberMapper.updateSocialInfo(existingMember);
                member = existingMember;
            } else {
                // 4-2) 신규 가입 진행
                member = new MemberVO();
                member.setSocialProvider("KAKAO");
                member.setSocialUid(kakaoUser.getSocialUid());
                member.setEmail(kakaoUser.getEmail());
                member.setNickname(kakaoUser.getNickname());
                member.setProfileImage(kakaoUser.getProfileImage());
            }
        }

        return member;
    }

    // 2. 액세스 토큰 발급 요청
    private String getKakaoAccessToken(String code) {
        String reqUrl = "https://kauth.kakao.com/oauth/token";
        RestTemplate rt = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", "68ed5201a09f5e4d4f4bbb3a91e366a1"); // 카카오 앱 키
        params.add("redirect_uri", "https://myseungyo.com/member/kakao/callback");
        params.add("client_secret", "2GO2yJLa4Kznj89R5RkbWqG6yOMqKBgT");
        params.add("code", code);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        try {
            ResponseEntity<String> response = rt.exchange(reqUrl, HttpMethod.POST, request, String.class);
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            return root.get("access_token").asText();
        } catch (Exception e) {
            log.error("카카오 토큰 발급 실패", e);
            throw new RuntimeException("카카오 로그인 중 오류가 발생했습니다.");
        }
    }

    // 3. 사용자 정보 조회 요청
    private MemberVO getKakaoUserInfo(String token) {
        String reqUrl = "https://kapi.kakao.com/v2/user/me";
        RestTemplate rt = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(headers);

        try {
            ResponseEntity<String> response = rt.exchange(reqUrl, HttpMethod.POST, request, String.class);

            // 응답 데이터 로그 출력
            //log.info("카카오 사용자 정보 응답(Body): {}", response.getBody());

            ObjectMapper mapper = new ObjectMapper();
            JsonNode body = mapper.readTree(response.getBody());

            String id = String.valueOf(body.get("id").asLong());
            String nickname = body.get("properties").get("nickname").asText();
            String image = body.get("properties").has("profile_image") ?
                    body.get("properties").get("profile_image").asText() : null;

            // 이메일은 선택 동의 항목이므로 없을 수 있음 -> 임시 이메일 생성
            String email;
            if (body.has("kakao_account") && body.get("kakao_account").has("email")) {
                email = body.get("kakao_account").get("email").asText();
            } else {
                email = id + "@kakao.viotory.com"; // 이메일 없을 시 임시 생성
            }

            MemberVO vo = new MemberVO();
            vo.setSocialUid(id);
            vo.setNickname(nickname);
            vo.setEmail(email);
            vo.setProfileImage(image);

            return vo;
        } catch (Exception e) {
            log.error("카카오 사용자 정보 조회 실패", e);
            throw new RuntimeException("사용자 정보를 가져오는데 실패했습니다.");
        }
    }

    /**
     * [Appify] 기기 정보 업데이트
     */
    @Transactional
    public void updateDeviceInfo(Long memberId, Map<String, String> info) {
        MemberVO vo = new MemberVO();
        vo.setMemberId(memberId);

        // Map 데이터를 VO에 매핑
        vo.setDevicePlatform(info.get("platform"));
        vo.setDeviceModel(info.get("model"));
        vo.setOsVersion(info.get("osVersion"));
        vo.setAppVersion(info.get("appVersion"));
        vo.setDeviceUuid(info.get("uuid")); // uniqueId를 uuid로 매핑

        memberMapper.updateDeviceInfo(vo);
        log.info("기기 정보 업데이트 완료: memberId={}, model={}", memberId, vo.getDeviceModel());
    }

    public void updateLastLogin(Long memberId) {
        memberMapper.updateLastLogin(memberId);
    }

    // 사용자의 일일 접속 로그 기록
    public void recordAccessLog(Long memberId) {
        try {
            memberMapper.insertAccessLog(memberId);
        } catch (Exception e) {
            log.error("접속 로그 기록 실패", e);
        }
    }

    /**
     * SMS 발송 전 연락처 가입 제한 상태 체크
     */
    public String checkPhoneJoinRestriction(String phoneNumber) {
        List<MemberVO> historyMembers = memberMapper.selectMembersByPhoneNumber(phoneNumber);

        // 1순위: 영구 정지 및 중복 여부 확인
        for (MemberVO hist : historyMembers) {
            if ("SUSPENDED".equals(hist.getStatus())) return "suspended";
            if ("ACTIVE".equals(hist.getStatus())) return "duplicate";
        }

        // 2순위: 탈퇴 후 7일 경과 여부 확인
        for (MemberVO hist : historyMembers) {
            if ("WITHDRAWN".equals(hist.getStatus())) {
                if (hist.getUpdatedAt() != null && LocalDateTime.now().isBefore(hist.getUpdatedAt().plusDays(7))) {
                    return "withdrawn_7days";
                }
            }
        }
        return "ok";
    }

}