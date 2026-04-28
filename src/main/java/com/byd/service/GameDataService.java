package com.byd.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.byd.dto.ApiBaseballDTO;
import com.byd.mapper.GameMapper;
import com.byd.vo.GameVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
@Service
@RequiredArgsConstructor
public class GameDataService {

    private final GameMapper gameMapper;

    private final ObjectMapper objectMapper;

    private final RestTemplate restTemplate = new RestTemplate(); // 재사용을 위해 필드로 선언

    /**
     * [핵심 수정] 내부 호출(Self-Invocation) 문제를 해결하기 위해 자기 자신을 주입받습니다.
     * @Lazy를 붙여 순환 참조 오류를 방지합니다.
     */
    @Autowired
    @Lazy
    private GameDataService self;

    /**
     * [스케줄러용] 일일 자동 동기화
     */
    @Transactional
    public void syncDailyData() {
        LocalDate today = LocalDate.now();
        String from = today.minusDays(1).toString();
        String to = today.plusDays(1).toString();
        executeSync(from, to);
    }

    /**
     * 단건 경기 실시간 데이터 업데이트
     * @param apiGameId 외부 API의 경기 ID
     * @return 업데이트된 GameVO 객체 (DB 최신값)
     */
    @Transactional
    public GameVO updateLiveGame(String apiGameId) {
        if (apiGameId == null || apiGameId.length() < 8) return null;

        try {
            // 1. apiGameId에서 날짜 추출 (네이버 API 조회를 위함)
            String rawDate = apiGameId.substring(0, 8);
            String targetDate = rawDate.substring(0, 4) + "-" + rawDate.substring(4, 6) + "-" + rawDate.substring(6, 8);

            // 2. 네이버 스포츠 일정 API 호출 세팅
            URI uri = UriComponentsBuilder.fromHttpUrl("https://api-gw.sports.naver.com/schedule/games")
                    .queryParam("fields", "basic,schedule,baseball,manualRelayUrl")
                    .queryParam("upperCategoryId", "kbaseball")
                    .queryParam("categoryId", "kbo")
                    .queryParam("fromDate", targetDate)
                    .queryParam("toDate", targetDate)
                    .queryParam("size", "100")
                    .build()
                    .toUri();

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            headers.set("Referer", "https://m.sports.naver.com/kbaseball/index");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            // 3. API 통신
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode gamesNode = root.path("result").path("games");

                if (gamesNode.isArray()) {
                    for (JsonNode g : gamesNode) {
                        String currentApiGameId = g.path("gameId").asText(null);

                        // 4. 조회한 리스트 중 타겟 경기와 일치하는 데이터만 파싱 및 저장 수행
                        if (apiGameId.equals(currentApiGameId)) {
                            // 기존에 구축해 둔 네이버 파싱 로직을 100% 재활용 (DB Upsert 자동 수행)
                            if (saveNaverGame(g)) {
                                // 성공적으로 저장되었다면 DB에서 최신 정보를 조회하여 리턴 (상태 변경 감지용)
                                return gameMapper.selectGameByApiId(apiGameId);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error(">>> 경기({}) 실시간 업데이트 실패 (네이버API 통신 오류): {}", apiGameId, e.getMessage());
        }
        return null;
    }

    // 승리팀 판별 로직
    private String determineWinningTeam(String status, int homeScore, int awayScore) {
        if (!"FINISHED".equals(status)) return null;

        // GameVO에 homeTeamCode, awayTeamCode가 있어야 정확하지만,
        // 여기선 단순 로직 (나중에 DB 조회 후 비교 필요할 수 있음)
        // 일단은 'HOME', 'AWAY', 'DRAW' 코드로 반환하도록 약속
        if (homeScore > awayScore) return "HOME"; // 호출처에서 실제 팀코드로 변환 필요할 수도 있음
        if (awayScore > homeScore) return "AWAY";
        return "DRAW";
    }

    /**
     * [관리자용] 특정 기간 데이터 수동 동기화
     */
    @Transactional
    public void syncManualData(String fromDate, String toDate) {
        executeSync(fromDate, toDate);
    }

    /**
     * 특정 연도 전체 데이터 일괄 동기화 (초기 데이터 적재용)
     * 보통 KBO는 3월(시범경기/개막)부터 11월(포스트시즌)까지 진행됩니다.
     */
    public void syncYearlyData(String year) {
        log.info(">>>>>>>>>> [연간 데이터 일괄 수집 시작] {}년도 <<<<<<<<<<", year);

        // 3월부터 11월까지 반복문 실행
        for (int m = 3; m <= 11; m++) {
            String month = String.format("%02d", m);
            log.info(">>> {}년 {}월 데이터 수집 중...", year, month);

            // 기존에 만든 월별 수집 로직 호출
            self.syncMonthlyData(year, month);

            // 월간 이동 시 서버 부하 및 차단 방지를 위해 약간의 휴식 (1초)
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        log.info(">>>>>>>>>> [연간 데이터 일괄 수집 완료] {}년도 <<<<<<<<<<", year);
    }

    /**
     * [관리자용] 특정 월 전체 수집 기능
     */
    @Transactional
    public void syncMonthlyData(String year, String month) {
        try {
            YearMonth yearMonth = YearMonth.of(Integer.parseInt(year), Integer.parseInt(month));
            String from = yearMonth.atDay(1).toString();
            String to = yearMonth.atEndOfMonth().toString();
            executeSync(from, to);
        } catch (Exception e) {
            log.error(">>> 월별 수집 파라미터 에러 ({}년 {}월): {}", year, month, e.getMessage());
        }
    }

    /**
     * 공통 실행 로직: 기간을 입력받아 네이버 API와 통신 후 DB 저장
     */
    private void executeSync(String fromDate, String toDate) {
        AtomicInteger successCount = new AtomicInteger(0);
        try {
            URI uri = UriComponentsBuilder.fromHttpUrl("https://api-gw.sports.naver.com/schedule/games")
                    .queryParam("fields", "basic,schedule,baseball,manualRelayUrl")
                    .queryParam("upperCategoryId", "kbaseball")
                    .queryParam("categoryId", "kbo")
                    .queryParam("fromDate", fromDate)
                    .queryParam("toDate", toDate)
                    .queryParam("size", "200")
                    .build()
                    .toUri();

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            headers.set("Referer", "https://m.sports.naver.com/kbaseball/index");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

            if (response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode gamesNode = root.path("result").path("games");

                if (gamesNode.isArray()) {
                    for (JsonNode g : gamesNode) {
                        if (saveNaverGame(g)) {
                            successCount.incrementAndGet();
                        }
                    }
                }
            }
            log.info(">>> 경기 데이터 동기화 완료 (기간: {} ~ {}, 처리: {}건)", fromDate, toDate, successCount.get());
        } catch (Exception e) {
            log.error(">>> 데이터 동기화 중 에러 발생: {}", e.getMessage());
        }
    }

    /**
     * 개별 경기를 상세 정보까지 포함하여 저장
     */
    private boolean saveNaverGame(JsonNode g) {
        try {
            // 1. API 고유 ID 확인 (필수)
            String apiGameId = g.path("gameId").asText(null);
            if (apiGameId == null) {
                log.warn(">>> Game ID 누락으로 저장 건너뜀: {}", g);
                return false;
            }

            // 2. 날짜 파싱 (YYYY-MM-DD)
            String rawDate = g.path("gameDate").asText(); // "2024-03-09"
            String gameDate = rawDate.length() == 8
                    ? rawDate.substring(0, 4) + "-" + rawDate.substring(4, 6) + "-" + rawDate.substring(6, 8)
                    : rawDate;

            // 3. 시간 파싱
            String gameDateTime = g.path("gameDateTime").asText();
            String gameTime = (gameDateTime.length() >= 19) ? gameDateTime.substring(11, 19) : "00:00:00";

            // 4. 시즌 및 경기 종류(Game Type) 판별
            String season = gameDate.substring(0, 4);
            String roundCode = g.path("roundCode").asText("").toLowerCase(); // kbo_r, kbo_e, kbo_ps_wd...
            String gameType = "REGULAR";

            if (roundCode.startsWith("kbo_e")) {
                gameType = "EXHIBITION"; // 시범경기
            } else if (roundCode.contains("ps") || roundCode.contains("wc") || roundCode.contains("po") || roundCode.contains("ks")) {
                gameType = "POST";       // 포스트시즌 (와일드카드, PO, 한국시리즈 등)
            } else if (roundCode.startsWith("kbo_a")) {
                gameType = "ALLSTAR";    // 올스타전
            }

            // 5. 더블헤더(DH) 판별
            String dhCode = "0";
            if (apiGameId.length() >= 13) {
                char dhChar = apiGameId.charAt(12);
                if (dhChar == '1') dhCode = "1";
                else if (dhChar == '2') dhCode = "2";
            }

            // 6. 팀 정보 매핑
            String homeName = g.path("homeTeamName").asText("");
            String awayName = g.path("awayTeamName").asText("");
            String homeCode = mapNaverTeamName(homeName);
            String awayCode = mapNaverTeamName(awayName);

            // 팀 코드를 알 수 없는 경우(올스타전 드림/나눔 등) 로그 남기고 스킵 가능
            if (homeCode == null || awayCode == null) {
                log.debug(">>> 팀 코드 매핑 불가로 스킵: {} vs {}", homeName, awayName);
                return false;
            }

            // 7. 점수 및 경기 상태 파싱
            int homeScore = g.path("homeTeamScore").asInt(0);
            int awayScore = g.path("awayTeamScore").asInt(0);

            String statusCode = g.path("statusCode").asText(""); // RESULT, STARTED, BEFORE, CANCEL 등
            String statusInfo = g.path("statusInfo").asText("").trim(); // ex: "종료", "우천취소", "9회말"
            boolean isCancel = g.path("cancel").asBoolean(false);

            String status = "SCHEDULED"; // 기본값: 예정
            String cancelReason = null;

            if (isCancel || statusCode.contains("CANCEL") || statusInfo.contains("취소")) {
                status = "CANCELLED";
                cancelReason = statusInfo.isEmpty() ? "취소" : statusInfo;
            } else if ("RESULT".equals(statusCode) || "FINISHED".equals(statusCode) || "END".equals(statusCode) || "FINAL".equals(statusCode) || "종료".equals(statusInfo)) {
                // 종료 판별 조건을 API 변수에 맞게 확장 (한글 텍스트 '종료'까지 완벽하게 커버)
                status = "FINISHED";
            } else if ("STARTED".equals(statusCode) || "ONGOING".equals(statusCode) || "PLAYING".equals(statusCode) || "LIVE".equals(statusCode) || statusInfo.contains("회") || statusInfo.contains("진행")) {
                status = "LIVE";
            } else {
                if (!"BEFORE".equals(statusCode)) {
                    log.debug(">>> 미지정 경기 상태 감지 (statusCode: {}, statusInfo: {}) -> 기본값 SCHEDULED 처리됨", statusCode, statusInfo);
                }
            }

            // 8. 승리팀 판별 (FINISHED 상태일 때만)
            String winningTeam = null;
            if ("FINISHED".equals(status)) {
                String winner = g.path("winner").asText(""); // HOME, AWAY, or empty
                if ("HOME".equals(winner)) {
                    winningTeam = homeCode;
                } else if ("AWAY".equals(winner)) {
                    winningTeam = awayCode;
                } else {
                    // winner 필드가 없으면 점수로 직접 비교
                    if (homeScore > awayScore) winningTeam = homeCode;
                    else if (awayScore > homeScore) winningTeam = awayCode;
                    else winningTeam = "DRAW"; // 무승부
                }
            }

            // 9. MVP(수훈선수) 저장
            // 별도 API 호출 없이 리스트에 있는 '승리 투수' 정보를 MVP로 활용
            String mvpPlayer = null;
            if ("FINISHED".equals(status) && !isCancel) {
                mvpPlayer = g.path("winPitcherName").asText(null);
            }

            // 10. 경기장 ID 매핑 (홈팀 기준)
            int stadiumId = mapStadiumId(homeCode);

            // 11. VO 빌드
            GameVO game = GameVO.builder()
                    .apiGameId(apiGameId)
                    .season(season)
                    .gameType(gameType)
                    .gameDate(gameDate)
                    .gameTime(gameTime)
                    .dhCode(dhCode)
                    .stadiumId(stadiumId)
                    .homeTeamCode(homeCode)
                    .awayTeamCode(awayCode)
                    .homeStarter(g.path("homeStarterName").asText(null))
                    .awayStarter(g.path("awayStarterName").asText(null))
                    .scoreHome(homeScore)
                    .scoreAway(awayScore)
                    .winningTeam(winningTeam)
                    .status(status)
                    .cancelReason(cancelReason)
                    .mvpPlayer(mvpPlayer)
                    .dataSource("API")
                    .build();

            // 12. DB 저장 (UPSERT)
            gameMapper.upsertGame(game);

            return true;

        } catch (Exception e) {
            log.error(">>> 경기 데이터 저장 중 오류 발생 (JSON: {}): {}", g, e.getMessage());
            return false;
        }
    }

    /**
     * 경기 상세 API를 호출하여 MVP 선수 이름을 가져온다.
     * URL: https://api-gw.sports.naver.com/game/kbaseball/games/{gameId}
     */
    private String getMvpFromDetail(String gameId) {
        try {
            URI uri = UriComponentsBuilder.fromHttpUrl("https://api-gw.sports.naver.com/game/kbaseball/games/" + gameId)
                    .build()
                    .toUri();

            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            headers.set("Referer", "https://m.sports.naver.com/kbaseball/index");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());

                // 상세 데이터 구조: content -> mvp -> name
                JsonNode mvpNode = root.path("content").path("mvp");
                if (!mvpNode.isMissingNode()) {
                    return mvpNode.path("name").asText(null);
                }
            }
        } catch (Exception e) {
            // 상세 API 호출 실패는 전체 로직을 중단하지 않고 로그만 남김
            log.warn("MVP 상세 조회 실패 (gameId={}): {}", gameId, e.getMessage());
        }
        return null;
    }

    /**
     * 네이버 팀 명칭을 시스템 팀 코드로 매핑
     */
    private String mapNaverTeamName(String name) {
        if (name == null) return null;
        if (name.contains("LG")) return "LG";
        if (name.contains("KT")) return "KT";
        if (name.contains("SSG")) return "SSG";
        if (name.contains("NC")) return "NC";
        if (name.contains("두산")) return "DOOSAN";
        if (name.contains("KIA")) return "KIA";
        if (name.contains("롯데")) return "LOTTE";
        if (name.contains("삼성")) return "SAMSUNG";
        if (name.contains("한화")) return "HANWHA";
        if (name.contains("키움")) return "KIWOOM";
        return null;
    }

    // 홈팀 코드로 구장 ID 매핑 (DB의 stadiums 테이블 ID와 일치시켜야 함)
    private int mapStadiumId(String homeTeamCode) {
        if (homeTeamCode == null) return 0; // 알 수 없음
        switch (homeTeamCode) {
            case "LG": case "DOOSAN": return 1; // 잠실
            case "KIWOOM": return 2; // 고척
            case "SSG": return 3; // 문학
            case "KT": return 4; // 수원
            case "HANWHA": return 5; // 대전
            case "SAMSUNG": return 6; // 대구
            case "LOTTE": return 7; // 사직
            case "NC": return 8; // 창원
            case "KIA": return 9; // 광주
            default: return 0; // 기본값
        }
    }

    /*****************************************************************************************
     * ***************************************************************************************
     * ***************************************************************************************
     * Rapid API
     * ***************************************************************************************
     * ***************************************************************************************
     * ***************************************************************************************/

    @Value("${api.sports.url}")
    private String apiUrl;

    @Value("${api.sports.key}")
    private String apiKey;

    @Value("${api.sports.host}")
    private String apiHost;

    private static final int KBO_LEAGUE_ID = 293; // API-Baseball의 KBO 리그 ID
    private static final String SEASON = "2025";  // 대상 시즌

    /**
     * 특정 날짜의 경기 데이터를 가져와 DB에 저장/업데이트함
     * @param date 조회할 날짜
     */
    @Transactional
    public void fetchFromRapid(LocalDate date) {
        String dateStr = date.format(DateTimeFormatter.ISO_DATE); // "YYYY-MM-DD"
        log.info(">>> KBO 경기 데이터 업데이트 시작 (날짜: {})", dateStr);

        // 1. API 요청 헤더 설정 (RapidAPI 인증 정보)
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-rapidapi-key", apiKey);
        headers.set("x-rapidapi-host", apiHost);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        // 2. API URL 조립
        String url = String.format("%s?league=%d&season=%s&date=%s&timezone=Asia/Seoul",
                apiUrl, KBO_LEAGUE_ID, SEASON, dateStr);

        try {
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<ApiBaseballDTO> response = restTemplate.exchange(
                    url, HttpMethod.GET, entity, ApiBaseballDTO.class);

            if (response.getBody() != null && response.getBody().getResponse() != null) {
                List<ApiBaseballDTO.ResponseData> games = response.getBody().getResponse();
                log.info(">>> API 응답 수신 성공: {} 건의 경기 발견", games.size());

                for (ApiBaseballDTO.ResponseData data : games) {
                    processGameData(data);
                }
            } else {
                log.warn(">>> 해당 날짜에 데이터가 없거나 API 응답이 비어있습니다.");
            }
        } catch (Exception e) {
            log.error(">>> API 호출 또는 데이터 처리 중 오류 발생", e);
        }
    }

    /**
     * API 개별 경기 데이터를 GameVO로 변환하여 Upsert 실행
     */
    private void processGameData(ApiBaseballDTO.ResponseData data) {
        try {
            // 1. 팀 이름 매핑 (API 명칭 -> 우리 시스템 코드)
            String homeCode = mapRapidTeamName(data.getTeams().getHome().getName());
            String awayCode = mapRapidTeamName(data.getTeams().getAway().getName());

            if (homeCode == null || awayCode == null) {
                log.warn(">>> 미등록 팀 발견으로 스킵: {} vs {}",
                        data.getTeams().getHome().getName(), data.getTeams().getAway().getName());
                return;
            }

            // 2. 경기 상태 및 시간 파싱
            // API 일시 형식: "2025-05-05T18:30:00+09:00"
            String fullDate = data.getFixture().getDate();
            String gameDate = fullDate.substring(0, 10);
            String gameTime = fullDate.substring(11, 19);

            // 3. GameVO 빌더를 사용하여 객체 생성 (수정된 필드 반영)
            GameVO game = GameVO.builder()
                    .apiGameId(String.valueOf(data.getFixture().getId()))  // API 고유 ID 저장
                    .gameDate(gameDate)
                    .gameTime(gameTime)
                    .stadiumId(1) // 우선 기본값 처리 (추후 구장 매핑 로직 추가 가능)
                    .homeTeamCode(homeCode)
                    .awayTeamCode(awayCode)
                    .scoreHome(data.getScores().getHome().getTotal() != null ? data.getScores().getHome().getTotal() : 0)
                    .scoreAway(data.getScores().getAway().getTotal() != null ? data.getScores().getAway().getTotal() : 0)
                    .status(convertStatus(data.getStatus().getShortStatus()))
                    .build();

            // 4. DB 저장 (이미 존재하면 업데이트)
            gameMapper.upsertGame(game);
            log.info(">>> 경기 데이터 저장 완료: {} ({} {}:{})",
                    gameDate, homeCode, game.getScoreHome(), game.getScoreAway());

        } catch (Exception e) {
            log.error(">>> 개별 경기 데이터 처리 중 오류 발생", e);
        }
    }

    /**
     * API 상태 코드를 우리 시스템 상태 코드로 변환
     */
    private String convertStatus(String apiStatus) {
        switch (apiStatus) {
            case "FT": return "FINISHED";  // 종료
            case "NS": return "SCHEDULED"; // 예정
            case "LIVE": case "1IN": case "9IN": return "LIVE"; // 진행중
            case "CANC": case "PST": return "CANCELLED"; // 취소/연기
            default: return "SCHEDULED";
        }
    }

    /**
     * API 팀 명칭을 우리 시스템 코드로 매핑
     */
    private String mapRapidTeamName(String apiTeamName) {
        if (apiTeamName.contains("LG")) return "LG";
        if (apiTeamName.contains("KT") || apiTeamName.contains("Wiz")) return "KT";
        if (apiTeamName.contains("SSG") || apiTeamName.contains("Landers")) return "SSG";
        if (apiTeamName.contains("NC")) return "NC";
        if (apiTeamName.contains("Doosan")) return "DOOSAN";
        if (apiTeamName.contains("KIA")) return "KIA";
        if (apiTeamName.contains("Lotte")) return "LOTTE";
        if (apiTeamName.contains("Samsung")) return "SAMSUNG";
        if (apiTeamName.contains("Hanwha")) return "HANWHA";
        if (apiTeamName.contains("Kiwoom")) return "KIWOOM";
        return null;
    }

    /**
     * API에서 특정 경기(단건) 정보만 가져와 기존 DB 데이터와 병합
     */
    public GameVO fetchSingleGameInfo(String apiGameId) {
        // 1. DB에서 기존 경기 정보 조회 (필수값 유지를 위해)
        GameVO game = gameMapper.selectGameByApiId(apiGameId);
        if (game == null) return null;

        try {
            // 2. API 호출
            URI uri = UriComponentsBuilder.fromHttpUrl(apiUrl)
                    .queryParam("id", apiGameId)
                    .build().toUri();

            HttpHeaders headers = new HttpHeaders();
            headers.set("x-rapidapi-key", apiKey);
            headers.set("x-rapidapi-host", apiHost);
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode responseNode = root.path("response");
                if (responseNode != null && responseNode.isArray() && responseNode.size() > 0) {
                    JsonNode item = responseNode.get(0);

                    // 상태 업데이트
                    JsonNode statusNode = item.path("status");
                    game.setStatus(convertStatus(statusNode.path("short").asText()));

                    // 점수 업데이트
                    JsonNode scoresNode = item.path("scores");
                    if (!scoresNode.isMissingNode()) {
                        game.setScoreHome(scoresNode.path("home").path("total").asInt(0));
                        game.setScoreAway(scoresNode.path("away").path("total").asInt(0));
                    }

                    // 로그 출력을 위한 팀 이름 세팅
                    game.setHomeTeamName(item.path("teams").path("home").path("name").asText());
                    game.setAwayTeamName(item.path("teams").path("away").path("name").asText());

                    return game;
                }
            }
        } catch (Exception e) {
            log.error("단일 경기 데이터 조회 중 오류 발생 (apiGameId: {})", apiGameId, e);
        }
        return game;
    }

    /**
     * 라이브 경기 상태 변경 시 점수 및 상태만 업데이트
     */
    @Transactional
    public void updateGameStatus(GameVO game) {
        gameMapper.updateGameStatusOnly(game);
    }

}