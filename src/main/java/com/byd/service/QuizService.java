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
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class QuizService {

    private final QuizMapper quizMapper;
    private final QuizLiveMapper quizLiveMapper; // 라이브 세션 조회를 위해 연동

    private int getCurrentSessionNo() {
        int hour = LocalTime.now().getHour();
        if (hour < 12) return 1;
        if (hour < 14) return 2;
        if (hour < 16) return 3;
        return 4;
    }

    private String getTodayString() {
        return LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    // [신규 요건 1, 2 적용] step1 진입 전 참여 가능 여부 확인
    public Map<String, Object> checkEligibility(String name, String phone) {
        Map<String, Object> result = new HashMap<>();
        String today = getTodayString();
        int sessionNo = getCurrentSessionNo();

        // 1. 현재 라이브 세션이 열려있는지, 대기중(WAITING)인지 확인 (지각자 난입 차단)
        QuizLiveSessionVO liveSession = quizLiveMapper.getLiveSession(today, sessionNo);
        if (liveSession == null) {
            result.put("eligible", false);
            result.put("message", "현재 진행 예정인 퀴즈 세션이 없습니다.");
            return result;
        }
        if (!"WAITING".equals(liveSession.getStatus())) {
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
        int sessionNo = getCurrentSessionNo();

        // 1. 라이브 세션 정보 가져오기 (공통 문제 목록 추출용)
        QuizLiveSessionVO liveSession = quizLiveMapper.getLiveSession(today, sessionNo);
        if (liveSession == null || !"WAITING".equals(liveSession.getStatus())) {
            result.put("success", false);
            result.put("message", "퀴즈가 이미 진행 중이거나 준비되지 않았습니다.");
            return result;
        }

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
                // IN_PROGRESS (재접속자)
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
        newHistory.setUserAnswers("0,0,0,0,0,0,0,0,0,0"); // 10문제 빈 답안 세팅
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

        // 라이브 세션의 정답 가져오기
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        QuizLiveSessionVO liveSession = quizLiveMapper.getLiveSession(today, history.getSessionNo());
        if (liveSession == null) {
            result.put("success", false); result.put("message", "라이브 세션 오류."); return result;
        }

        List<String> qIds = Arrays.asList(liveSession.getAssignedQuestions().split(","));
        List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

        // 유저가 찍은 답안 (Auto-save로 저장된 "1,3,2,0..." 배열)
        String[] userAnswersArr = history.getUserAnswers().split(",");

        // 대조 및 채점
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