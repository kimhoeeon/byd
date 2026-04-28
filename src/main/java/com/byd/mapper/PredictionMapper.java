package com.byd.mapper;

import com.byd.vo.PredictionVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface PredictionMapper {
    int savePrediction(@Param("memberId") Long memberId, @Param("gameId") Long gameId, @Param("predictedTeam") String predictedTeam);

    List<PredictionVO> selectMyPredictionHistory(Long memberId);

    PredictionVO selectMyPredictionByGameId(@Param("memberId") Long memberId, @Param("gameId") Long gameId);

    Map<String, Object> selectPredictionStats(Long memberId);

    List<PredictionVO> selectPredictionsByGameId(Long gameId);

    int updatePredictionResult(@Param("predictionId") Long predictionId, @Param("isCorrect") Boolean isCorrect);

    void updateAlarmSent(Long predictionId);

    // 특정 회원의 전체 승부 예측 내역 조회
    List<PredictionVO> selectPredictionsByMember(Long memberId);

    // 특정 회원의 특정 경기 승부 예측 단건 조회
    PredictionVO selectPredictionByMemberAndGame(@Param("memberId") Long memberId, @Param("gameId") Long gameId);
}