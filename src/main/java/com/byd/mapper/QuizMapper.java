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
    void insertUser(QuizUserVO user);

    void updateUser(QuizUserVO user);

    QuizUserVO getUserByNameAndPhone(@Param("name") String name, @Param("phone") String phone);

    QuizHistoryVO getTodayHistory(@Param("userSeq") int userSeq);

    void insertHistory(QuizHistoryVO history);

    void updateHistoryScoreAndStatus(QuizHistoryVO history);

    void updateGiftStatus(@Param("historySeq") int historySeq, @Param("giftReceivedYn") String giftReceivedYn);

    List<QuizQuestionVO> getRandomQuestions(@Param("limit") int limit);

    List<QuizQuestionVO> getQuestionsByIds(@Param("ids") List<String> ids);

    QuizHistoryVO getHistoryBySeq(@Param("historySeq") int historySeq);

    // 관리자 페이지 조회용
    List<QuizUserVO> getQuizAdminList(@Param("keyword") String keyword,
                                      @Param("perfectScoreOnly") String perfectScoreOnly,
                                      @Param("searchDate") String searchDate,
                                      @Param("searchSession") Integer searchSession);

    // --- 퀴즈 문제 관리용 ---
    List<QuizQuestionVO> getQuestionList();

    QuizQuestionVO getQuestionById(@Param("questionId") int questionId);

    void insertQuestion(QuizQuestionVO question);

    void updateQuestion(QuizQuestionVO question);

    void deleteQuestion(@Param("questionId") int questionId);

    void insertQuizVisit();

    List<DailyStatsVO> getQuizDailyVisitStats();

}