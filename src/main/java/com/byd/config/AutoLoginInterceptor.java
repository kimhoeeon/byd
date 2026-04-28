package com.byd.config;

import com.byd.service.MemberService;
import com.byd.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Slf4j
@Component
public class AutoLoginInterceptor implements HandlerInterceptor {

    @Autowired
    private MemberService memberService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        // 1. 이미 로그인된 상태라면 통과
        if (session.getAttribute("loginMember") != null) {
            return true;
        }

        // 2. 로그인 안 된 상태라면 'remember_me' 쿠키 확인
        Cookie loginCookie = WebUtils.getCookie(request, "remember_me");
        if (loginCookie != null) {
            String userEmail = loginCookie.getValue();

            // 3. 쿠키에 저장된 이메일로 회원 정보 조회 (DB)
            try {
                MemberVO member = memberService.getMemberByEmail(userEmail);

                if (member != null && !"WITHDRAWN".equals(member.getStatus())) {
                    // 4. 세션 생성 (자동 로그인 성공)
                    session.setAttribute("loginMember", member);
                    log.info("자동 로그인 성공: {}", userEmail);

                    // 자동 로그인 시에도 접속 로그 기록
                    memberService.recordAccessLog(member.getMemberId());
                }
            } catch (Exception e) {
                log.warn("자동 로그인 처리 중 오류: {}", e.getMessage());
                // 쿠키가 오염되었거나 회원이 없을 수 있으므로 쿠키 삭제
                loginCookie.setMaxAge(0);
                loginCookie.setPath("/");
                response.addCookie(loginCookie);
            }
        }

        return true; // 로그인 여부와 관계없이 컨트롤러 진행
    }
}