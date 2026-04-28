package com.byd.controller;

import com.byd.service.GameDataService;
import com.byd.service.GameMngService;
import com.byd.vo.GameVO;
import com.byd.vo.StadiumVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/game")
@RequiredArgsConstructor
public class GameMngController {

    private final GameDataService gameDataService;
    private final GameMngService gameMngService;

    /**
     * 경기 데이터 관리 페이지 (목록 + 동기화 버튼)
     */
    @GetMapping({"/list", "/syncPage"})
    public String gameList(Model model,
                           @RequestParam(value = "ym", required = false) String ym,
                           @RequestParam(value = "year", required = false) String year,
                           @RequestParam(value = "month", required = false) String month) {

        // 1. 파라미터가 없으면 무조건 '현재 연도-월' 세팅
        if (ym == null || ym.isEmpty()) {
            if (year != null && month != null) {
                ym = year + "-" + String.format("%02d", Integer.parseInt(month));
            } else {
                ym = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
        }

        // 2. 데이터 조회
        List<GameVO> list = gameMngService.getGameList(ym);
        List<StadiumVO> stadiums = gameMngService.getStadiumList();

        // 3. 뷰 전달
        model.addAttribute("stadiums", stadiums);
        model.addAttribute("list", list);
        model.addAttribute("ym", ym);

        return "mng/game/game_list";
    }

    /**
     * [액션] 월간 데이터 동기화
     */
    @PostMapping("/syncMonthly") // ★ 수정: POST 요청 처리
    @ResponseBody
    public String manualSync(@RequestParam("year") String year,
                             @RequestParam("month") String month) {
        try {
            gameDataService.syncMonthlyData(year, month);
            return "ok";
        } catch (Exception e) {
            log.error("동기화 실패", e);
            return "fail: " + e.getMessage();
        }
    }

    /**
     * [액션] 연간 데이터 동기화
     */
    @PostMapping("/syncYearly") // ★ 수정: POST 요청 처리
    @ResponseBody
    public String syncYearlyData(@RequestParam("year") String year) {
        try {
            gameDataService.syncYearlyData(year);
            return "ok";
        } catch (Exception e) {
            log.error("연간 동기화 실패", e);
            return "fail: " + e.getMessage();
        }
    }

    // 상세 조회 (AJAX)
    @GetMapping("/get")
    @ResponseBody
    public GameVO getGame(@RequestParam("gameId") Long gameId) {
        return gameMngService.getGame(gameId);
    }

    // 저장
    @PostMapping("/save")
    @ResponseBody
    public String saveGame(GameVO game) {
        try {
            // "우천취소" 선택 시 DB 스키마에 맞게 데이터 매핑
            if ("RAIN".equals(game.getStatus())) {
                game.setStatus("CANCELLED");
            } else if (!"CANCELLED".equals(game.getStatus())) {
                // "취소"가 아닌 다른 상태(예정, 진행중, 종료)일 경우 취소 사유 초기화
                game.setCancelReason(null);
            }

            gameMngService.saveGame(game);
            return "ok"; // 성공 시 ok 반환
        } catch (Exception e) {
            log.error("경기 저장 실패", e);
            return "fail: " + e.getMessage(); // 실패 시 메시지 반환
        }
    }

    // 삭제
    @PostMapping("/delete")
    @ResponseBody
    public String deleteGame(@RequestParam("gameId") Long gameId) {
        try {
            gameMngService.deleteGame(gameId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

}