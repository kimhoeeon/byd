package com.byd.service;

import com.byd.mapper.QuizLiveMapper;
import com.byd.mapper.QuizMapper;
import com.byd.vo.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class QuizService {

    private final QuizMapper quizMapper;
    private final QuizLiveMapper quizLiveMapper;

    private String getTodayString() {
        return LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public Map<String, Object> checkEligibility(String name, String phone) {
        Map<String, Object> result = new HashMap<>();
        String today = getTodayString();

        // 1. 가장 최근에 활성화된 오늘자 라이브 세션 조회
        QuizLiveSessionVO liveSession = quizLiveMapper.getLatestLiveSession(today);
        if (liveSession == null) {
            result.put("eligible", false);
            result.put("message", "현재 진행 예정인 퀴즈 세션이 없습니다.");
            return result;
        }

        // 기존 참여자인지 "먼저" 확인합니다!
        QuizUserVO user = quizMapper.getUserByNameAndPhone(name, phone);
        if (user != null) {
            QuizHistoryVO todayHistory = quizMapper.getTodayHistory(user.getUserSeq());
            if (todayHistory != null) {
                if ("COMPLETED".equals(todayHistory.getStatus())) {
                    result.put("eligible", false); result.put("message", "오늘은 이미 퀴즈 이벤트에 참여하셨습니다."); return result;
                } else {
                    // 튕겼다가 다시 들어온 사람 (IN_PROGRESS) -> 방 상태(READY) 무관하게 무사 통과!
                    result.put("eligible", true); return result;
                }
            }
        }

        // 기존 참여자가 아닌 신규 참여자라면? -> 방이 READY 상태일 때만 입장 허용 (지각생 난입 방지)
        if (!"READY".equals(liveSession.getStatus())) {
            result.put("eligible", false);
            result.put("message", "현재 퀴즈가 이미 진행 중이므로 참여할 수 없습니다.");
            return result;
        }

        result.put("eligible", true);
        return result;
    }

    @Transactional
    public Map<String, Object> startQuiz(QuizUserVO userVO) {
        Map<String, Object> result = new HashMap<>();
        String today = getTodayString();

        // 1. 가장 최근 활성화된 세션 조회
        QuizLiveSessionVO liveSession = quizLiveMapper.getLatestLiveSession(today);
        if (liveSession == null) {
            result.put("success", false);
            result.put("message", "진행 중인 세션이 없습니다.");
            return result;
        }

        int sessionNo = liveSession.getSessionNo();
        List<String> qIds = Arrays.asList(liveSession.getAssignedQuestions().split(","));
        List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

        // 2. 유저 정보 저장
        quizMapper.insertUser(userVO);
        QuizUserVO savedUser = quizMapper.getUserByNameAndPhone(userVO.getName(), userVO.getPhone());

        // 3. 오늘 이력 검증
        QuizHistoryVO todayHistory = quizMapper.getTodayHistory(savedUser.getUserSeq());
        if (todayHistory != null) {
            if ("COMPLETED".equals(todayHistory.getStatus())) {
                result.put("success", false);
                result.put("message", "오늘은 이미 퀴즈 이벤트에 참여하셨습니다.");
                return result;
            } else {
                // 재접속자 복귀 처리
                result.put("success", true);
                result.put("questions", sanitizeAnswers(questions));
                result.put("historySeq", todayHistory.getHistorySeq());
                result.put("userSeq", savedUser.getUserSeq());
                result.put("sessionNo", sessionNo);
                result.put("playDate", today);
                return result;
            }
        }

        // 신규 참여자일 경우 방 상태 검증
        if (!"READY".equals(liveSession.getStatus())) {
            result.put("success", false);
            result.put("message", "퀴즈가 이미 진행 중이므로 참여할 수 없습니다.");
            return result;
        }

        // 4. 신규 참여자 이력 생성 (userAnswers 초기화)
        QuizHistoryVO newHistory = new QuizHistoryVO();
        newHistory.setUserSeq(savedUser.getUserSeq());
        newHistory.setSessionNo(sessionNo);
        newHistory.setUserAnswers("0,0,0,0,0,0,0,0,0,0");
        quizMapper.insertHistory(newHistory);

        result.put("success", true);
        result.put("questions", sanitizeAnswers(questions));
        result.put("historySeq", newHistory.getHistorySeq());
        result.put("userSeq", savedUser.getUserSeq());
        result.put("sessionNo", sessionNo);
        result.put("playDate", today);
        return result;
    }

    // 채점 및 최종 제출 로직 (자동 저장된 답안을 바탕으로 채점)
    @Transactional
    public Map<String, Object> submitQuiz(int historySeq, Map<Integer, Integer> ignoredAnswers) {
        Map<String, Object> result = new HashMap<>();

        QuizHistoryVO history = quizMapper.getHistoryBySeq(historySeq);
        if (history == null) {
            result.put("success", false); result.put("message", "존재하지 않는 이력입니다."); return result;
        }
        if ("COMPLETED".equals(history.getStatus())) {
            result.put("success", false); result.put("message", "이미 채점된 퀴즈입니다."); return result;
        }

        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        QuizLiveSessionVO liveSession = quizLiveMapper.getLiveSession(today, history.getSessionNo());
        if (liveSession == null) {
            result.put("success", false); result.put("message", "라이브 세션 오류."); return result;
        }

        List<String> qIds = Arrays.asList(liveSession.getAssignedQuestions().split(","));
        List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

        String[] userAnswersArr = history.getUserAnswers().split(",");

        int calculatedScore = 0;
        for (int i = 0; i < questions.size(); i++) {
            QuizQuestionVO q = questions.get(i);
            int userAnswer = 0;
            if (i < userAnswersArr.length) {
                try { userAnswer = Integer.parseInt(userAnswersArr[i]); } catch(Exception e) {}
            }
            if (userAnswer != 0 && userAnswer == q.getCorrectAnswer()) {
                calculatedScore++;
            }
        }

        history.setScore(calculatedScore);
        history.setStatus("COMPLETED");
        quizMapper.updateHistoryScoreAndStatus(history);

        result.put("success", true);
        result.put("score", calculatedScore);
        return result;
    }

    // -------------------------------------------------------------------------
    // 관리자용 퀴즈 목록 조회 (날짜 및 회차 필터 추가)
    // -------------------------------------------------------------------------
    public int getQuizAdminTotalCount(String keyword, String perfectScoreOnly, String searchDate, Integer searchSession) {
        return quizMapper.getQuizAdminTotalCount(keyword, perfectScoreOnly, searchDate, searchSession);
    }

    public List<QuizUserVO> getQuizAdminList(String keyword, String perfectScoreOnly, String searchDate, Integer searchSession, Criteria cri) {
        return quizMapper.getQuizAdminList(keyword, perfectScoreOnly, searchDate, searchSession, cri.getPageStart(), cri.getAmount());
    }

    public List<QuizUserVO> getQuizAdminListAll(String keyword, String perfectScoreOnly, String searchDate, Integer searchSession) {
        return quizMapper.getQuizAdminListAll(keyword, perfectScoreOnly, searchDate, searchSession);
    }

    public void toggleGiftStatus(int historySeq, String status) {
        quizMapper.updateGiftStatus(historySeq, status);
    }

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
        if (question.getQuestionId() == 0) {
            quizMapper.insertQuestion(question);
        } else {
            quizMapper.updateQuestion(question);
        }
    }

    public void deleteQuestion(int questionId) {
        quizMapper.deleteQuestion(questionId);
    }

    @Transactional
    public void recordVisit() {
        quizMapper.insertQuizVisit();
    }

    public List<DailyStatsVO> getQuizDailyVisitStats() {
        return quizMapper.getQuizDailyVisitStats();
    }

}