package com.byd.controller;

import com.byd.service.GameDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.Objects;

@RestController
@RequiredArgsConstructor
public class ApiTestController {

    @Autowired GameDataService gameDataService;
    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * 네이버 스포츠 API 원본 데이터 확인용 엔드포인트
     * 사용법: /api/test/naver?date=20240323 (날짜 지정)
     */
    @GetMapping("/api/test/naver")
    public String getNaverApiRawData(@RequestParam(value = "date", defaultValue = "20240323") String date) {

        // 검색 기간 설정 (해당 날짜 하루치만 조회)
        // 포맷이 YYYYMMDD로 들어온다고 가정
        String fromDate = date;
        String toDate = date;

        try {
            // 네이버 API 호출 URL 생성
            URI uri = UriComponentsBuilder.fromHttpUrl("https://api-gw.sports.naver.com/schedule/games")
                    .queryParam("fields", "basic,schedule,baseball,manualRelayUrl")
                    .queryParam("upperCategoryId", "kbaseball")
                    .queryParam("categoryId", "kbo")
                    .queryParam("fromDate", fromDate)
                    .queryParam("toDate", toDate)
                    .queryParam("size", "100")
                    .build()
                    .toUri();

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            headers.set("Referer", "https://m.sports.naver.com/kbaseball/index");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

            // API 응답 원본(JSON 문자열) 반환
            return response.getBody();

        } catch (Exception e) {
            return "에러 발생: " + e.getMessage();
        }
    }

    /**
     * 경기 상세 정보(MVP 포함) 확인용
     * 사용법: /api/test/naver/detail?gameId=20240309HTNC02024
     */
    /**
     * [만능 테스트] URL 경로 패턴 찾기
     * 사용법: /api/test/url?path=baseball/kbo/games/20240309HTNC02024
     */
    @GetMapping("/api/test/url")
    public String testAnyUrl(@RequestParam("path") String path) {
        try {
            // 앞부분(https://api-gw.sports.naver.com/)은 고정하고 뒷부분만 바꿈
            String url = "https://api-gw.sports.naver.com/" + path;

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            headers.set("Referer", "https://m.sports.naver.com/"); // Referer 범용 설정
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);

            return "성공 URL: " + url + "\n\n" + response.getBody();
        } catch (Exception e) {
            return "실패 (" + path + ")\n에러: " + e.getMessage();
        }
    }

    /**
     * [API 경로 자동 발굴 스캐너]
     * 사용법: /api/test/scan?gameId=20240309HTNC02024
     */
    @GetMapping("/api/test/scan")
    public String scanGameDetailUrl(@RequestParam("gameId") String gameId) {
        String[] prefixes = { "", "/v1", "/v2" }; // 버전 접두어
        String[] services = { "game", "schedule" }; // 서비스명
        String[] categories = { "kbaseball", "kbo" }; // 카테고리명
        String[] resources = { "games", "game" }; // 리소스명 (복수/단수)
        String[] suffixes = { "wrapup", "basic", "boxscore", "records", "" }; // 상세 경로

        StringBuilder log = new StringBuilder("=== 스캔 시작 (" + gameId + ") ===\n");

        for (String service : services) {
            for (String ver : prefixes) {
                for (String cat : categories) {
                    for (String res : resources) {
                        for (String suffix : suffixes) {
                            // URL 조합: https://api-gw.sports.naver.com/{service}{ver}/{category}/{resource}/{id}/{suffix}
                            String path = String.format("%s%s/%s/%s/%s", service, ver, cat, res, gameId);
                            if (!suffix.isEmpty()) path += "/" + suffix;

                            String url = "https://api-gw.sports.naver.com/" + path;

                            try {
                                HttpHeaders headers = new HttpHeaders();
                                headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
                                headers.set("Referer", "https://m.sports.naver.com/kbaseball/index");
                                HttpEntity<String> entity = new HttpEntity<>(headers);

                                RestTemplate rt = new RestTemplate();
                                ResponseEntity<String> response = rt.exchange(url, HttpMethod.GET, entity, String.class);

                                if (response.getStatusCode().is2xxSuccessful()) {
                                    return "★ 찾았다! 성공 URL ★\n" + url + "\n\n응답 데이터(일부분):\n" +
                                            (Objects.requireNonNull(response.getBody()).length() > 500 ? response.getBody().substring(0, 500) : response.getBody());
                                }
                            } catch (Exception e) {
                                // 404 등 에러는 무시하고 계속 진행
                            }
                        }
                    }
                }
            }
        }
        return log.append("\n모든 조합 실패. ID가 유효한지 확인해주세요.").toString();
    }

    @GetMapping("/api/test/resync")
    public String resyncData() {
        gameDataService.syncMonthlyData("2024", "03"); // 3월 (시범)
        gameDataService.syncMonthlyData("2024", "10"); // 10월 (포스트)
        return "데이터 갱신 완료!";
    }

}