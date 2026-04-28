package com.byd.service;

import com.byd.dto.WinYoAnalysisDTO;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestPropertySource;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@SpringBootTest
@TestPropertySource(properties = {
        "spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver",
        "spring.datasource.url=jdbc:mysql://203.245.44.104:3306/viotorydiary?serverTimezone=Asia/Seoul&characterEncoding=UTF-8&useUnicode=true&allowPublicKeyRetrieval=true&useSSL=false",
        "spring.datasource.username=root",
        "spring.datasource.password=fan2web12!@"
})
class WinYoServiceTest {

    @Autowired
    private WinYoService winYoService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    @DisplayName("관리자 및 발주사 비밀번호 해시값 생성")
    void generatePasswordHash() {
        // 1. 암호화할 평문 비밀번호
        String adminPwRaw = "fan2web12!@";
        String clientPwRaw = "fan2lab12!@";

        // 2. BCrypt 암호화 수행
        String adminPwHash = passwordEncoder.encode(adminPwRaw);
        String clientPwHash = passwordEncoder.encode(clientPwRaw);

        // 3. 결과 출력 (로그 확인)
        log.info("==================================================");
        log.info("[관리자 계정] ID: meetingfan");
        log.info("  - 평문 비번: {}", adminPwRaw);
        log.info("  - 해시 비번: {}", adminPwHash);
        log.info("--------------------------------------------------");
        log.info("[발주사 계정] ID: creative-lab");
        log.info("  - 평문 비번: {}", clientPwRaw);
        log.info("  - 해시 비번: {}", clientPwHash);
        log.info("==================================================");
    }

    @Test
    @DisplayName("승요력 분석 엔진 테스트 - 2승 1패 시나리오")
    @Transactional
    void analyzeWinYoPowerTest() {
        // Given
        Long memberId = 1L;

        // When
        WinYoAnalysisDTO result = winYoService.analyzeWinYoPower(memberId);

        // Then (검증)
        log.info("===========================================");
        log.info("분석 결과 객체: {}", result);
        log.info("===========================================");

        // 1. DTO가 null이 아닌지 확인
        assertNotNull(result, "분석 결과(DTO)가 null입니다. Service 로직을 확인하세요.");

        // 2. 기본 통계 검증
        assertEquals(3, result.getTotalGames(), "총 직관 경기 수는 3경기여야 함");
        assertEquals(2, result.getWinGames(), "승리 경기는 2경기여야 함");
        assertEquals(1, result.getLoseGames(), "패배 경기는 1경기여야 함");

        // 3. 승률 등급 검증 (2승/3경기 = 66.6% -> B등급)
        assertEquals("B", result.getWinRateGrade(), "승률 등급은 B여야 함");

        // 4. 최근 흐름 검증 (2승 1패 -> 상승세)
        assertEquals("UP", result.getTrendCode(), "최근 흐름은 상승세(UP)여야 함");

        // 5. 멘트 매핑 검증
        assertNotNull(result.getMainMessage(), "메인 멘트가 비어있음");
        assertNotNull(result.getSubMessage(), "서브 멘트가 비어있음");

        System.out.println(">>> 메인 멘트: " + result.getMainMessage());
        System.out.println(">>> 서브 멘트: " + result.getSubMessage());
    }

}