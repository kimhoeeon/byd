package com.byd.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

@Slf4j
@Component
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestURI = request.getRequestURI();

        // 1. 로그인 페이지 및 정적 리소스는 검사 제외
        // (WebMvcConfig에서도 제외하지만 이중 안전장치)
        if (requestURI.equals("/mng") || requestURI.equals("/mng/")
                || requestURI.contains("/mng/index") || requestURI.contains("/mng/login") || requestURI.contains("loginProcess")
                || requestURI.contains("/mng/scanner") || requestURI.contains("/mng/inquiry") || requestURI.contains("/mng/api/")
                || requestURI.contains("/assets/") || requestURI.contains("/css/")
                || requestURI.contains("/js/") || requestURI.contains("/img/")
                || requestURI.equals("/error")) {
            return true;
        }

        // 2. 세션 체크 (로그인 여부 확인)
        HttpSession session = request.getSession(false);

        // 수정: AdminMngController에서 저장한 실제 객체명인 "adminInfo"로 검증
        if (session == null || session.getAttribute("adminInfo") == null) {

            // 문자열만 살아남은 '반쪽짜리 세션'이 무한루프를 만들지 않도록 세션을 완전히 파괴!
            if (session != null) {
                session.invalidate();
            }

            String clientIp = getClientIp(request);
            log.info("관리자 비로그인 접근 차단: IP={} / URI={}", clientIp, requestURI);

            // 3. AJAX 비동기 요청인지 판별
            String ajaxHeader = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(ajaxHeader);

            if (isAjax) {
                // AJAX 요청일 경우 스크립트 대신 401 에러를 반환
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "세션이 만료되었습니다.");
                return false;
            }

            // 일반 화면 이동일 경우 알림창 띄우고 로그인으로 이동
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();

            out.println("<script>");
            out.println("alert('로그인이 필요한 서비스입니다.');");
            // 수정: 존재하지 않는 index.do 대신 정상적인 루트 경로로 이동
            out.println("location.href='" + request.getContextPath() + "/mng/index';");
            out.println("</script>");

            out.flush();
            out.close(); // 더 이상 진행하지 않음

            return false; // 컨트롤러 실행 차단
        }

        return true; // 통과
    }

    // 클라이언트 IP 추출 유틸
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}