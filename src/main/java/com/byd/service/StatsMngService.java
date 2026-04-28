package com.byd.service;

import com.byd.mapper.StatsMngMapper;
import com.byd.vo.UserStatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class StatsMngService {
    private final StatsMngMapper statsMapper;

    public List<UserStatsVO> getRankingList() {
        List<UserStatsVO> list = statsMapper.selectWinRateRanking();

        // 승률 계산 (Java단에서 처리) 및 순위 매기기
        for (int i = 0; i < list.size(); i++) {
            UserStatsVO vo = list.get(i);
            vo.setRanking(i + 1);

            if (vo.getTotalGames() > 0) {
                double rate = (double) vo.getWinGames() / vo.getTotalGames() * 100.0;
                vo.setWinRate(Math.round(rate * 10) / 10.0); // 소수점 첫째자리 반올림
            } else {
                vo.setWinRate(0.0);
            }
        }
        return list;
    }

    // 대시보드 통계 조회용
    public int getDau() {
        return statsMapper.selectDau();
    }

    public int getMau() {
        return statsMapper.selectMau();
    }

    public double getTotalAvgWinRate() {
        return statsMapper.selectTotalAvgWinRate();
    }

    public double getAvgMonthlyDiaries(int mau) {
        if (mau == 0) return 0.0;
        return statsMapper.selectAvgMonthlyDiaries(mau);
    }

    public List<Map<String, Object>> getWeeklyAccessStats() {
        return statsMapper.selectWeeklyAccessStats();
    }

    // 회원 상태별 통계 반환
    public Map<String, Object> getMemberStatusStats() {
        return statsMapper.selectMemberStatusStats();
    }

    // 일기 상태별 통계 반환
    public Map<String, Object> getDiaryStatusStats() {
        return statsMapper.selectDiaryStatusStats();
    }

}