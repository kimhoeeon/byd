package com.byd.controller;

import com.byd.mapper.QuizMapper;
import com.byd.service.QuizLiveService;
import com.byd.vo.QuizLiveSessionVO;
import com.byd.vo.QuizQuestionVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Arrays;

@RestController
@RequestMapping("/api/quiz/live")
@RequiredArgsConstructor
public class QuizLiveApiController {

    private final QuizLiveService quizLiveService;
    private final QuizMapper quizMapper; // 정답 조회를 위해 추가됨

    // 1. [유저용 Polling API] 1초마다 휴대폰이 서버에 물어보는 현재 상태
    @GetMapping("/status")
    public Map<String, Object> getLiveStatus(@RequestParam("playDate") String playDate,
                                             @RequestParam("sessionNo") int sessionNo) {
        Map<String, Object> result = new HashMap<>();
        QuizLiveSessionVO session = quizLiveService.getCurrentLiveSession(playDate, sessionNo);

        if (session != null) {
            result.put("success", true);
            result.put("currentQuestionNo", session.getCurrentQuestionNo());
            result.put("status", session.getStatus());

            // MC가 "정답 공개"를 눌렀을 때만 정답 번호를 프론트엔드로 전송!
            if ("SHOW_ANSWER".equals(session.getStatus()) && session.getCurrentQuestionNo() > 0) {
                String[] qIds = session.getAssignedQuestions().split(",");
                if(session.getCurrentQuestionNo() <= qIds.length) {
                    int qId = Integer.parseInt(qIds[session.getCurrentQuestionNo() - 1]);
                    QuizQuestionVO q = quizMapper.getQuestionById(qId);
                    result.put("correctAnswer", q.getCorrectAnswer());
                }
            }
        } else {
            result.put("success", false);
            result.put("message", "진행 중인 퀴즈 세션이 없습니다.");
        }
        return result;
    }

    // 2. [유저용 Auto-Save API] 참가자가 보기를 터치할 때마다 즉시 저장
    @PostMapping("/auto-save")
    public Map<String, Object> autoSaveAnswer(@RequestParam("userSeq") int userSeq,
                                              @RequestParam("playDate") String playDate,
                                              @RequestParam("sessionNo") int sessionNo,
                                              @RequestParam("questionIndex") int questionIndex,
                                              @RequestParam("answerId") int answerId) {
        Map<String, Object> result = new HashMap<>();
        try {
            quizLiveService.saveUserAnswer(userSeq, playDate, sessionNo, questionIndex, answerId);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "답안 임시 저장에 실패했습니다.");
        }
        return result;
    }

    // 3. [MC용 API] 클리커 제어
    @PostMapping("/host/control")
    public Map<String, Object> hostControl(@RequestParam("playDate") String playDate,
                                           @RequestParam("sessionNo") int sessionNo,
                                           @RequestParam("targetQuestionNo") int targetQuestionNo,
                                           @RequestParam("targetStatus") String targetStatus) {
        Map<String, Object> result = new HashMap<>();
        try {
            quizLiveService.controlLiveSession(playDate, sessionNo, targetQuestionNo, targetStatus);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "세션 상태 변경 오류가 발생했습니다.");
        }
        return result;
    }

    // 4. [MC용 API] 퀴즈쇼 회차 최초 생성 및 시작
    @PostMapping("/host/start")
    public Map<String, Object> hostStart(@RequestParam("playDate") String playDate,
                                         @RequestParam("sessionNo") int sessionNo) {
        Map<String, Object> result = new HashMap<>();
        boolean isStarted = quizLiveService.startNewLiveSession(playDate, sessionNo);
        result.put("success", isStarted);
        if(!isStarted) {
            result.put("message", "이미 생성된 회차입니다. 문제가 있다면 초기화 후 다시 시도해 주세요.");
        }
        return result;
    }

    // 5. [MC용 API] 긴급 상황 시 회차 초기화
    @PostMapping("/host/reset")
    public Map<String, Object> hostReset(@RequestParam("playDate") String playDate,
                                         @RequestParam("sessionNo") int sessionNo) {
        Map<String, Object> result = new HashMap<>();
        try {
            quizLiveService.resetLiveSession(playDate, sessionNo);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    // 6. [MC용 API] 해당 회차 전체 문제 조회
    @GetMapping("/host/questions")
    public Map<String, Object> getHostQuestions(@RequestParam("playDate") String playDate,
                                                @RequestParam("sessionNo") int sessionNo) {
        Map<String, Object> result = new HashMap<>();
        QuizLiveSessionVO session = quizLiveService.getCurrentLiveSession(playDate, sessionNo);

        if (session != null && session.getAssignedQuestions() != null) {
            List<String> qIds = Arrays.asList(session.getAssignedQuestions().split(","));
            List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);
            result.put("success", true);
            result.put("questions", questions);
        } else {
            result.put("success", false);
        }
        return result;
    }
}