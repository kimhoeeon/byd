package com.byd;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

// 1. Security 로그인 화면 차단 (exclude)
// 2. 스케줄러 활성화 (EnableScheduling)
@EnableScheduling
@ServletComponentScan // @WebListener를 찾아서 실행하게 함
@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
public class BydApplication extends SpringBootServletInitializer {

	// [중요] 톰캣이 실행될 때 이 메서드를 가장 먼저 찾아서 실행합니다.
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(BydApplication.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(BydApplication.class, args);
	}

}