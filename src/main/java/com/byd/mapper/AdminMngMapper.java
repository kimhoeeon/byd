package com.byd.mapper;

import com.byd.vo.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminMngMapper {
    // 1. 관리자 로그인용 (admin 테이블 연동)
    AdminVO getAdminById(String adminId);

    // 2. 통합 목록 조회 (검색 및 페이징 적용)
    List<ParticipantVO> getList(Criteria cri);

    // 3. 엑셀 다운로드용 전체 목록 조회 (페이징 무시)
    List<ParticipantVO> getAllList(Criteria cri);

    // 4. 전체 데이터 개수 (페이징용)
    int getTotalCount(Criteria cri);

    // 5. 상세 조회
    ParticipantVO getParticipantBySeq(int seq);

    // 6. 대시보드 통계용
    int getTotalParticipantsCount();
    int getTodayParticipantsCount();
    int getTodayGiftsCount();
    int getTodayQuizCount();
    int getQuizPerfectCount();
    int getQuizFailCount();
    List<Map<String, Object>> getShopDistributionStats();
    List<Map<String, Object>> getHourlyCheckinStats();

    // 7. 참가자 개별 관리 (삭제 및 경품 수령 상태 토글 - qr_check_yn 컬럼 사용)
    void deleteParticipant(int seq);

    void updateGiftStatus(@Param("seq") int seq, @Param("status") String status);
}