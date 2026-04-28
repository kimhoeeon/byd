package com.byd.mapper;

import com.byd.vo.AdminVO;
import com.byd.vo.DailyStatsVO;
import com.byd.vo.ParticipantVO;
import com.byd.vo.StatsVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AdminMngMapper {
    AdminVO getAdminById(String adminId);

    // 통합 목록 및 상세 조회
    List<ParticipantVO> getAllParticipantList();

    ParticipantVO getParticipantBySeq(int seq);

    void updateQrScanTime(int seq);

    // 대시보드 통계
    StatsVO getDashboardSummary();

    List<DailyStatsVO> getDailyStats();
}