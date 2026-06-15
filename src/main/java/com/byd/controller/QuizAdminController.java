package com.byd.controller;

import com.byd.service.QuizService;
import com.byd.vo.DailyStatsVO;
import com.byd.vo.QuizQuestionVO;
import com.byd.vo.QuizUserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/mng/quiz")
@RequiredArgsConstructor
public class QuizAdminController {

    private final QuizService quizService;

    // 날짜와 회차 검색 파라미터 추가
    @GetMapping("/list")
    public String quizList(@RequestParam(required = false) String keyword,
                           @RequestParam(required = false) String perfectScoreOnly,
                           @RequestParam(required = false) String searchDate,
                           @RequestParam(required = false) Integer searchSession,
                           Model model) {

        List<QuizUserVO> list = quizService.getQuizAdminList(keyword, perfectScoreOnly, searchDate, searchSession);

        // 최근 7일 접속자 통계 데이터 조회
        List<DailyStatsVO> visitStats = quizService.getQuizDailyVisitStats();

        model.addAttribute("list", list);
        model.addAttribute("visitStats", visitStats);
        model.addAttribute("keyword", keyword);
        model.addAttribute("perfectScoreOnly", perfectScoreOnly);
        model.addAttribute("searchDate", searchDate);
        model.addAttribute("searchSession", searchSession);

        return "mng/quiz/list";
    }

    @PostMapping("/api/toggleGift")
    @ResponseBody
    public Map<String, Object> toggleGift(@RequestParam("historySeq") int historySeq, @RequestParam("status") String status) {
        Map<String, Object> res = new HashMap<>();
        try {
            quizService.toggleGiftStatus(historySeq, status);
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "오류가 발생했습니다.");
        }
        return res;
    }

    @GetMapping("/question/list")
    public String questionList(Model model) {
        model.addAttribute("qList", quizService.getQuestionList());
        return "mng/quiz/question/list";
    }

    @GetMapping("/question/api/get")
    @ResponseBody
    public Map<String, Object> getQuestion(@RequestParam("questionId") int questionId) {
        Map<String, Object> res = new HashMap<>();
        try {
            res.put("success", true);
            res.put("data", quizService.getQuestionById(questionId));
        } catch (Exception e) {
            res.put("success", false);
        }
        return res;
    }

    @PostMapping("/question/api/save")
    @ResponseBody
    public Map<String, Object> saveQuestion(QuizQuestionVO question) {
        Map<String, Object> res = new HashMap<>();
        try {
            quizService.saveQuestion(question);
            res.put("success", true);
            res.put("message", "정상적으로 저장되었습니다.");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "저장 중 오류가 발생했습니다.");
        }
        return res;
    }

    @PostMapping("/question/api/delete")
    @ResponseBody
    public Map<String, Object> deleteQuestion(@RequestParam("questionId") int questionId) {
        Map<String, Object> res = new HashMap<>();
        try {
            quizService.deleteQuestion(questionId);
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "삭제 중 오류가 발생했습니다.");
        }
        return res;
    }
}