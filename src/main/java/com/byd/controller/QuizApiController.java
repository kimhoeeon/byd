package com.byd.controller;

import com.byd.service.QuizService;
import com.byd.vo.QuizUserVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/quiz")
@RequiredArgsConstructor
public class QuizApiController {

    private final QuizService quizService;

    // 1. 유저 진입 가능 여부 체크
    @GetMapping("/check")
    public Map<String, Object> checkEligibility(@RequestParam("name") String name, @RequestParam("phone") String phone) {
        return quizService.checkEligibility(name, phone);
    }

    // 2. 유저 정보 등록 및 각자 다른 랜덤 10문제 반환 시작
    @PostMapping("/start")
    public Map<String, Object> startQuiz(@RequestBody QuizUserVO userVO) {
        return quizService.startQuiz(userVO);
    }

    // 3. 개별 유저 문제 풀이 시 자동 실시간 백업 (10초 지나 자동 이동 및 터치 즉시 연동)
    @PostMapping("/auto-save")
    public Map<String, Object> autoSaveAnswer(@RequestParam("historySeq") int historySeq,
                                              @RequestParam("questionIndex") int questionIndex,
                                              @RequestParam("answerId") int answerId) {
        Map<String, Object> result = new HashMap<>();
        try {
            quizService.saveUserAnswer(historySeq, questionIndex, answerId);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    // 4. 최종 답안 채점 요청
    @PostMapping("/submit")
    public Map<String, Object> submitQuiz(@RequestParam("historySeq") int historySeq) {
        return quizService.submitQuiz(historySeq);
    }
}