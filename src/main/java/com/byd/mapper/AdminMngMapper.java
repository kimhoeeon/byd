package com.byd.mapper;

import com.byd.vo.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminMngMapper {
    // 관리자 로그인용
    AdminVO getAdminById(String adminId);

    // 통합 목록 조회 (검색 및 페이징 적용)
    List<ParticipantVO> getList(Criteria cri);

    // 엑셀 다운로드용 전체 목록 조회 (페이징 무시)
    List<ParticipantVO> getAllList(Criteria cri);

    // 전체 데이터 개수 (페이징용)
    int getTotalCount(Criteria cri);

    // 상세 조회
    ParticipantVO getParticipantBySeq(int seq);

    // QR 토큰으로 조회
    ParticipantVO getParticipantByQrCodeUrl(String qrCodeUrl);

    // 대시보드 통계
    StatsVO getDashboardSummary();

    List<DailyStatsVO> getDailyStats();

    // 출석 상태 변경 (관리자 코드 101: 챌린지, 202: 시승)
    void updateArrivalStatus(@Param("seq") int seq, @Param("adminCode") String adminCode);

    // 출석 상태 취소 (토글 OFF)
    void cancelArrivalStatus(@Param("seq") int seq, @Param("columnName") String columnName);

    List<Map<String, Object>> getCarModelStats();

    List<Map<String, Object>> getTimeStats();

    List<Map<String, Object>> getShopStats();

    Map<String, Object> getAttendanceStats();

    void deleteParticipant(int seq);
}