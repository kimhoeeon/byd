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

    // 1. 참가 가능 여부 검사 (이름 상관없이 '연락처' 기준으로만 엄격하게 중복 참여 방어)
    public Map<String, Object> checkEligibility(String name, String phone) {
        Map<String, Object> result = new HashMap<>();

        QuizUserVO user = quizMapper.getUserByPhone(phone);
        if (user != null) {
            QuizHistoryVO todayHistory = quizMapper.getTodayHistory(user.getUserSeq());
            if (todayHistory != null) {
                if ("COMPLETED".equals(todayHistory.getStatus())) {
                    result.put("eligible", false);
                    result.put("message", "오늘은 이미 해당 연락처로 퀴즈 이벤트에 참여하셨습니다.");
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

        // 1. 필수값 백엔드 검증 (데이터 누락 로깅)
        if (userVO == null || userVO.getPhone() == null || userVO.getPhone().trim().isEmpty()
                || userVO.getShopInfo() == null || userVO.getShopInfo().trim().isEmpty()) {

            String logName = (userVO != null && userVO.getName() != null) ? userVO.getName() : "이름없음";
            String logPhone = (userVO != null && userVO.getPhone() != null) ? userVO.getPhone() : "연락처없음";
            String logShop = (userVO != null && userVO.getShopInfo() != null) ? userVO.getShopInfo() : "전시장없음";
            String logEmail = (userVO != null && userVO.getEmail() != null) ? userVO.getEmail() : "이메일없음";

            log.warn("▶ [퀴즈 데이터 누락 발생] 이름: {}, 연락처: {}, 전시장: {}, 이메일: {}", logName, logPhone, logShop, logEmail);

            result.put("success", false);
            result.put("message", "필수 정보가 누락되었습니다. 정상적인 경로로 참여해 주세요.");
            return result;
        }

        // 정상 진입 시 모든 수집 데이터를 상세 로깅 (추후 민원/데이터 추적용)
        log.info("▷ [퀴즈 정상 유입 데이터] 이름: {}, 연락처: {}, 이메일: {}, 지역: {}, 전시장: {}, 관심차종코드: {}",
                userVO.getName(), userVO.getPhone(), userVO.getEmail(), userVO.getRegion(), userVO.getShopInfo(), userVO.getCarModelCode());

        String today = getTodayString();

        // 2. 기존 유저 여부와 상관없이 무조건 insertUser 실행 (ON DUPLICATE KEY UPDATE)
        quizMapper.insertUser(userVO);

        // 3. 업데이트 또는 신규 등록된 유저 정보를 다시 조회하여 확정
        QuizUserVO savedUser = quizMapper.getUserByPhone(userVO.getPhone());

        // savedUser가 null일 경우의 확실한 예외 처리(방어 로직)
        if (savedUser == null) {
            log.error("▶ [유저 조회 실패] DB 등록 후 유저 정보를 찾을 수 없습니다. 연락처: {}", userVO.getPhone());
            result.put("success", false);
            result.put("message", "사용자 정보 처리 중 일시적인 오류가 발생했습니다. 다시 시도해 주세요.");
            return result;
        }

        log.info("▷ [유저 정보 확정/업데이트 완료] 연락처: {}", savedUser.getPhone());

        // 4. 오늘 이미 생성된 이력이 있는지 확인 (재접속 방어)
        QuizHistoryVO todayHistory = quizMapper.getTodayHistory(savedUser.getUserSeq());
        if (todayHistory != null) {
            if ("COMPLETED".equals(todayHistory.getStatus())) {
                log.info("▷ [참가자 진입 차단] 유저(Seq:{})님은 이미 오늘 퀴즈를 완료했습니다.", savedUser.getUserSeq());
                result.put("success", false);
                result.put("message", "오늘은 이미 해당 연락처로 퀴즈 이벤트에 참여하셨습니다.");
                return result;
            } else {
                // 이전에 튕긴 유저: 본인에게 배정되어 있던 기존 문제 그대로 로드
                log.info("▷ [참가자 재입장 복구] 연락처: {} (기존 배정 문제 복원)", savedUser.getPhone());
                List<String> qIds = Arrays.asList(todayHistory.getAssignedQuestions().split(","));
                List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

                result.put("success", true);
                result.put("questions", questions);
                result.put("historySeq", todayHistory.getHistorySeq());
                result.put("userSeq", savedUser.getUserSeq());
                result.put("playDate", today);
                return result;
            }
        }

        // 5. 완전히 처음 참여하는 유저: 문제은행에서 무작위 1문제 추출
        List<Integer> randomIds = quizMapper.getRandomQuestionIds(1);
        if (randomIds == null || randomIds.isEmpty()) {
            result.put("success", false);
            result.put("message", "등록된 퀴즈 문제가 부족합니다. 관리자에게 문의해 주세요.");
            return result;
        }

        String assignedQuestionsStr = randomIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        // 6. 신규 이력 생성 (답안 초기값 0)
        QuizHistoryVO newHistory = new QuizHistoryVO();
        newHistory.setUserSeq(savedUser.getUserSeq());
        newHistory.setAssignedQuestions(assignedQuestionsStr);
        newHistory.setUserAnswers("0");
        quizMapper.insertHistory(newHistory);

        log.info("▷ [참가자 신규 시작] 연락처: {}, 배정된 문제: [{}]", savedUser.getPhone(), assignedQuestionsStr);

        List<String> qIds = randomIds.stream().map(String::valueOf).collect(Collectors.toList());
        List<QuizQuestionVO> questions = quizMapper.getQuestionsByIds(qIds);

        result.put("success", true);
        result.put("questions", questions);
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

        // 본인에게 배정되었던 문제를 로드
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