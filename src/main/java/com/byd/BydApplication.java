package com.byd;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class BydApplication extends SpringBootServletInitializer {

	// 외부 톰캣(카페24) 구동을 위한 설정
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(BydApplication.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(BydApplication.class, args);
	}
}