package com.byd.service;

import com.byd.config.MaintenanceInterceptor;
import com.byd.mapper.SystemMngMapper;
import com.byd.vo.AppVersionVO;
import com.byd.vo.NoticeVO;
import com.byd.vo.TermsVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class SystemMngService {

    private final SystemMngMapper systemMngMapper;

    // ==========================================
    // 1. 앱 버전 관리 (App Version)
    // ==========================================

    /**
     * OS별 최신 버전 정보 조회 (사용자 앱 체크용)
     */
    public AppVersionVO getLatestVersion(String osType) {
        return systemMngMapper.selectLatestVersion(osType);
    }

    /**
     * 버전 목록 조회 (관리자용)
     */
    public List<AppVersionVO> getAppVersionList() {
        return systemMngMapper.selectAppVersionList();
    }

    /**
     * 버전 등록
     */
    @Transactional
    public void registerAppVersion(AppVersionVO vo) {
        systemMngMapper.insertAppVersion(vo);
    }

    /**
     * 버전 삭제
     */
    @Transactional
    public void removeAppVersion(Long versionId) {
        systemMngMapper.deleteAppVersion(versionId);
    }


    // ==========================================
    // 2. 공지사항 관리 (Notice)
    // ==========================================
    public List<NoticeVO> getNoticeList() {
        return systemMngMapper.selectNoticeList();
    }

    // 사용자용 공지 목록
    public List<NoticeVO> getActiveNoticeList() {
        return systemMngMapper.selectActiveNoticeList();
    }

    public NoticeVO getNoticeById(Long noticeId) {
        return systemMngMapper.selectNoticeById(noticeId);
    }

    @Transactional
    public void registerNotice(NoticeVO notice) {
        systemMngMapper.insertNotice(notice);
    }

    @Transactional
    public void updateNotice(NoticeVO notice) {
        // [중요] 체크박스 해제 시 null로 들어오므로 'N'으로 변경
        if (notice.getIsTop() == null || notice.getIsTop().isEmpty()) {
            notice.setIsTop("N");
        }
        systemMngMapper.updateNotice(notice);
    }

    @Transactional
    public void deleteNotice(Long noticeId) {
        systemMngMapper.deleteNotice(noticeId);
    }

    @Transactional
    public void increaseNoticeViewCount(Long noticeId) {
        systemMngMapper.updateNoticeViewCount(noticeId);
    }

    // ==========================================
    // 3. 약관 관리 (Terms)
    // ==========================================
    public List<TermsVO> getTermsList() {
        return systemMngMapper.selectTermsList();
    }

    public TermsVO getTermsById(Long termId) {
        return systemMngMapper.selectTermsById(termId);
    }

    public TermsVO getLatestTermsByType(String type) {
        return systemMngMapper.selectLatestTermByType(type);
    }

    @Transactional
    public void registerTerms(TermsVO terms) {
        systemMngMapper.insertTerms(terms);
    }

    @Transactional
    public void updateTerms(TermsVO terms) {
        systemMngMapper.updateTerms(terms);
    }

    @Transactional
    public void deleteTerms(Long termId) {
        systemMngMapper.deleteTerms(termId);
    }

    // ==========================================
    // 서버 부팅 시 점검 모드 상태 로드
    // ==========================================
    @PostConstruct
    public void initMaintenanceMode() {
        try {
            String status = systemMngMapper.selectMaintenanceMode();
            if (status != null) {
                // DB 값이 'Y'이면 true, 아니면 false로 메모리에 세팅
                MaintenanceInterceptor.isMaintenanceMode = "Y".equals(status);
                log.info("✅ 서버 부팅 완료: 현재 사이트 점검 모드 = {}", MaintenanceInterceptor.isMaintenanceMode);
            }
        } catch (Exception e) {
            log.warn("점검 모드 초기화 실패 (DB 테이블 확인 필요): {}", e.getMessage());
        }
    }

    // 관리자가 점검 모드를 켜고 끌 때 호출할 메서드
    @Transactional
    public void setMaintenanceMode(boolean isLock) {
        String status = isLock ? "Y" : "N";
        systemMngMapper.updateMaintenanceMode(status);     // 1. DB 업데이트 (영구 저장)
        MaintenanceInterceptor.isMaintenanceMode = isLock; // 2. 메모리 즉시 반영 (재부팅 없이 바로 적용)
    }
    
}