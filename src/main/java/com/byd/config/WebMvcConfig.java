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
        registry.addInterceptor(new MaintenanceInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/maintenance",
                        "/assets/**",
                        "/css/**",
                        "/js/**",
                        "/img/**",
                        "/fonts/**",
                        "/favicon.ico",
                        "/site.webmanifest",
                        "/api/test/**",
                        "/api/v1/system/init",
                        "/api/common/upload/editor",
                        "/error",
                        "/.well-known/**",
                        "/upload/**",
                        "/mng/**" // 관리자 페이지는 점검 모드 영향 안 받도록 설정
                );

        // 3. 관리자 권한 체크 (관리자 경로만 적용)
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/mng/**")
                .excludePathPatterns(
                        "/mng/assets/**",
                        "/mng/css/**",
                        "/mng/js/**",
                        "/mng/img/**",
                        "/mng/login",         // 로그인 페이지 제외
                        "/mng/loginProcess"    // 로그인 처리 API 제외
                );

    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 업로드 경로 설정 (필요 시 유지, 미사용 시 삭제 가능)
        String uploadPath = "file:///tomcat/webapps/upload/";

        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);
    }
}