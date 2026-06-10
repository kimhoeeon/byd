package com.byd.mapper;

import com.byd.vo.QuizLiveSessionVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface QuizLiveMapper {
    // 1. 현재 라이브 세션 상태 조회
    QuizLiveSessionVO getLiveSession(@Param("playDate") String playDate, @Param("sessionNo") int sessionNo);

    // 2. 신규 라이브 세션 생성 (MC용)
    void insertLiveSession(QuizLiveSessionVO vo);

    // 3. 라이브 세션 상태 업데이트 (MC 클리커 제어용)
    void updateLiveSession(QuizLiveSessionVO vo);

    // 4. 라이브 세션 초기화 (사고 발생 시 재시작용)
    void deleteLiveSession(@Param("playDate") String playDate, @Param("sessionNo") int sessionNo);

    // 4-1. 라이브 세션 초기화 시 기존 테스트 접속자 이력(quiz_history)도 싹 다 지우기
    void deleteHistoryBySession(@Param("playDate") String playDate, @Param("sessionNo") int sessionNo);

    // 5. 랜덤 문제 10개 추출 (문제 ID 목록)
    List<Integer> getRandomQuestionIds(@Param("limit") int limit);

    // 6. 참가자 답안 실시간 저장 (Auto-save)
    void updateUserAnswers(@Param("userSeq") int userSeq, @Param("playDate") String playDate, @Param("sessionNo") int sessionNo, @Param("userAnswers") String userAnswers);

    // 7. 유저의 현재 히스토리 조회
    String getUserAnswers(@Param("userSeq") int userSeq, @Param("playDate") String playDate, @Param("sessionNo") int sessionNo);

    // 8. 특정 일자/회차의 현재 입장 완료 참가자 수 조회
    int getParticipantCount(@Param("playDate") String playDate, @Param("sessionNo") int sessionNo);
}