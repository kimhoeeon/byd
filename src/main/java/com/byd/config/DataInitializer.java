package com.byd.config;

import com.byd.service.GameDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final GameDataService gameDataService;

    @Override
    public void run(String... args) throws Exception {
        // 서버 시작 시 2025년도 데이터 전체 수집 (최초 1회만 실행 후 주석 처리 권장)
        // System.out.println(">>> [초기화] 2025년 KBO 경기 데이터 수집 시작...");
        // gameDataService.syncYearlyData("2025");
        // System.out.println(">>> [초기화] 수집 완료!");
    }
}