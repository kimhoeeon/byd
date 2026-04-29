package com.byd.mapper;

import com.byd.vo.*;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AdminMngMapper {
    // 관리자 로그인용
    AdminVO getAdminById(String adminId);

    // 통합 목록 조회 (검색 및 페이징 적용)
    List<ParticipantVO> getList(Criteria cri);

    // 전체 데이터 개수 (페이징용)
    int getTotalCount(Criteria cri);

    // 상세 조회
    ParticipantVO getParticipantBySeq(int seq);

    // 대시보드 통계
    StatsVO getDashboardSummary();

    List<DailyStatsVO> getDailyStats();

    // 출석 상태 변경
    void updateArrivalStatus(int seq);

    void cancelArrivalStatus(int seq);

}