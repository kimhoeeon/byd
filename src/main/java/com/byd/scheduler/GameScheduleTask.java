package com.byd.scheduler;

import com.google.firebase.messaging.*;
import com.byd.mapper.MemberMapper;
import com.byd.service.AlarmService;
import com.byd.service.GameDataService;
import com.byd.service.GameService;
import com.byd.vo.GameVO;
import com.byd.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class GameScheduleTask {

    private final GameDataService gameDataService;
    private final GameService gameService; // DB 조회용
    private final AlarmService alarmService; // 알림 서비스 주입
    private final MemberMapper memberMapper;

    /**
     * [ 네이버/API ]
     * [정기 동기화] 매일 새벽 2시
     * - 전날 경기 결과 확정 및 오늘 일정 생성
     */
    @Scheduled(cron = "0 0 2 * * *")
    public void runDailySync() {
        log.info("### [스케줄러] 정기 경기 데이터 동기화 시작 (새벽 2시)");
        try {
            gameDataService.syncDailyData();
            log.info("### [스케줄러] 정기 경기 데이터 동기화 완료");
        } catch (Exception e) {
            log.error("### [스케줄러] 에러 발생: {}", e.getMessage());
        }
    }

    /**
     * [통합 라이브 스케줄러] 매일 08시 ~ 익일 02시 59분 (1분 간격)
     * - 실시간 점수 확인
     * - 경기 상태 변경(LIVE, FINISHED, CANCELLED) 감지 시 1회 알림 발송 및 DB 변경
     * - 경기 종료 및 취소 시 승부예측 정산 (1회 보장)
     * - 아침 일찍 우천취소 및 자정 넘어가는 연장전 완벽 대응
     */
    @Scheduled(cron = "0 0/3 13-23,0-1 * * *")
    public void runLiveSync() {
        log.debug(">>> [라이브 스케줄러] 실시간 경기 정보 확인 중...");

        // 진행 중이거나 오늘 예정된 경기 타겟팅
        List<GameVO> targetGames = gameService.getOngoingGames();

        // 관리할 경기가 없으면 즉시 리턴 (자원 절약)
        if (targetGames.isEmpty()) return;

        for (GameVO game : targetGames) {
            try {

                if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                    continue;
                }

                // 네이버 API도 비공식이므로, IP 차단을 피하기 위해 2초 대기 후 호출
                Thread.sleep(2000);

                // 1. 네이버 API를 통해 최신 점수 및 상태 업데이트
                GameVO updatedGame = gameDataService.updateLiveGame(game.getApiGameId());

                if (updatedGame != null) {
                    // 상태 변경 감지 시 (ex. SCHEDULED -> LIVE -> FINISHED)
                    if (!game.getStatus().equals(updatedGame.getStatus())) {
                        log.info(">>> [상태 변경 감지] {} vs {}, 상태 : {} -> {}",
                                updatedGame.getHomeTeamName(), updatedGame.getAwayTeamName(), game.getStatus(), updatedGame.getStatus());

                        // 2. 알림 발송
                        createGameStatusAlarm(updatedGame, updatedGame.getStatus());

                        // 3. 확실한 업데이트 처리
                        gameDataService.updateGameStatus(updatedGame);
                    }
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.error(">>> [라이브 스케줄러] 루프 대기 중 인터럽트 발생");
            } catch (Exception e) {
                log.error(">>> [라이브 스케줄러] 경기({}) 업데이트 실패: {}", game.getGameId(), e.getMessage());
            }
        }
    }

    // =========================================================================
    // 1. 경기 종료 등 상태 변환 시 알림 (기존 runLiveSync에서 호출됨)
    // =========================================================================
    private void createGameStatusAlarm(GameVO game, String newStatus) {
        try {
            if ("FINISHED".equals(newStatus)) {
                // [Case 2] 경기 종료 시 : 예측/일기를 남긴 유저만 필터링
                List<MemberVO> targets = memberMapper.selectGameParticipants(game.getGameId(), game.getHomeTeamCode(), game.getAwayTeamCode());
                sendAlarmToUsers(targets, "[승요일기] 오늘 경기 끝! 직관 일기를 남겨보세요", "/diary/write?gameId=" + game.getGameId());
            } else if ("CANCELLED".equals(newStatus)) {
                String message = game.getAwayTeamName() + " vs " + game.getHomeTeamName() + " 경기가 취소되었습니다.";
                sendGameAlarmToTeam(game, message, "/main");
            }
            // LIVE 상태 시 알림은 QA 기획에 없으므로 스팸 방지를 위해 생략
        } catch (Exception e) {
            log.error("경기 상태 변경 알림 실패", e);
        }
    }

    // =========================================================================
    // 2. 경기 1시간 전, 30분 전 스케줄러 (매 분 0초마다 실행되어 시간 검사)
    // =========================================================================
    @Scheduled(cron = "0 * * * * *")
    public void checkUpcomingGames() {
        List<GameVO> games = gameService.getOngoingGames(); // 오늘 대상 경기 목록

        if (games == null || games.isEmpty()) return;

        LocalTime now = LocalTime.now();

        for (GameVO game : games) {
            // 이미 종료되었거나 취소된 경기는 패스
            if (game.getGameTime() == null || "FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) continue;

            try {
                LocalTime gameTime = LocalTime.parse(game.getGameTime());

                // [Case 3] 경기 시작 딱 1시간 전
                if (now.getHour() == gameTime.minusHours(1).getHour() && now.getMinute() == gameTime.getMinute()) {
                    sendGameAlarmToTeam(game, "[승요일기] 오늘 우리 팀의 스코어를 기록해 보세요!", "/play");
                }
                // [Case 1] 경기 시작 딱 30분 전
                if (now.getHour() == gameTime.minusMinutes(30).getHour() && now.getMinute() == gameTime.minusMinutes(30).getMinute()) {
                    sendGameAlarmToTeam(game, "[승요일기] 오늘 우리 팀 경기 시작 30분 전이에요", "/play");
                }
            } catch (Exception e) {
                // 시간 파싱 오류 등은 건너뜀
            }
        }
    }

    // =========================================================================
    // 3. 해당 경기를 치르는 양 팀 팬 전체를 타겟팅하는 헬퍼
    // =========================================================================
    private void sendGameAlarmToTeam(GameVO game, String message, String url) {
        List<MemberVO> targets = memberMapper.selectMembersForGameAlarm(game.getHomeTeamCode(), game.getAwayTeamCode());
        sendAlarmToUsers(targets, message, url);
    }

    // =========================================================================
    // 4. DB 알림 생성 및 FCM 앱 푸시 동시 발송 코어 엔진
    // =========================================================================
    private void sendAlarmToUsers(List<MemberVO> users, String message, String linkUrl) {
        if (users == null || users.isEmpty()) return;

        List<String> tokens = new ArrayList<>();
        for (MemberVO member : users) {

            // 1. 사용자 앱 내 알림(종 모양) DB 저장 (기존 AlarmService 완벽 호환)
            alarmService.sendAlarm(member.getMemberId(), "GAME", "경기 알림", message, linkUrl);

            // 2. 푸시 발송을 위한 토큰 수집 (푸시 수신 동의자 & fcmToken 보유자만)
            if ("Y".equals(member.getPushYn()) && member.getFcmToken() != null && !member.getFcmToken().trim().isEmpty()) {
                tokens.add(member.getFcmToken());
            }
        }

        // 3. 수집된 토큰으로 실제 스마트폰 기기 팝업(FCM) 발송
        if (!tokens.isEmpty()) {
            try {
                for (int i = 0; i < tokens.size(); i += 500) { // FCM 최대 전송 제한 500개씩 분할
                    List<String> batch = tokens.subList(i, Math.min(i + 500, tokens.size()));
                    MulticastMessage fcmMessage = MulticastMessage.builder()
                            // 1. 공통 알림 내용 (iOS/Android 공통 배너 텍스트)
                            .setNotification(Notification.builder()
                                    .setTitle("경기 알림") // 앱 푸시 팝업 상단 타이틀
                                    .setBody(message)
                                    .build())

                            // 2. 딥링크 데이터 (Appify 규격에 맞춘 화면 이동 URL)
                            .putData("title", "경기 알림")
                            .putData("body", message)
                            .putData("link", linkUrl)

                            // 3. 안드로이드(Android) 전용 설정 (Appify 필수 규격)
                            .setAndroidConfig(AndroidConfig.builder()
                                    .setPriority(AndroidConfig.Priority.HIGH)
                                    .setNotification(AndroidNotification.builder()
                                            .setChannelId("default")
                                            .setVisibility(AndroidNotification.Visibility.PUBLIC)
                                            .setSound("default")
                                            .build())
                                    .build())

                            // 4. 아이폰(iOS) 전용 설정 (진동/소리 강제 활성화)
                            .setApnsConfig(ApnsConfig.builder()
                                    .putHeader("apns-priority", "10")
                                    .setAps(Aps.builder()
                                            .setSound("default") // 아이폰에서 무음으로 오지 않도록 설정
                                            .setContentAvailable(true)
                                            .build())
                                    .build())

                            .addAllTokens(batch)
                            .build();
                    FirebaseMessaging.getInstance().sendEachForMulticast(fcmMessage);
                }
            } catch (Exception e) {
                log.error("경기 스케줄러 FCM 푸시 발송 오류: ", e);
            }
        }
    }

    /**
     * [알림 정리] 매일 새벽 4시
     * - 7일이 지난 오래된 알림 데이터 삭제
     */
    @Scheduled(cron = "0 0 4 * * *")
    public void runAlarmCleanup() {
        log.info("### [스케줄러] 오래된 알림 삭제 시작 (새벽 4시)");
        try {
            alarmService.deleteExpiredAlarms();
            log.info("### [스케줄러] 오래된 알림 삭제 완료");
        } catch (Exception e) {
            log.error("### [스케줄러] 알림 삭제 중 에러 발생: {}", e.getMessage());
        }
    }

    /*// 1. 매일 새벽 2시에 '오늘' 예정된 경기 일정을 가져옴 (초기화)
    @Scheduled(cron = "0 0 2 * * *")
    public void scheduleDailyUpdate() {
        log.info("[Batch] 새벽 정기 업데이트 시작");
        gameDataService.fetchFromRapid(LocalDate.now());
    }

    // 2. 경기 시간대(18시~23시)에 10분마다 라이브 스코어 갱신
    // (하루 100회 제한을 고려하여 10분 간격 설정)
    @Scheduled(cron = "0 0/10 18-23 * * *")
    public void scheduleLiveScoreUpdate() {
        log.info("[Batch] 라이브 스코어 업데이트 시작");
        gameDataService.fetchFromRapid(LocalDate.now());
    }*/

}