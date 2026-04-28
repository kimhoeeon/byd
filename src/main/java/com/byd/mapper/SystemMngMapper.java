package com.byd.mapper;

import com.byd.vo.AppVersionVO;
import com.byd.vo.NoticeVO;
import com.byd.vo.TermsVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SystemMngMapper {

    // ==========================================
    // 1. 공지사항 관리 (Notices)
    // ==========================================

    // 공지사항 목록 조회
    List<NoticeVO> selectNoticeList();       // 관리자용
    List<NoticeVO> selectActiveNoticeList(); // 사용자용

    // 공지사항 상세 조회
    NoticeVO selectNoticeById(Long noticeId);

    // 공지사항 등록
    void insertNotice(NoticeVO notice);

    // 공지사항 수정
    void updateNotice(NoticeVO notice);

    // 공지사항 삭제
    void deleteNotice(Long noticeId);

    void updateNoticeViewCount(Long noticeId);

    // ==========================================
    // 2. 앱 버전 관리 (App Versions)
    // ==========================================

    // 앱 버전 목록 조회
    List<AppVersionVO> selectAppVersionList();

    // 앱 버전 등록
    void insertAppVersion(AppVersionVO vo);

    // 앱 버전 삭제
    void deleteAppVersion(Long versionId);

    AppVersionVO selectLatestVersion(@Param("osType") String osType);

    // ==========================================
    // 3. 약관/정책 관리 (Terms)
    // ==========================================

    // 약관 목록 조회 (관리자용)
    List<TermsVO> selectTermsList();

    // 약관 상세 조회 (관리자용)
    TermsVO selectTermsById(Long termId);

    // 특정 타입의 최신 약관 조회 (사용자 페이지 연동용)
    // type: SERVICE(이용약관), PRIVACY(개인정보), LOCATION(위치정보)
    TermsVO selectLatestTermByType(String type);

    // 약관 등록
    void insertTerms(TermsVO vo);

    // 약관 수정
    void updateTerms(TermsVO vo);

    // 약관 삭제
    void deleteTerms(Long termId);

    // 점검 모드 상태 조회 및 업데이트
    String selectMaintenanceMode();
    
    void updateMaintenanceMode(@Param("status") String status);
    
}