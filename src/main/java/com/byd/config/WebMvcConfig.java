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

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        // 관리자 권한 체크 (관리자 경로만 적용)
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/mng/**")
                .excludePathPatterns(
                        "/mng/assets/**",
                        "/mng/css/**",
                        "/mng/js/**",
                        "/mng/img/**",
                        "/mng",               // 루트 경로 제외
                        "/mng/",              // 루트 경로 제외
                        "/mng/index",         // 로그인 페이지 제외
                        "/mng/login",         // 로그인 페이지 제외
                        "/mng/loginProcess",  // 로그인 처리 API 제외
                        "/mng/scanner",       // 태블릿 QR 스캐너 화면 제외
                        "/mng/inquiry",       // 태블릿 수동 조회 화면 제외
                        "/mng/api/**"         // 태블릿에서 호출하는 API 제외
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