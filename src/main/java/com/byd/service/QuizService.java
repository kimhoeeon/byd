// QuizService.java
package com.byd.service;

import com.byd.mapper.QuizMapper;
import com.byd.vo.QuizHistoryVO;
import com.byd.vo.QuizQuestionVO;
import com.byd.vo.QuizUserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuizService {

    private final QuizMapper quizMapper;

    // 현재 시스템 시간 기준 회차 산정 로직 (현장 상황에 맞게 시간 조율 가능)
    private int getCurrentSessionNo() {
        int hour = LocalTime.now().getHour();
        if (hour < 12) return 1;
        if (hour < 14) return 2;
        if (hour < 16) return 3;
        return 4;
    }

    @Transactional
    public Map<String, Object> startQuiz(QuizUserVO userVO) {
        Map<String, Object> result = new HashMap<>();

        // 1. 유저 정보 저장 및 업데이트
        quizMapper.insertUser(userVO);
        QuizUserVO savedUser = quizMapper.getUserByNameAndPhone(userVO.getName(), userVO.getPhone());

        // 2. 오늘 이력 검증 (같은 날 재참여 불가)
        QuizHistoryVO todayHistory = quizMapper.getTodayHistory(savedUser.getUserSeq());
        if (todayHistory != null) {
            if ("COMPLETED".equals(todayHistory.getStatus())) {
                result.put("success", false);
                result.put("message", "오늘은 이미 퀴즈 이벤트에 참여하셨습니다. 내일 다시 도전해 주세요!");
                return result;
            } else {
                // IN_PROGRESS 인 경우: 창을 닫았다가 다시 연 경우 동일한 문제 지급
                List<String> qIds = Arrays.asList(todayHistory.getAssignedQuestions().split(","));
                List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);
                result.put("success", true);
                result.put("questions", sanitizeAnswers(questions));
                result.put("historySeq", todayHistory.getHistorySeq());
                return result;
            }
        }

        // 3. 신규 참여 (이력 생성 및 10문제 랜덤 출제)
        int sessionNo = getCurrentSessionNo();
        List<QuizQuestionVO> randomQuestions = quizMapper.getRandomQuestions(10);
        String qIdString = randomQuestions.stream()
                .map(q -> String.valueOf(q.getQuestionId()))
                .collect(Collectors.joining(","));

        QuizHistoryVO newHistory = new QuizHistoryVO();
        newHistory.setUserSeq(savedUser.getUserSeq());
        newHistory.setSessionNo(sessionNo);
        newHistory.setAssignedQuestions(qIdString);
        quizMapper.insertHistory(newHistory);

        result.put("success", true);
        result.put("questions", sanitizeAnswers(randomQuestions));
        result.put("historySeq", newHistory.getHistorySeq());
        return result;
    }

    @Transactional
    public Map<String, Object> submitQuiz(int historySeq, Map<Integer, Integer> userAnswers) {
        Map<String, Object> result = new HashMap<>();

        // 1. 해당 퀴즈 참여 이력 조회 및 유효성 검증
        QuizHistoryVO history = quizMapper.getHistoryBySeq(historySeq);
        if (history == null) {
            result.put("success", false);
            result.put("message", "존재하지 않는 참여 이력입니다. 비정상적인 접근입니다.");
            return result;
        }

        // 2. 이미 제출된 이력인지 이중 방어 (새로고침 / 중복 제출 / 어뷰징 차단)
        if ("COMPLETED".equals(history.getStatus())) {
            result.put("success", false);
            result.put("message", "이미 채점이 완료되어 제출된 퀴즈입니다.");
            return result;
        }

        // 3. DB에 기록된 '해당 유저에게 실제 출제되었던 문제 번호' 목록 불러오기
        List<String> qIds = Arrays.asList(history.getAssignedQuestions().split(","));

        // 4. 출제되었던 문제의 실제 데이터(정답 포함)를 DB에서 모두 조회
        List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

        // 5. 실제 정답 대조 및 채점 진행
        int calculatedScore = 0;
        for (QuizQuestionVO q : questions) {
            int qId = q.getQuestionId();

            // 프론트엔드에서 넘어온 유저의 답안 추출 (문제 번호 매칭)
            Integer userAnswer = userAnswers.get(qId);

            // Controller에서 JSON 변환 시 Key가 String으로 파싱되었을 경우를 대비한 2차 방어 추출
            if (userAnswer == null) {
                Object fallbackAnswer = ((Map<?, ?>) userAnswers).get(String.valueOf(qId));
                if (fallbackAnswer instanceof Integer) {
                    userAnswer = (Integer) fallbackAnswer;
                } else if (fallbackAnswer instanceof String) {
                    userAnswer = Integer.parseInt((String) fallbackAnswer);
                }
            }

            // 제출한 답안이 존재하고, DB의 실제 정답과 일치한다면 점수 증가
            if (userAnswer != null && userAnswer == q.getCorrectAnswer()) {
                calculatedScore++;
            }
        }

        // 6. 최종 점수 산출 완료 -> 상태를 완료(COMPLETED)로 변경 후 DB 업데이트
        history.setScore(calculatedScore);
        history.setStatus("COMPLETED");
        quizMapper.updateHistoryScoreAndStatus(history);

        // 7. 채점 결과 프론트엔드에 반환
        result.put("success", true);
        result.put("score", calculatedScore); // 10점 만점 시 프론트엔드에서 축하 팝업 분기 처리

        return result;
    }

    public List<QuizUserVO> getQuizAdminList(String keyword, String perfectScoreOnly) {
        return quizMapper.getQuizAdminList(keyword, perfectScoreOnly);
    }

    public void toggleGiftStatus(int historySeq, String status) {
        quizMapper.updateGiftStatus(historySeq, status);
    }

    // 프론트엔드로 정답이 유출되지 않게 클렌징하는 함수
    private List<QuizQuestionVO> sanitizeAnswers(List<QuizQuestionVO> list) {
        for (QuizQuestionVO q : list) {
            q.setCorrectAnswer(0);
        }
        return list;
    }

    public List<QuizQuestionVO> getQuestionList() {
        return quizMapper.getQuestionList();
    }

    public QuizQuestionVO getQuestionById(int questionId) {
        return quizMapper.getQuestionById(questionId);
    }

    @Transactional
    public void saveQuestion(QuizQuestionVO question) {
        if (question.getQuestionId() > 0) {
            quizMapper.updateQuestion(question);
        } else {
            quizMapper.insertQuestion(question);
        }
    }

    @Transactional
    public void deleteQuestion(int questionId) {
        quizMapper.deleteQuestion(questionId);
    }

}