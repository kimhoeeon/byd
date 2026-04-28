package com.byd.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpStatusRequestRejectedHandler;
import org.springframework.security.web.firewall.RequestRejectedHandler;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // Spring Security의 기본 로그인 화면 및 차단 기능을 해제합니다.
    // 기존 인터셉터(AdminInterceptor 등)가 로그인 체크를 수행하므로 여기서는 문을 열어둡니다.
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf().disable() // CSRF 보안 해제
                .formLogin().disable() // 기본 로그인 페이지 사용 안 함
                .headers().frameOptions().disable() // h2-console 등 iframe 허용
                .and()
                .authorizeRequests()
                // 정적 리소스와 manifest 파일은 누구나 접근 가능하게 허용
                .antMatchers("/css/**", "/js/**", "/img/**", "/assets/**", "/favicon.ico", "/site.webmanifest").permitAll()
                .antMatchers("/api/common/**", "/api/v1/system/init").permitAll()
                .anyRequest().permitAll(); // 나머지 요청도 일단 허용 (보안은 Interceptor에서 처리하므로)

        return http.build();
    }

    // PasswordEncoder Bean 등록
    // AdminService에서 @Autowired PasswordEncoder를 사용할 수 있게 해줍니다.
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // 외부 봇이나 스캐너가 PROPFIND 등 허용되지 않은 HTTP 메서드를 보냈을 때 (방화벽 거부 시)
    // 에러 로그(스택 트레이스)를 남기지 않고 조용히 HTTP 상태 코드 400(Bad Request)만 반환하도록 처리합니다.
    @Bean
    public RequestRejectedHandler requestRejectedHandler() {
        return new HttpStatusRequestRejectedHandler();
    }
}