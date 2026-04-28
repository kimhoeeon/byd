package com.byd.service;

import com.byd.mapper.GameMngMapper;
import com.byd.mapper.MemberMapper;
import com.byd.vo.GameVO;
import com.byd.vo.MemberVO;
import com.byd.vo.StadiumVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class GameMngService {

    private final GameMngMapper gameMngMapper;
    private final AlarmService alarmService;
    private final MemberMapper memberMapper;
    private final PlayService playService;

    public List<GameVO> getGameList(String yearMonth) {
        return gameMngMapper.selectGameListByMonth(yearMonth);
    }

    public GameVO getGame(Long gameId) {
        return gameMngMapper.selectGameById(gameId);
    }

    @Transactional
    public void saveGame(GameVO game) {
        if (game.getGameId() == null) {
            gameMngMapper.insertGame(game);
        } else {
            // 1. 상태 변경 감지를 위해 기존 데이터 조회
            GameVO oldGame = gameMngMapper.selectGameById(game.getGameId());
            String oldStatus = (oldGame != null && oldGame.getStatus() != null) ? oldGame.getStatus() : "";

            // 2. 관리자가 수정한 정보로 업데이트
            gameMngMapper.updateGame(game);

            // 3. 상태가 변경되었을 경우 알림 발송 및 승부예측 결과 처리
            if (oldGame != null && !oldStatus.equals(game.getStatus())) {
                sendGameStatusAlarm(game);
            }
        }
    }

    // =========================================
    // 관리자 수동 상태 변경 시 알림 발송 로직
    // =========================================
    private void sendGameStatusAlarm(GameVO game) {
        try {
            String title = "경기 알림";
            String message = "";
            String homeName = getTeamNameKr(game.getHomeTeamCode());
            String awayName = getTeamNameKr(game.getAwayTeamCode());

            if ("LIVE".equals(game.getStatus())) {
                message = awayName + " vs " + homeName + " 경기가 시작되었습니다!";
            } else if ("FINISHED".equals(game.getStatus())) {
                message = awayName + " vs " + homeName + " 경기가 종료되었습니다.";
            } else if ("CANCELLED".equals(game.getStatus())) {
                message = awayName + " vs " + homeName + " 경기가 취소되었습니다.";
            }

            if (message.isEmpty()) return;

            // 해당 경기를 치르는 팀을 내 응원팀으로 설정하고 앱 알림을 켜둔 회원 조회
            List<MemberVO> targetMembers = memberMapper.selectMembersForGameAlarm(game.getHomeTeamCode(), game.getAwayTeamCode());

            for (MemberVO member : targetMembers) {
                alarmService.sendAlarm(member.getMemberId(), "GAME", title, message, "/main");
            }
            log.info("관리자 수동 상태 변경: {} 알림 발송 완료 (대상자 {}명)", game.getStatus(), targetMembers.size());
        } catch (Exception e) {
            log.error("수동 경기 상태 변경 알림 전송 실패", e);
        }
    }

    // 영어 팀 코드를 한글 명칭으로 변환
    private String getTeamNameKr(String code) {
        if (code == null) return "";
        switch (code.toUpperCase()) {
            case "DOOSAN": return "두산";
            case "LOTTE": return "롯데";
            case "SAMSUNG": return "삼성";
            case "KIWOOM": return "키움";
            case "HANWHA": return "한화";
            default: return code.toUpperCase(); // LG, KT, SSG, NC, KIA 등은 영문 그대로
        }
    }

    @Transactional
    public void deleteGame(Long gameId) {
        gameMngMapper.deleteGame(gameId);
    }

    public List<StadiumVO> getStadiumList() {
        return gameMngMapper.selectStadiumList();
    }

}