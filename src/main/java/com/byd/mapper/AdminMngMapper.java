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

    List<ParticipantVO> getParticipantList();

    // 대시보드 상단 요약 데이터
    StatsVO getDashboardSummary();

    // 최근 7일 일별 신청 통계 데이터
    List<DailyStatsVO> getDailyStats();

    List<ParticipantVO> getParticipantListByType(String entryType);

    void updateQrScanTime(int seq);

    ParticipantVO getParticipantBySeq(int seq);
}