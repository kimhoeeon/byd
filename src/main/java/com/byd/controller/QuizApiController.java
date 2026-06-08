package com.byd.controller;

import com.byd.service.QuizService;
import com.byd.vo.QuizUserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/quiz")
@RequiredArgsConstructor
public class QuizApiController {

    private final QuizService quizService;

    // 개인정보 입력 후 퀴즈 시작 시 호출 (문제 10개 반환)
    @PostMapping("/start")
    public Map<String, Object> startQuiz(@RequestBody QuizUserVO userVO) {
        return quizService.startQuiz(userVO);
    }

    // 퀴즈 제출 및 채점 (프론트에서 답안 json을 던지면 채점 후 점수 반환)
    @PostMapping("/submit")
    public Map<String, Object> submitQuiz(@RequestParam("historySeq") int historySeq, @RequestBody Map<Integer, Integer> answers) {
        return quizService.submitQuiz(historySeq, answers);
    }
}