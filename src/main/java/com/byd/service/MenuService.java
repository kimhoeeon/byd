package com.byd.service;

import com.byd.dto.MenuItem;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MenuService {

    /**
     * 관리자 페이지용 메뉴 목록 생성
     */
    public List<MenuItem> getAdminMenuItems() {
        List<MenuItem> menus = new ArrayList<>();

        // 1. 대시보드
        menus.add(new MenuItem("대시보드", "/mng/main.do", "ki-element-11", 4));

        // 2. 운영 관리 (그룹)
        List<MenuItem> subOps = new ArrayList<>();
        subOps.add(new MenuItem("경기 데이터 관리", "/mng/game/syncPage", "", 0));
        subOps.add(new MenuItem("승요 멘트 관리", "/mng/winyo/mentions", "", 0));
        menus.add(new MenuItem("운영 관리", "#", "ki-gear", 2, subOps));

        // 3. 회원 관리 (그룹)
        List<MenuItem> subMem = new ArrayList<>();
        subMem.add(new MenuItem("회원 목록", "/mng/members/list", "", 0));
        menus.add(new MenuItem("회원 관리", "#", "ki-user", 2, subMem));

        // 4. 일기 관리 (그룹)
        List<MenuItem> subDiary = new ArrayList<>();
        subDiary.add(new MenuItem("전체 일기 목록", "/mng/diary/list", "", 0));
        subDiary.add(new MenuItem("전체 댓글 목록", "/mng/comment/list", "", 0));
        menus.add(new MenuItem("일기 관리", "#", "ki-book-open", 2, subDiary));

        // 5. 콘텐츠 관리 (그룹)
        List<MenuItem> subContent = new ArrayList<>();
        subContent.add(new MenuItem("이벤트 관리", "/mng/content/events", "", 0));
        subContent.add(new MenuItem("구단 콘텐츠 관리", "/mng/content/teams", "", 0));
        subContent.add(new MenuItem("구단 정보 관리", "/mng/content/team-info/list", "", 0));
        menus.add(new MenuItem("콘텐츠 관리", "#", "ki-folder", 2, subContent));

        // 7. 통계 관리 (그룹)
        List<MenuItem> subStats = new ArrayList<>();
        subStats.add(new MenuItem("직관 승률 랭킹", "/mng/stats/ranking", "", 0));
        menus.add(new MenuItem("통계 관리", "#", "ki-chart-line-up", 2, subStats));

        // 6. 고객센터 관리 (그룹)
        //List<MenuItem> subSupport = new ArrayList<>();
        //subSupport.add(new MenuItem("FAQ 관리", "/mng/support/faq/list", "", 0));
        //subSupport.add(new MenuItem("1:1 문의 관리", "/mng/support/inquiry/list", "", 0));
        //menus.add(new MenuItem("고객센터", "#", "ki-question", 2, subSupport));

        // 7. 시스템 관리 (그룹)
        List<MenuItem> subSys = new ArrayList<>();
        subSys.add(new MenuItem("공지사항 관리", "/mng/system/notices", "", 0));
        subSys.add(new MenuItem("앱 버전 관리", "/mng/system/versions", "", 0));
        subSys.add(new MenuItem("약관/정책 관리", "/mng/system/terms", "", 0));
        subSys.add(new MenuItem("푸시 알림 발송", "/mng/system/push/list", "", 0));
        menus.add(new MenuItem("시스템 관리", "#", "ki-setting-2", 2, subSys));

        // 8. 개발사 (그룹) - 신규
        List<MenuItem> subDev = new ArrayList<>();
        subDev.add(new MenuItem("요청사항 & 문의", "/mng/dev/list", "", 0));
        menus.add(new MenuItem("개발사", "#", "ki-message-text-2", 2, subDev));

        return menus;
    }
}