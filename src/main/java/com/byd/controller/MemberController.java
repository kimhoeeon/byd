package com.byd.controller;

import com.byd.service.*;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.byd.dto.CommentDTO;
import com.byd.dto.FollowDTO;
import com.byd.dto.WinYoAnalysisDTO;
import com.byd.exception.AlertException;
import com.byd.service.*;
import com.byd.util.AppleJwtUtils;
import com.byd.util.FileUtil;
import com.byd.vo.Criteria;
import com.byd.vo.MemberVO;
import com.byd.vo.TeamVO;
import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final SmsService smsService;
    private final CommentService commentService;
    private final TeamInfoMngService teamInfoMngService;
    private final WinYoService winYoService;
    private final AppleJwtUtils appleJwtUtils;

    // ==========================================
    // 1. 로그인 & 로그아웃
    // ==========================================

    @GetMapping("/login")
    public String loginPage() {
        return "member/login";
    }

    /**
     * 로그인 처리
     * MemberVO를 사용하여 파라미터를 받고, 세션에 저장
     */
    @PostMapping("/login")
    @ResponseBody
    public Map<String, Object> loginAction(MemberVO member,
                                           @RequestParam(value = "remember", required = false) String remember,
                                           HttpServletRequest request,
                                           HttpServletResponse response) {

        Map<String, Object> result = new HashMap<>();

        try {
            // 로그인 서비스 호출
            MemberVO loginMember = memberService.login(member.getEmail(), member.getPassword());

            // 세션에 회원 정보 저장
            HttpSession session = request.getSession();
            session.setAttribute("loginMember", loginMember);

            memberService.updateLastLogin(loginMember.getMemberId());

            // 접속 로그 기록 (DAU/MAU 통계용)
            memberService.recordAccessLog(loginMember.getMemberId());

            // 자동 로그인 처리 (쿠키 설정)
            if ("on".equals(remember) || "true".equals(remember)) {
                // 30일간 유지되는 쿠키 생성 (보안을 위해 추후 암호화된 토큰 사용 권장)
                Cookie cookie = new Cookie("remember_me", loginMember.getEmail());
                cookie.setMaxAge(60 * 60 * 24 * 30); // 30일 (초 단위)
                cookie.setPath("/"); // 모든 경로에서 유효
                response.addCookie(cookie);
            } else {
                // 체크 해제 시 기존 쿠키 삭제
                Cookie cookie = new Cookie("remember_me", null);
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
            }

            // 성공 응답 및 리다이렉트 주소 설정
            result.put("status", "ok");
            if ("NONE".equals(loginMember.getMyTeamCode())) {
                result.put("redirect", "/member/team-setting");
            } else {
                result.put("redirect", "/main");
            }

        } catch (AlertException ae) {
            // 사용자 잘못 (비밀번호 틀림 등)
            log.info("로그인 알럿 발생: {}", ae.getMessage());
            result.put("status", "fail");
            result.put("message", ae.getMessage());
        } catch (Exception e) {
            log.error("로그인 중 치명적 오류 발생", e);
            result.put("status", "fail");
            result.put("message", "시스템 오류가 발생했습니다.");
        }

        return result;
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 로그아웃 시 자동 로그인 쿠키 삭제
        javax.servlet.http.Cookie cookie = new javax.servlet.http.Cookie("remember_me", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

        return "redirect:/member/login";
    }

    // [카카오 로그인 콜백]
    @GetMapping("/kakao/callback")
    public String kakaoCallback(@RequestParam String code, HttpSession session, Model model) {

        // [방어 로직 1] 이미 로그인된 상태에서 뒤로가기 등으로 다시 진입한 경우 에러 없이 메인으로 이동
        if (session.getAttribute("loginMember") != null) {
            return "redirect:/main";
        }

        try {
            // 1. 서비스 호출
            MemberVO member = memberService.processKakaoLogin(code);

            // [핵심 변경] 2. 신규 회원(memberId 없음) -> 회원가입 단계로 이동
            if (member.getMemberId() == null) {
                model.addAttribute("socialInfo", member);
                return "member/join_social_bridge"; // 정보를 세션스토리지에 담는 중간 페이지
            }

            // 3. 기존 회원 -> 정지 및 탈퇴 계정 로그인 및 재가입 차단 ▼
            if ("WITHDRAWN".equals(member.getStatus())) {
                if (member.getUpdatedAt() != null && member.getUpdatedAt().plusDays(7).isAfter(java.time.LocalDateTime.now())) {
                    model.addAttribute("message", "탈퇴 후 7일이 지나지 않아 재가입할 수 없습니다.");
                    return "member/login";
                }
                // 7일 경과 시 재가입 허용 (신규가입 취급)
                model.addAttribute("socialInfo", member);
                return "member/join_social_bridge";
            }
            if ("SUSPENDED".equals(member.getStatus())) {
                model.addAttribute("message", "운영정책 위반으로 활동이 영구 정지된 계정입니다.");
                return "member/login"; // 로그인 차단으로 재가입(연동)도 원천 봉쇄됨
            }

            // 3. 기존 회원 -> 로그인 처리
            session.setAttribute("loginMember", member);

            memberService.updateLastLogin(member.getMemberId());

            // 접속 로그 기록 (DAU/MAU 통계용)
            memberService.recordAccessLog(member.getMemberId());

            // 4. 팀 설정 여부에 따른 이동
            if (member.getMyTeamCode() == null || "NONE".equals(member.getMyTeamCode())) {
                return "redirect:/member/team-setting";
            }
            return "redirect:/main";

        } catch (Exception e) {
            // [방어 로직 2] 카카오 KOE320 에러 (1회용 코드 재사용) 부드럽게 처리
            if (e.getMessage() != null && e.getMessage().contains("KOE320")) {
                log.warn("카카오 로그인 중복 요청 방어 (KOE320) - 1회용 인증 코드가 재사용 되었습니다.");
                model.addAttribute("message", "이미 처리된 요청이거나 만료된 인증입니다. 카카오 로그인을 다시 시도해 주세요.");
            } else {
                log.error("카카오 로그인 실패", e); // 진짜 통신 장애일 때만 에러 로그 출력
                model.addAttribute("message", "카카오 로그인에 실패했습니다.");
            }
            return "member/login";
        }
    }

    // [Apple 로그인 콜백]
    @PostMapping("/appleLoginCallback")
    public String appleLoginCallback(
            @RequestParam(value = "id_token") String idToken,
            @RequestParam(value = "user", required = false) String userJson,
            HttpServletRequest request,
            HttpSession session,
            Model model) {

        log.info("Apple Login Callback 진입");

        try {
            // 1. AppleJwtUtils를 사용하여 실시간 서명 검증 및 Claims(페이로드) 추출
            Claims claims = appleJwtUtils.getClaimsBy(idToken);

            // 2. 검증된 Claims에서 필수 정보(email, sub) 추출
            String email = claims.get("email", String.class);
            if (email == null) email = "";
            String appleUniqueId = claims.getSubject(); // Apple의 고유 ID(sub)

            log.info("Apple Login 서명 검증 완료 - email: {}, sub: {}", email, appleUniqueId);

            // 3. Apple이 최초 로그인 시 1회만 제공하는 user JSON에서 이름 정보 추출
            String fullName = "";
            if (userJson != null && !userJson.isEmpty()) {
                try {
                    ObjectMapper mapper = new ObjectMapper();
                    JsonNode userNode = mapper.readTree(userJson);
                    if (userNode.has("name")) {
                        JsonNode nameNode = userNode.get("name");
                        String lastName = nameNode.has("lastName") ? nameNode.get("lastName").asText() : "";
                        String firstName = nameNode.has("firstName") ? nameNode.get("firstName").asText() : "";
                        fullName = lastName + firstName;
                    }
                } catch (Exception e) {
                    log.warn("Apple user JSON parsing error", e);
                }
            }

            // 4. DB에서 고유 식별자(SocialUid)를 기준으로 기존 회원 여부 확인
            MemberVO existingMember = memberService.getMemberBySocialId("APPLE", appleUniqueId);

            // 5. 소셜 ID로는 없지만, 동일한 이메일로 가입된 계정이 있다면 연동 처리 (계정 통합)
            if (existingMember == null && !email.isEmpty()) {
                existingMember = memberService.getMemberByEmail(email);
                if (existingMember != null) {
                    existingMember.setSocialProvider("APPLE");
                    existingMember.setSocialUid(appleUniqueId);
                    memberService.updateSocialInfo(existingMember);
                }
            }

            if (existingMember != null) {
                // 탈퇴 여부 체크
                // 탈퇴한 계정이라도 7일이 경과했으면 재가입 브릿지로 보냄
                if ("WITHDRAWN".equals(existingMember.getStatus())) {
                    if (existingMember.getUpdatedAt() != null && existingMember.getUpdatedAt().plusDays(7).isAfter(java.time.LocalDateTime.now())) {
                        model.addAttribute("message", "탈퇴 후 7일이 지나지 않아 재가입할 수 없습니다.");
                        return "member/login";
                    }
                    model.addAttribute("socialInfo", existingMember);
                    return "member/join_social_bridge";
                }
                if ("SUSPENDED".equals(existingMember.getStatus())) {
                    model.addAttribute("message", "운영정책 위반으로 활동이 정지된 계정입니다.");
                    return "member/login";
                }

                // 가입된 회원이면 세션에 저장하고 로그인 처리
                session.setAttribute("loginMember", existingMember);

                memberService.updateLastLogin(existingMember.getMemberId());
                memberService.recordAccessLog(existingMember.getMemberId());

                if (existingMember.getMyTeamCode() == null || "NONE".equals(existingMember.getMyTeamCode())) {
                    return "redirect:/member/team-setting";
                }
                return "redirect:/main";
            } else {
                // 신규 회원이면 브릿지 페이지로 이동하여 추가 정보 입력 유도
                MemberVO newMember = new MemberVO();
                newMember.setEmail(email);
                newMember.setSocialProvider("APPLE");
                newMember.setSocialUid(appleUniqueId);

                // 추출한 이름이 존재한다면 닉네임 필드에 기본값으로 세팅
                if (!fullName.isEmpty()) {
                    newMember.setNickname(fullName);
                }

                // 기존 카카오 로직과 호환되게 socialInfo 모델 속성을 통해 브릿지 페이지로 전달
                model.addAttribute("socialInfo", newMember);
                return "member/join_social_bridge";
            }

        } catch (Exception e) {
            log.error("Apple 로그인 처리 중 오류 발생 (보안 검증 실패 등)", e);
            model.addAttribute("message", "Apple 로그인 처리 중 오류가 발생했습니다.");
            return "member/login";
        }
    }

    // ==========================================
    // 2. 회원가입 (단계별 Wizard)
    // ==========================================

    // 단계별 페이지 매핑
    @GetMapping("/join")
    public String joinMain() { return "redirect:/member/join/step1"; }

    @GetMapping("/join/step1")
    public String joinStep1() { return "member/join_step1"; }

    @GetMapping("/join/step2")
    public String joinStep2() { return "member/join_step2"; }

    @GetMapping("/join/step3")
    public String joinStep3() { return "member/join_step3"; }

    @GetMapping("/join/step4")
    public String joinStep4() { return "member/join_step4"; }

    @GetMapping("/join/step5")
    public String joinStep5() { return "member/join_step5"; }

    @GetMapping("/join/step6")
    public String joinStep6() { return "member/join_step6"; }

    @GetMapping("/join/complete")
    public String joinComplete(@RequestParam(value = "name", required = false) String name, Model model) {
        model.addAttribute("nickname", name); // 완료 페이지에 표시할 이름
        return "member/join_complete";
    }

    /**
     * 이메일 중복 체크
     */
    @PostMapping("/check/email")
    @ResponseBody
    public String checkEmail(@RequestParam("email") String email) {
        MemberVO existing = memberService.getMemberByEmail(email);
        if (existing == null) {
            return "ok"; // 완전 신규
        }

        if ("WITHDRAWN".equals(existing.getStatus())) {
            // 탈퇴 후 7일 경과 여부 확인
            if (existing.getUpdatedAt() != null && existing.getUpdatedAt().plusDays(7).isAfter(java.time.LocalDateTime.now())) {
                return "withdrawn_7days";
            }
            return "ok"; // 7일 지났으면 재가입 가능 (프론트에선 ok로 처리)
        }

        if ("SUSPENDED".equals(existing.getStatus())) {
            return "suspended"; // 영구 정지 회원
        }

        return "fail"; // 기존 회원이 사용 중
    }

    /**
     * 닉네임 중복 체크 (실제 DB 조회)
     */
    @PostMapping("/check/nickname")
    @ResponseBody
    public String checkNickname(@RequestParam("nickname") String nickname) {
        // MemberService에 닉네임 체크 메서드가 없다면 추가 필요
        // 예: memberService.countByNickname(nickname)
        try {
            int count = memberService.countByNickname(nickname);
            return (count == 0) ? "ok" : "fail";
        } catch (Exception e) {
            log.error("닉네임 체크 중 오류", e);
            return "error";
        }
    }

    @PostMapping("/join")
    @ResponseBody
    public String joinAction(MemberVO member, BindingResult result) {
        // 1. 데이터 바인딩 에러(400 Bad Request 원인) 체크
        if (result.hasErrors()) {
            StringBuilder sb = new StringBuilder();
            result.getAllErrors().forEach(error -> {
                sb.append(error.getDefaultMessage()).append("\n");
            });
            return "입력 정보가 올바르지 않습니다.\n" + sb.toString();
        }

        try {

            // 필수 데이터 서버 측 2차 검증
            if(member.getEmail() == null || member.getNickname() == null) {
                return "fail:missing_data";
            }

            // 소셜 가입이 아닌 일반 가입자일 경우에만 패스워드 필수 체크
            if (("NONE".equals(member.getSocialProvider()) || member.getSocialProvider() == null) && member.getPassword() == null) {
                return "fail:missing_data";
            }

            memberService.registerMember(member);
            return "ok"; // 성공 시 "ok" 문자열 반환 (AJAX에서 확인)
        } catch (AlertException ae) {
            log.info("회원가입 알럿: {}", ae.getMessage());
            return "가입 처리에 실패했습니다.\n" + ae.getMessage();
        } catch (Exception e) {
            log.error("회원가입 중 치명적 오류", e);
            return "가입 처리에 실패했습니다.\n시스템 오류가 발생했습니다.";
        }
    }

    // ==========================================
    // 3. SMS 본인인증
    // ==========================================

    @PostMapping("/send-sms")
    @ResponseBody
    public String sendSms(@RequestParam("phoneNumber") String phoneNumber,
                          @RequestParam(value = "memberId", required = false) String memberId,
                          @RequestParam(value = "type", required = false) String type) {
        try {
            String cleanNumber = phoneNumber.replaceAll("-", "");

            // [애플 심사용 매직 넘버 패스] - 실제 문자 발송을 스킵하고 바로 성공 처리
            if ("01099999999".equals(cleanNumber)) {
                return "ok";
            }

            // 비밀번호 찾기 시 아이디(이메일)와 연락처 검증 로직 추가
            if ("FIND_PW".equals(type)) {
                if (memberId == null || memberId.trim().isEmpty()) {
                    return "not_found";
                }

                MemberVO member = memberService.getMemberByEmail(memberId);

                // 1. 일치하는 아이디(이메일)가 없거나 등록된 전화번호가 다를 경우 발송 차단
                if (member == null || member.getPhoneNumber() == null || !member.getPhoneNumber().equals(cleanNumber)) {
                    return "not_found";
                }

                // 2. 카카오 등 소셜 로그인 가입자인 경우 비밀번호 초기화 차단
                if ("KAKAO".equals(member.getSocialProvider())) {
                    return "is_kakao";
                }
            }
            // 2. 회원가입 시 검증 로직 추가 (이미 가입, 정지, 탈퇴된 번호면 SMS 발송 즉시 차단)
            else if ("JOIN".equals(type)) {
                String restriction = memberService.checkPhoneJoinRestriction(cleanNumber);
                if ("suspended".equals(restriction)) return "suspended";
                if ("duplicate".equals(restriction)) return "duplicate_phone";
                if ("withdrawn_7days".equals(restriction)) return "withdrawn_7days";
            }

            // 위 검증을 모두 무사히 통과했을 때만 최종 SMS 발송
            return smsService.sendVerificationCode(cleanNumber);
        } catch (Exception e) {
            log.error("SMS 발송 오류", e);
            return "fail";
        }
    }

    @PostMapping("/verify-sms")
    @ResponseBody
    public String verifySms(@RequestParam("phoneNumber") String phoneNumber,
                            @RequestParam("authCode") String authCode) {
        String cleanNumber = phoneNumber.replaceAll("-", "");

        // [애플 심사용 매직 넘버 패스] - 지정된 번호와 코드(000000) 입력 시 무조건 통과
        if ("01099999999".equals(cleanNumber) && "000000".equals(authCode)) {
            return "ok";
        }

        boolean isVerified = smsService.verifyCode(cleanNumber, authCode);
        return isVerified ? "ok" : "fail";
    }

    @GetMapping("/sms/fail")
    public String smsFail() {
        return "member/sms_fail";
    }

    // ==========================================
    // 4. 마이페이지 & 계정 찾기
    // ==========================================

    @GetMapping("/mypage")
    public String myPage(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        MemberVO loginMember = (session != null) ? (MemberVO) session.getAttribute("loginMember") : null;

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 세션 정보보다 DB 최신 정보를 가져오는 것이 안전함
        // (다른 곳에서 포인트나 상태가 변했을 수 있으므로)
        MemberVO memberInfo = memberService.getMemberInfo(loginMember.getMemberId());
        model.addAttribute("member", memberInfo);

        // 칭호(레벨) 노출을 위한 승요력 분석 데이터 추가
        WinYoAnalysisDTO winYo = winYoService.analyzeWinYoPower(loginMember.getMemberId());
        model.addAttribute("winYo", winYo);

        return "member/mypage"; // /WEB-INF/views/member/mypage.jsp
    }

    // --- 회원 정보 수정 처리 ---

    @PostMapping("/update")
    public String updateInfoAction(MemberVO member, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 세션의 PK를 강제로 주입 (보안: 본인 정보만 수정 가능하도록)
        member.setMemberId(loginMember.getMemberId());

        try {
            memberService.updateMemberInfo(member);

            // 세션 정보도 최신화 (닉네임 등이 변경되었으므로)
            loginMember.setNickname(member.getNickname());
            loginMember.setPhoneNumber(member.getPhoneNumber());
            loginMember.setGender(member.getGender());
            loginMember.setBirthdate(member.getBirthdate());
            session.setAttribute("loginMember", loginMember);

            return "redirect:/member/mypage?status=success";
        } catch (AlertException ae) {
            log.info("회원정보 수정 알럿: {}", ae.getMessage());
            model.addAttribute("error", ae.getMessage());
            model.addAttribute("member", member);
            return "member/mypage";
        } catch (Exception e) {
            log.error("회원정보 수정 중 치명적 오류", e);
            model.addAttribute("error", "시스템 오류가 발생했습니다.");
            model.addAttribute("member", member);
            return "member/mypage";
        }
    }

    // --- 비밀번호 변경 처리 ---
    // 비밀번호 변경 페이지 이동
    @GetMapping("/update/password")
    public String updatePasswordPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        return "member/password_change"; // views/member/password_change.jsp
    }

    // 비밀번호 변경 처리
    @PostMapping("/update/password")
    @ResponseBody
    public String updatePasswordAction(@RequestParam("currentPassword") String currentPassword,
                                       @RequestParam("newPassword") String newPassword,
                                       HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "로그인이 필요한 서비스입니다.";
        }

        try {
            // 비밀번호 변경 서비스 호출
            memberService.changePassword(loginMember.getMemberId(), currentPassword, newPassword);

            session.invalidate();

            return "ok";

        } catch (AlertException ae) {
            log.info("비밀번호 변경 알럿: {}", ae.getMessage());
            return ae.getMessage();
        } catch (Exception e) {
            log.error("비밀번호 변경 중 시스템 오류", e);
            return "시스템 오류가 발생했습니다.";
        }
    }

    // 아이디 찾기 입력 페이지
    @GetMapping("/find-id")
    public String findIdPage() {
        return "member/find_id";
    }

    // 아이디 찾기 결과 처리
    @PostMapping("/find-id/result")
    public String findIdResult(@RequestParam("birthdate") String birthdate,
                               @RequestParam("phoneNumber") String phoneNumber,
                               Model model) {
        // 생년월일과 전화번호로 회원 조회
        MemberVO member = memberService.findId(birthdate, phoneNumber);

        if (member != null) {
            // 조회 성공 시 정보 전달
            model.addAttribute("foundEmail", maskEmail(member.getEmail()));
            model.addAttribute("nickname", member.getNickname());
        }
        // 조회 실패 시 foundEmail이 null이므로 JSP에서 분기 처리됨

        return "member/find_id_result";
    }

    // 비밀번호 찾기 입력 페이지
    @GetMapping("/find-password")
    public String findPasswordPage() {
        return "member/find_password";
    }

    // 비밀번호 초기화 및 임시 비밀번호 발송
    @PostMapping("/find-password/reset")
    public String resetPassword(@RequestParam("memberId") String memberId,
                                @RequestParam("phoneNumber") String phoneNumber,
                                @RequestParam("authCode") String authCode,
                                Model model) {

        // 0. 카카오 소셜 로그인 회원 여부 확인
        // memberId는 이메일 형식이므로 이메일로 조회
        MemberVO member = memberService.getMemberByEmail(memberId);

        if (member != null && "KAKAO".equals(member.getSocialProvider())) {
            // 카카오 계정이면 플래그를 담아 View로 리턴 (JSP에서 스크립트 처리)
            model.addAttribute("isKakao", true);
            return "member/find_password";
        }

        // 1. SMS 인증번호 검증
        String cleanNumber = phoneNumber.replaceAll("-", "");
        boolean isVerified = smsService.verifyCode(cleanNumber, authCode);

        if (!isVerified) {
            model.addAttribute("error", "인증번호가 일치하지 않거나 만료되었습니다.");
            return "member/find_password";
        }

        // 2. 회원 확인 및 임시 비밀번호 발송
        try {
            boolean success = memberService.resetAndSendPassword(memberId, cleanNumber);
            if (success) {
                model.addAttribute("name", maskEmail(memberId));
                return "member/find_password_result";
            } else {
                model.addAttribute("error", "입력하신 정보와 일치하는 회원이 없습니다.");
                return "member/find_password";
            }
        } catch (Exception e) {
            log.error("비밀번호 초기화 중 오류", e);
            model.addAttribute("error", "오류가 발생했습니다. 다시 시도해주세요.");
            return "member/find_password";
        }
    }

    // ==========================================
    // 5. 팀 선택 (온보딩 & 마이페이지)
    // ==========================================

    // 팀 선택 페이지 이동
    @GetMapping("/team-setting")
    public String teamSettingPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 팀 목록 조회하여 모델에 추가 (10개 구단 모두 조회)
        Criteria cri = new Criteria();
        cri.setAmount(20); // 10개 구단 충분히 조회되도록 설정
        List<TeamVO> teamList = teamInfoMngService.selectTeamList(cri);
        model.addAttribute("teamList", teamList);
        return "member/team_setting";
    }

    // 팀 선택 저장 처리
    @PostMapping("/team-setting")
    public String teamSettingAction(@RequestParam("teamCode") String teamCode,
                                    HttpSession session,
                                    Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        try {
            // 1. DB 업데이트 (Service 호출)
            memberService.updateTeam(loginMember.getMemberId(), teamCode);

            // 2. 세션 정보 갱신 (중요: 세션을 업데이트해야 화면에 즉시 반영됨)
            loginMember.setMyTeamCode(teamCode);
            session.setAttribute("loginMember", loginMember);

            // 3. 페이지 이동
            // (1) 최초 가입 후 온보딩인 경우 -> 메인으로
            // (2) 마이페이지에서 변경한 경우 -> 마이페이지로
            // 구분하기 복잡하다면, 마이페이지로 보내는 것이 무난합니다.
            return "redirect:/member/mypage";

        } catch (AlertException ae) {
            log.info("팀 변경 알럿: {}", ae.getMessage());
            model.addAttribute("error", ae.getMessage());
            // 에러 시 다시 목록 불러와서 페이지 이동
            Criteria cri = new Criteria();
            cri.setAmount(20);
            List<TeamVO> teamList = teamInfoMngService.selectTeamList(cri);
            model.addAttribute("teamList", teamList);
            return "member/team_setting";
        } catch (Exception e) {
            log.error("팀 변경 중 치명적 오류", e);
            model.addAttribute("error", "시스템 오류가 발생했습니다.");
            // 에러 시 다시 목록 불러와서 페이지 이동
            Criteria cri = new Criteria();
            cri.setAmount(20);
            List<TeamVO> teamList = teamInfoMngService.selectTeamList(cri);
            model.addAttribute("teamList", teamList);
            return "member/team_setting";
        }
    }

    // 프로필 수정(닉네임 변경) 페이지 이동
    @GetMapping("/update/profile")
    public String updateProfilePage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        // 최신 정보 조회하여 전달
        MemberVO memberInfo = memberService.getMemberInfo(loginMember.getMemberId());
        model.addAttribute("member", memberInfo);

        return "member/profile_update"; // views/member/profile_update.jsp
    }

    // 프로필 수정 처리
    @PostMapping("/update/profile")
    @ResponseBody
    public String updateProfileAction(@RequestParam("nickname") String nickname,
                                      @RequestParam(value = "file", required = false) MultipartFile file,
                                      HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "로그인이 필요한 서비스입니다.";

        try {

            // DB 최신 정보 조회
            MemberVO currentMember = memberService.getMemberInfo(loginMember.getMemberId());

            // 1. 닉네임이 기존과 다르게 변경되었는지 확인
            boolean isNicknameChanged = nickname != null && !nickname.equals(currentMember.getNickname());

            // 2. 닉네임이 변경되었을 때만 30일 제한 검사 (프로필 사진만 바꾼 경우 패스)
            if (isNicknameChanged) {
                java.time.LocalDateTime lastUpdated = currentMember.getNicknameUpdatedAt();
                if (lastUpdated != null) {
                    long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(lastUpdated, java.time.LocalDateTime.now());
                    if (daysBetween < 30) {
                        return "닉네임은 월 1회(30일에 1회)만 변경 가능합니다. (남은 기간: " + (30 - daysBetween) + "일)";
                    }
                }
            }

            // 3. 이미지 파일 업로드 처리
            String profileImagePath = null;
            if (file != null && !file.isEmpty()) {
                profileImagePath = FileUtil.uploadFile(file, "member");
            }

            // 4. 업데이트될 내용이 없으면 중복 통신 방지용 완료 처리
            if (!isNicknameChanged && profileImagePath == null) {
                return "ok";
            }

            // 5. 서비스 호출 객체 세팅
            MemberVO updateVO = new MemberVO();
            updateVO.setMemberId(loginMember.getMemberId());
            // 닉네임이 변경된 경우에만 VO에 세팅
            if (isNicknameChanged) {
                updateVO.setNickname(nickname);
            }
            if (profileImagePath != null) {
                updateVO.setProfileImage(profileImagePath);
            }

            memberService.updateMemberInfo(updateVO);

            // 6. 세션 정보 최신화
            if (isNicknameChanged) {
                loginMember.setNickname(nickname);
            }
            if (profileImagePath != null) {
                loginMember.setProfileImage(profileImagePath);
            }
            session.setAttribute("loginMember", loginMember);

            return "ok";
        } catch (AlertException ae) {
            log.info("프로필 수정 알럿: {}", ae.getMessage());
            return ae.getMessage();
        } catch (Exception e) {
            log.error("프로필 수정 실패", e);
            return "프로필 수정 중 오류가 발생했습니다."; // 실패 시 에러 메시지 반환
        }
    }

    // ==========================================
    // 6. 알림 설정
    // ==========================================

    // 알림 설정 페이지 이동
    @GetMapping("/alarm/setting")
    public String alarmSettingPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 최신 정보 조회 (설정값 동기화)
        MemberVO member = memberService.getMemberInfo(loginMember.getMemberId());
        model.addAttribute("member", member);

        return "member/alarm_setting";
    }

    // 알림 설정 변경 (AJAX)
    @PostMapping("/alarm/update")
    @ResponseBody
    public String updateAlarmAction(@RequestParam("type") String type,
                                    @RequestParam("value") String value, // 'Y' or 'N'
                                    HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:not_login";

        // [중요] 2. Null 체크 및 대문자 변환 (방어 로직)
        if (type == null || type.trim().isEmpty()) {
            return "fail:invalid_type";
        }

        try {

            // 대소문자 통일을 위해 대문자로 변환 (PUSH, GAME, FRIEND, MARKETING)
            String upperType = type.toUpperCase();

            // 1. DB 업데이트 (Service 호출)
            memberService.updateAlarm(loginMember.getMemberId(), type, value);

            // 세션 정보도 갱신 (선택사항)
            switch (upperType) {
                case "PUSH":
                    loginMember.setPushYn(value);
                    loginMember.setGameAlarm(value);
                    loginMember.setFriendAlarm(value);
                    loginMember.setMarketingAgree(value);
                    break;
                case "GAME": loginMember.setGameAlarm(value); break;
                case "FRIEND": loginMember.setFriendAlarm(value); break;
                case "MARKETING": loginMember.setMarketingAgree(value); break;
            }
            session.setAttribute("loginMember", loginMember);

            return "ok";
        } catch (AlertException ae) {
            log.info("알림 설정 변경 알럿: {}", ae.getMessage());
            return "fail";
        } catch (Exception e) {
            log.error("알림 설정 변경 중 치명적 오류", e);
            return "fail";
        }
    }

    // 팔로우/팔로잉 목록 페이지
    @GetMapping("/follow/list")
    public String followListPage(@RequestParam(value = "tab", defaultValue = "following") String tab,
                                 @RequestParam(value = "memberId", required = false) Long memberId,
                                 HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // memberId 파라미터가 없으면 내 목록 조회
        Long targetId = (memberId != null) ? memberId : loginMember.getMemberId();

        List<FollowDTO> list;
        if ("follower".equals(tab)) {
            // 팔로워 목록 조회 (맞팔 확인을 위해 내 ID도 전달)
            list = memberService.getFollowerList(targetId, loginMember.getMemberId());
        } else {
            // 팔로잉 목록 조회
            list = memberService.getFollowingList(targetId);
        }

        model.addAttribute("list", list);
        model.addAttribute("tab", tab);
        model.addAttribute("targetId", targetId);

        // 상단 타이틀용 (내 목록인지 남의 목록인지 확인)
        boolean isMyList = targetId.equals(loginMember.getMemberId());
        model.addAttribute("isMyList", isMyList);

        return "member/follow_list";
    }

    // [신규 API] 팔로우 토글
    @PostMapping("/follow/toggle")
    @ResponseBody
    public String toggleFollow(@RequestParam("targetId") Long targetId, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        if (loginMember.getMemberId().equals(targetId)) {
            return "fail:self"; // 자기 자신 팔로우 불가
        }

        boolean result = memberService.toggleFollow(loginMember.getMemberId(), targetId);
        return result ? "followed" : "unfollowed";
    }

    // ==========================================
    // 8. 댓글 관리
    // ==========================================

    // 댓글 관리 페이지 이동 (내가 쓴 댓글 리스트)
    @GetMapping("/review/list")
    public String reviewListPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        List<CommentDTO> list = commentService.getMyComments(loginMember.getMemberId());
        model.addAttribute("list", list);

        return "member/review_list";
    }

    // 댓글 삭제 처리
    @PostMapping("/review/delete")
    @ResponseBody
    public String deleteReview(@RequestParam("commentId") Long commentId, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            // 서비스에서 '댓글 작성자' 또는 '일기 주인'인지 확인하고 삭제함
            commentService.deleteComment(commentId, loginMember.getMemberId());
            return "ok";
        } catch (AlertException ae) {
            log.info("내가 쓴 댓글 삭제 거부: {}", ae.getMessage());
            return "fail:" + ae.getMessage();
        } catch (Exception e) {
            log.error("내가 쓴 댓글 삭제 중 치명적 오류", e);
            return "fail";
        }
    }

    // 회원 탈퇴 처리
    @GetMapping("/withdraw")
    public String withdrawAction(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        try {
            memberService.withdraw(loginMember.getMemberId());
            session.invalidate(); // 세션 만료
            return "redirect:/member/login?msg=withdrawn";
        } catch (AlertException ae) {
            log.info("회원 탈퇴 알럿: {}", ae.getMessage());
            return "redirect:/member/mypage";
        } catch (Exception e) {
            log.error("회원 탈퇴 중 치명적 오류", e);
            return "redirect:/member/mypage";
        }
    }

    // 사용자 검색 페이지
    @GetMapping("/search")
    public String searchPage() {
        return "member/search";
    }

    // 검색 수행 (결과 조회)
    @GetMapping("/search/result")
    public String searchResult(@RequestParam("keyword") String keyword,
                               HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        List<MemberVO> result = memberService.searchMembers(keyword, loginMember.getMemberId());
        model.addAttribute("list", result);
        model.addAttribute("keyword", keyword);

        return "member/search"; // 같은 페이지에 결과 뿌리기
    }

    /**
     * [App] 푸시 토큰 갱신 API
     * 앱 실행 시 또는 토큰 갱신 시 호출됨
     */
    @PostMapping("/updateToken")
    @ResponseBody
    public String updateToken(@RequestParam(value = "token", required = false) String token, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "fail:not_login"; // 로그인 안 된 상태면 패스
        }

        // 토큰이 안 넘어왔을 때의 방어 로직 추가
        if (token == null || token.trim().isEmpty()) {
            log.warn("앱에서 넘어온 푸시 토큰 값이 없습니다.");
            return "fail:empty_token";
        }

        try {
            log.info("푸시 토큰 갱신 요청: memberId={}, token={}", loginMember.getMemberId(), token);
            memberService.updatePushToken(loginMember.getMemberId(), token);
            return "ok";
        } catch (Exception e) {
            log.error("푸시 토큰 갱신 실패", e);
            return "fail";
        }
    }

    // ==========================================
    // 9. [Appify] 기기 정보 수집 API
    // ==========================================
    @PostMapping("/device/update")
    @ResponseBody
    public String updateDeviceInfo(@RequestParam Map<String, String> params, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

        // 비로그인 상태라도 앱 실행 로그 목적으로 남길 수도 있지만,
        // 여기서는 회원 정보에 업데이트하므로 로그인 체크를 합니다.
        if (loginMember == null) {
            return "fail:not_login";
        }

        try {
            // Service 호출 (Map 파라미터 그대로 전달)
            memberService.updateDeviceInfo(loginMember.getMemberId(), params);
            return "ok";
        } catch (Exception e) {
            log.error("기기 정보 업데이트 실패", e);
            return "fail";
        }
    }

    // ==========================================
    // 9. 이메일 마스킹 처리 유틸
    // ==========================================
    /**
     * 이메일 마스킹 처리 (아이디/비밀번호 찾기 시 노출용)
     * 조건 1: 아이디(로컬) 부분 4자리 이상일 경우 4자리까지만 노출, 그 외는 마스킹
     * 조건 2: 도메인 부분 첫 글자와 최상위 도메인(.com 등)만 노출, 중간은 마스킹
     * ex) abcde1234@gmail.com -> abcd*****@g****.com
     */
    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) {
            return email;
        }

        try {
            String[] parts = email.split("@");
            String localPart = parts[0];
            String domainPart = parts[1];

            // 1. 아이디(로컬) 마스킹
            StringBuilder maskedLocal = new StringBuilder();
            int localVisible = 4;
            if (localPart.length() < 4) {
                // 아이디가 4자리 미만일 경우 예외적으로 1~2자리만 보여줌
                localVisible = Math.max(1, localPart.length() - 1);
            }
            maskedLocal.append(localPart.substring(0, localVisible));
            for (int i = localVisible; i < localPart.length(); i++) {
                maskedLocal.append("*");
            }

            // 2. 도메인 마스킹
            StringBuilder maskedDomain = new StringBuilder();
            int dotIndex = domainPart.lastIndexOf(".");
            if (dotIndex > 0) {
                maskedDomain.append(domainPart.charAt(0));
                for (int i = 1; i < dotIndex; i++) {
                    maskedDomain.append("*");
                }
                maskedDomain.append(domainPart.substring(dotIndex));
            } else {
                maskedDomain.append(domainPart);
            }

            return maskedLocal.toString() + "@" + maskedDomain.toString();
        } catch (Exception e) {
            log.error("이메일 마스킹 처리 중 오류", e);
            return email;
        }
    }

}