package com.byd.config;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MaintenanceInterceptor implements HandlerInterceptor {

    // 관리자가 제어할 수 있는 전역(Static) 변수 (기본값: false - 오픈 상태)
    public static boolean isMaintenanceMode = false; //기본값 : 잠금
    public static String maintenanceMessage = "현재 서버 점검 중입니다. 이용에 불편을 드려 죄송합니다.";

    // [설정] 백도어 비밀번호 (원하는 값으로 변경하세요)
    private static final String BACKDOOR_KEY = "open_viotory";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 1. 점검 모드가 아니면 모든 접속 허용!
        if (!isMaintenanceMode) {
            return true;
        }

        // --- 여기서부터는 점검 모드(ON)일 때의 로직 ---
        HttpSession session = request.getSession();
        String requestURI = request.getRequestURI();

        // 2. 백도어 통과자 (세션 유지) 확인
        Boolean isPass = (Boolean) session.getAttribute("maintenance_pass");
        if (isPass != null && isPass) {
            return true; // 통과
        }

        // 2. 백도어 키 확인 (URL 파라미터 체크)
        // 예: https://도메인/?pass=open_viotory
        String paramKey = request.getParameter("pass");
        if (BACKDOOR_KEY.equals(paramKey)) {
            session.setAttribute("maintenance_pass", true); // 세션 승인 처리
            session.setMaxInactiveInterval(60 * 60); // 1시간 유지
            return true; // 통과
        }

        // 4. 앱(App)이나 AJAX의 API 요청인 경우 화면 이동 대신 JSON 에러 응답
        if (requestURI.startsWith("/api/")) {
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE); // 503
            response.getWriter().write("{\"error\": \"MAINTENANCE\", \"message\": \"" + maintenanceMessage + "\"}");
            return false;
        }

        // 5. 일반 웹 요청은 점검 안내 페이지로 튕겨냄
        response.sendRedirect("/maintenance");
        return false;
    }

}