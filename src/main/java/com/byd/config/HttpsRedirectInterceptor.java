package com.byd.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Slf4j
@Component
public class HttpsRedirectInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. 로컬 개발 환경(localhost)에서는 리다이렉트 하지 않음
        String host = request.getServerName();
        if ("localhost".equalsIgnoreCase(host) || "127.0.0.1".equals(host)) {
            return true;
        }

        // 2. 현재 프로토콜 확인 (카페24 프록시 헤더 체크)
        // X-Forwarded-Proto 헤더는 로드밸런서/프록시가 원본 프로토콜을 알려주는 표준 헤더입니다.
        String proto = request.getHeader("X-Forwarded-Proto");

        // 헤더가 없으면 기본 secure 상태 확인
        boolean isSecure = request.isSecure() || "https".equalsIgnoreCase(proto);

        // 3. HTTP라면 HTTPS로 리다이렉트
        if (!isSecure) {
            String newUrl = "https://" + host + request.getRequestURI();
            if (request.getQueryString() != null) {
                newUrl += "?" + request.getQueryString();
            }
            response.sendRedirect(newUrl);
            return false; // 요청 중단 및 리다이렉트
        }

        return true; // 통과
    }
}