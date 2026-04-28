package com.byd.controller;

import com.byd.service.PlayService;
import com.byd.vo.GameVO;
import com.byd.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/play")
@RequiredArgsConstructor
public class PlayController {

    private final PlayService playService;

    // 경기 메인 페이지 (캘린더 + 오늘 경기)
    @GetMapping("")
    public String playMain(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 오늘 날짜 구하기
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("today", today);

        return "play/play"; // views/play/play.jsp
    }

    // 월별 경기 일정(날짜만) 조회 API - 캘린더 마킹용
    @GetMapping("/monthly-schedule")
    @ResponseBody
    public List<String> getMonthlySchedule(@RequestParam("year") int year, @RequestParam("month") int month) {
        // "yyyy-MM" 형식으로 변환 (월은 2자리로 패딩)
        String yearMonth = String.format("%04d-%02d", year, month);
        return playService.getGameDatesInMonth(yearMonth);
    }

    // [AJAX] 날짜별 경기 목록 조회
    @GetMapping("/games")
    @ResponseBody
    public List<GameVO> getGamesByDate(@RequestParam("date") String date, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        return playService.getGameList(loginMember.getMemberId(), date);
    }

}