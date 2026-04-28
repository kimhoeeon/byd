package com.byd.mapper;

import com.byd.vo.UserStatsVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface StatsMngMapper {
    // 승률 랭킹 조회 (직관 수 많은 순 or 승률 높은 순)
    List<UserStatsVO> selectWinRateRanking();

    int selectDau();
    int selectMau();
    double selectTotalAvgWinRate();
    double selectAvgMonthlyDiaries(int mau);
    List<Map<String, Object>> selectWeeklyAccessStats();

    Map<String, Object> selectMemberStatusStats();

    Map<String, Object> selectDiaryStatusStats();
}