package com.byd.service;

import com.byd.mapper.QuizLiveMapper;
import com.byd.mapper.QuizMapper;
import com.byd.vo.QuizHistoryVO;
import com.byd.vo.QuizLiveSessionVO;
import com.byd.vo.QuizQuestionVO;
import com.byd.vo.QuizUserVO;
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

        // READY 상태일 때만 입장을 허용
        if (!"READY".equals(liveSession.getStatus())) {
            result.put("eligible", false);
            result.put("message", "현재 퀴즈가 이미 진행 중이므로 참여할 수 없습니다.");
            return result;
        }

        // 2. 오늘 이미 다 푼 기록이 있는지 확인
        QuizUserVO user = quizMapper.getUserByNameAndPhone(name, phone);
        if (user != null) {
            QuizHistoryVO todayHistory = quizMapper.getTodayHistory(user.getUserSeq());
            if (todayHistory != null && "COMPLETED".equals(todayHistory.getStatus())) {
                result.put("eligible", false);
                result.put("message", "오늘은 이미 퀴즈 이벤트에 참여하셨습니다.\n내일 다시 도전해 주세요!");
                return result;
            }
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

        // READY 상태일 때만 퀴즈 시작(입장) 허용
        if (liveSession == null || !"READY".equals(liveSession.getStatus())) {
            result.put("success", false);
            result.put("message", "퀴즈가 이미 진행 중이거나 준비되지 않았습니다.");
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
                result.put("success", true);
                result.put("questions", sanitizeAnswers(questions));
                result.put("historySeq", todayHistory.getHistorySeq());
                result.put("userSeq", savedUser.getUserSeq());
                result.put("sessionNo", sessionNo);
                result.put("playDate", today);
                return result;
            }
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
    public List<QuizUserVO> getQuizAdminList(String keyword, String perfectScoreOnly, String searchDate, Integer searchSession) {
        return quizMapper.getQuizAdminList(keyword, perfectScoreOnly, searchDate, searchSession);
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
}