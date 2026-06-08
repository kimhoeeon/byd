package com.byd.controller;

import com.byd.service.QuizService;
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

    @GetMapping("/list")
    public String quizList(@RequestParam(required = false) String keyword,
                           @RequestParam(required = false) String perfectScoreOnly,
                           Model model) {
        List<QuizUserVO> list = quizService.getQuizAdminList(keyword, perfectScoreOnly);
        model.addAttribute("list", list);
        model.addAttribute("keyword", keyword);
        model.addAttribute("perfectScoreOnly", perfectScoreOnly);
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

    // 1. 문제 관리 페이지 화면
    @GetMapping("/question/list")
    public String questionList(Model model) {
        model.addAttribute("qList", quizService.getQuestionList());
        return "mng/quiz/question/list"; // 신규 생성할 jsp 경로
    }

    // 2. 단건 조회 (모달에 데이터 뿌려주기용)
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

    // 3. 문제 저장 및 수정 API
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

    // 4. 문제 삭제 API
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