package com.byd.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private AdminInterceptor adminInterceptor;

    @Autowired
    private HttpsRedirectInterceptor httpsRedirectInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 1. HTTPS 리다이렉트 (보안 - 최우선 실행)
        // .well-known은 SSL 인증서 발급 시 사용되므로 제외
        registry.addInterceptor(httpsRedirectInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/.well-known/**");

        // 2. 유지보수 모드 (백도어 기능 포함)
        // 일반 사용자는 /maintenance로 강제 이동, 백도어 사용자만 통과
        // 오픈 시: WebMvcConfig.java에서 해당 부분 주석 처리 → 배포.
        // 점검 시: 주석 해제 → 배포.
        registry.addInterceptor(new MaintenanceInterceptor())
                .addPathPatterns("/**") // 전체 경로 차단
                .excludePathPatterns(
                        "/maintenance",      // 점검 페이지 (무한 루프 방지)
                        "/assets/**",        // 정적 자원 (CSS, JS, 이미지 등)
                        "/css/**",
                        "/js/**",
                        "/img/**",
                        "/fonts/**",
                        "/favicon.ico",
                        "/site.webmanifest",
                        "/api/test/**",
                        "/api/v1/system/init",
                        "/api/common/upload/editor",
                        "/error",            // 에러 페이지
                        "/.well-known/**",   // SSL 인증
                        "/upload/**",        // 업로드 파일
                        "/mng/**"            // 관리자 페이지는 점검 모드 영향 안 받도록 설정 (필요 시 제거 가능)
                );

        // 3. 관리자 권한 체크 (관리자 경로만 적용)
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/mng/**")
                .excludePathPatterns(
                        "/mng/assets/**",
                        "/mng/css/**",
                        "/mng/js/**",
                        "/mng/img/**",
                        "/mng/login",
                        "/mng/loginAction",
                        "/mng/index",
                        "/mng/index.do"
                );

    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 1. 업로드 경로 설정 (OS 독립적으로 user.home 사용 통일)
        String uploadPath = "file:///tomcat/webapps/upload/";

        // /upload/** URL로 요청 시 실제 서버의 저장 폴더로 연결
        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);
    }
}