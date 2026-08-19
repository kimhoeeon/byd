package com.byd.service;

import com.byd.mapper.QuizMapper;
import com.byd.vo.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class QuizService {

    private final QuizMapper quizMapper;

    private String getTodayString() {
        return LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    // 1. 참가 가능 여부 검사 (중복 참여 방어)
    public Map<String, Object> checkEligibility(String name, String phone) {
        Map<String, Object> result = new HashMap<>();

        QuizUserVO user = quizMapper.getUserByNameAndPhone(name, phone);
        if (user != null) {
            QuizHistoryVO todayHistory = quizMapper.getTodayHistory(user.getUserSeq());
            if (todayHistory != null) {
                if ("COMPLETED".equals(todayHistory.getStatus())) {
                    result.put("eligible", false);
                    result.put("message", "오늘은 이미 퀴즈 이벤트에 참여하셨습니다.");
                    return result;
                } else {
                    // 중간에 튕겼거나 진행 중인 유저는 이어서 진행 가능
                    result.put("eligible", true);
                    return result;
                }
            }
        }

        // 누구나 언제든 참여 가능
        result.put("eligible", true);
        return result;
    }

    // 2. 퀴즈 시작 및 개인별 랜덤 문제 배정
    @Transactional
    public Map<String, Object> startQuiz(QuizUserVO userVO) {
        Map<String, Object> result = new HashMap<>();

        if (userVO == null || userVO.getName() == null || userVO.getName().trim().isEmpty()
                || userVO.getPhone() == null || userVO.getPhone().trim().isEmpty()) {
            log.warn("▶ [입장 거부] 필수 정보(이름, 연락처) 누락 접근 시도");
            result.put("success", false);
            result.put("message", "이름 또는 연락처 정보가 누락되었습니다. 정상적인 경로로 참여해 주세요.");
            return result;
        }

        String today = getTodayString();

        // 유저 정보 등록 또는 업데이트
        quizMapper.insertUser(userVO);
        QuizUserVO savedUser = quizMapper.getUserByNameAndPhone(userVO.getName(), userVO.getPhone());

        // 오늘 이미 생성된 이력이 있는지 확인 (재접속 방어)
        QuizHistoryVO todayHistory = quizMapper.getTodayHistory(savedUser.getUserSeq());
        if (todayHistory != null) {
            if ("COMPLETED".equals(todayHistory.getStatus())) {
                log.info("▷ [참가자 진입 차단] 유저(Seq:{})님은 이미 오늘 퀴즈를 완료했습니다.", savedUser.getUserSeq());
                result.put("success", false);
                result.put("message", "오늘은 이미 퀴즈 이벤트에 참여하셨습니다.");
                return result;
            } else {
                // 이전에 튕긴 유저: 본인에게 배정되어 있던 기존 문제 1개 그대로 로드
                log.info("▷ [참가자 재입장 복구] 이름: {}, 연락처: {} (기존 배정 문제 복원)", savedUser.getName(), savedUser.getPhone());
                List<String> qIds = Arrays.asList(todayHistory.getAssignedQuestions().split(","));
                List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

                result.put("success", true);
                result.put("questions", sanitizeAnswers(questions)); // 클라이언트에 정답 유출 방지
                result.put("historySeq", todayHistory.getHistorySeq());
                result.put("userSeq", savedUser.getUserSeq());
                result.put("playDate", today);
                return result;
            }
        }

        // 완전히 처음 참여하는 신규 유저: 문제은행에서 무작위 1문제 추출
        List<Integer> randomIds = quizMapper.getRandomQuestionIds(1);
        if (randomIds == null || randomIds.isEmpty()) {
            result.put("success", false);
            result.put("message", "등록된 퀴즈 문제가 부족합니다. 관리자에게 문의해 주세요.");
            return result;
        }

        String assignedQuestionsStr = randomIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        // 신규 이력 생성 (답안 초기값 0 1개)
        QuizHistoryVO newHistory = new QuizHistoryVO();
        newHistory.setUserSeq(savedUser.getUserSeq());
        newHistory.setAssignedQuestions(assignedQuestionsStr);
        newHistory.setUserAnswers("0");
        quizMapper.insertHistory(newHistory);

        log.info("▷ [참가자 신규 시작] 이름: {}, 연락처: {}, 배정된 문제: [{}]", savedUser.getName(), savedUser.getPhone(), assignedQuestionsStr);

        List<String> qIds = randomIds.stream().map(String::valueOf).collect(Collectors.toList());
        List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

        result.put("success", true);
        result.put("questions", sanitizeAnswers(questions));
        result.put("historySeq", newHistory.getHistorySeq());
        result.put("userSeq", savedUser.getUserSeq());
        result.put("playDate", today);
        return result;
    }

    // 3. 실시간 개별 답안 임시 저장 (Auto-Save)
    @Transactional
    public void saveUserAnswer(int historySeq, int questionIndex, int answerId) {
        QuizHistoryVO history = quizMapper.getHistoryBySeq(historySeq);
        if (history == null || "COMPLETED".equals(history.getStatus())) {
            return;
        }

        // 1문항이므로 무조건 첫 번째 배열값 업데이트
        quizMapper.updateUserAnswers(historySeq, String.valueOf(answerId));
        log.info("▷ [임시 저장] 이력번호(Seq:{}) - '{}'번 보기 선택 완료", historySeq, answerId);
    }

    // 4. 최종 개별 채점 및 제출 처리
    @Transactional
    public Map<String, Object> submitQuiz(int historySeq) {
        Map<String, Object> result = new HashMap<>();

        QuizHistoryVO history = quizMapper.getHistoryBySeq(historySeq);
        if (history == null) {
            result.put("success", false);
            result.put("message", "존재하지 않는 참여 이력입니다.");
            return result;
        }
        if ("COMPLETED".equals(history.getStatus())) {
            result.put("success", false);
            result.put("message", "이미 제출 처리가 완료된 퀴즈입니다.");
            return result;
        }

        // 본인에게 배정되었던 1문제를 로드
        List<String> qIds = Arrays.asList(history.getAssignedQuestions().split(","));
        List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);
        String userAnswerStr = history.getUserAnswers();

        int calculatedScore = 0;
        if (!questions.isEmpty()) {
            QuizQuestionVO q = questions.get(0);
            int userAnswer = 0;
            try {
                userAnswer = Integer.parseInt(userAnswerStr);
            } catch (Exception e) {}

            if (userAnswer != 0 && userAnswer == q.getCorrectAnswer()) {
                calculatedScore = 1; // 1점 만점
            }
        }

        history.setScore(calculatedScore);
        history.setStatus("COMPLETED");
        quizMapper.updateHistoryScoreAndStatus(history);

        log.info("★ [최종 채점 완료] 이력번호(Seq:{}) - 획득 점수: {}점", historySeq, calculatedScore);

        result.put("success", true);
        result.put("score", calculatedScore);
        return result;
    }

    // -------------------------------------------------------------------------
    // 관리자용 퀴즈 목록 조회 (날짜 및 회차 필터 추가)
    // -------------------------------------------------------------------------
    public int getQuizAdminTotalCount(String keyword, String perfectScoreOnly, String excludeInProgress, String searchDate) {
        return quizMapper.getQuizAdminTotalCount(keyword, perfectScoreOnly, excludeInProgress, searchDate);
    }

    public List<QuizUserVO> getQuizAdminList(String keyword, String perfectScoreOnly, String excludeInProgress, String searchDate, Criteria cri) {
        return quizMapper.getQuizAdminList(keyword, perfectScoreOnly, excludeInProgress, searchDate, cri.getPageStart(), cri.getAmount());
    }

    public List<QuizUserVO> getQuizAdminListAll(String keyword, String perfectScoreOnly, String excludeInProgress, String searchDate) {
        return quizMapper.getQuizAdminListAll(keyword, perfectScoreOnly, excludeInProgress, searchDate);
    }

    public void toggleGiftStatus(int historySeq, String status) {
        quizMapper.updateGiftStatus(historySeq, status);
    }

    private List<QuizQuestionVO> sanitizeAnswers(List<QuizQuestionVO> list) {
        for (QuizQuestionVO q : list) {
            q.setCorrectAnswer(0); // 프론트엔드 단 전송 전 정답 필드 마스킹 (보안)
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