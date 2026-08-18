package com.byd.mapper;

import com.byd.vo.DailyStatsVO;
import com.byd.vo.QuizHistoryVO;
import com.byd.vo.QuizQuestionVO;
import com.byd.vo.QuizUserVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface QuizMapper {

    // --- 1. 유저 정보 관련 ---
    void insertUser(QuizUserVO user);

    void updateUser(QuizUserVO user);

    QuizUserVO getUserByNameAndPhone(@Param("name") String name, @Param("phone") String phone);

    // --- 2. 퀴즈 진행 이력 관련 ---
    QuizHistoryVO getTodayHistory(@Param("userSeq") int userSeq);

    void insertHistory(QuizHistoryVO history);

    QuizHistoryVO getHistoryBySeq(@Param("historySeq") int historySeq);

    void updateHistoryScoreAndStatus(QuizHistoryVO history);

    void updateGiftStatus(@Param("historySeq") int historySeq, @Param("giftReceivedYn") String giftReceivedYn);

    List<Integer> getRandomQuestionIds(@Param("limit") int limit);

    List<QuizQuestionVO> getQuestionsByIds(@Param("ids") List<String> ids);

    void updateUserAnswers(@Param("historySeq") int historySeq, @Param("userAnswers") String userAnswers);

    // --- 3. 관리자 페이지용
    int getQuizAdminTotalCount(@Param("keyword") String keyword,
                               @Param("perfectScoreOnly") String perfectScoreOnly,
                               @Param("excludeInProgress") String excludeInProgress,
                               @Param("searchDate") String searchDate);

    // 관리자 페이지 50건 페이징 조회용
    List<QuizUserVO> getQuizAdminList(@Param("keyword") String keyword,
                                      @Param("perfectScoreOnly") String perfectScoreOnly,
                                      @Param("excludeInProgress") String excludeInProgress,
                                      @Param("searchDate") String searchDate,
                                      @Param("pageStart") int pageStart,
                                      @Param("amount") int amount);

    // 엑셀 다운로드 전체 조회용
    List<QuizUserVO> getQuizAdminListAll(@Param("keyword") String keyword,
                                         @Param("perfectScoreOnly") String perfectScoreOnly,
                                         @Param("excludeInProgress") String excludeInProgress,
                                         @Param("searchDate") String searchDate);

    // --- 4. 퀴즈 문제 관리용 ---
    List<QuizQuestionVO> getQuestionList();

    QuizQuestionVO getQuestionById(@Param("questionId") int questionId);

    void insertQuestion(QuizQuestionVO question);

    void updateQuestion(QuizQuestionVO question);

    void deleteQuestion(@Param("questionId") int questionId);

    // --- 5. 통계용 ---
    void insertQuizVisit();

    List<DailyStatsVO> getQuizDailyVisitStats();

}