package com.byd.controller;

import com.byd.config.MaintenanceInterceptor;
import com.byd.mapper.AdminMngMapper;
import com.byd.service.*;
import com.byd.service.*;
import com.byd.vo.AdminVO;
import com.byd.vo.GameVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/mng")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;     // DB 로그인용
    private final GameService gameService;
    private final MemberService memberService;
    private final DiaryService diaryService;
    private final StatsMngService statsMngService;

    private final AdminMngMapper adminMngMapper;

    // --- 1. 로그인 및 메인 ---

    @GetMapping("/index.do")
    public String loginPage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        // adminId 문자열이 아닌, 실제 admin 객체가 제대로 살아있는지 확인
        if (session != null && session.getAttribute("admin") != null) {
            return "redirect:/mng/main.do";
        }
        return "mng/index";
    }

    @PostMapping("/login")
    public String loginAction(@RequestParam("adminId") String id,
                              @RequestParam("adminPw") String pw,
                              HttpServletRequest request,
                              RedirectAttributes rttr) {
        try {
            // 접속자 IP 추출 (개별 IP 제한 체크용)
            String clientIp = getClientIp(request);

            HttpSession session = request.getSession();

            // 1. 로그인 서비스 호출 (다중 IP 체크 포함된 버전)
            AdminVO admin = adminService.login(id, pw, clientIp);

            if (admin != null) {
                // 2. 세션에 AdminVO 객체 저장 (Key: "admin")
                session.setAttribute("admin", admin);

                // 기존 호환성 유지 (필요하다면)
                session.setAttribute("adminId", admin.getLoginId());
                session.setAttribute("status", "logon");

                return "redirect:/mng/main.do";
            } else {
                rttr.addFlashAttribute("msg", "아이디 또는 비밀번호를 확인해주세요.");

                // [변경 3] 주소를 로그인 페이지로 완전히 변경 (리다이렉트)
                return "redirect:/mng/index.do";
            }

        } catch (Exception e) {
            log.warn("관리자 로그인 실패: {}", e.getMessage());

            // [변경 4] 예외 발생 시에도 리다이렉트로 처리
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/mng/index.do";
        }
    }

    @GetMapping("/login")
    public String loginGetRedirect() {
        return "redirect:/mng/index.do";
    }

    /**
     * 관리자 메인 대시보드
     */
    @GetMapping("/main.do")
    public String mainPage(Model model) {

        // [대시보드 통계 데이터 조회]
        // 1. 회원 현황 (상태별 통계 맵으로 변경 적용)
        int todayMembers = memberService.countTodayMembers();
        model.addAttribute("todayMembers", todayMembers);
        model.addAttribute("memberStats", statsMngService.getMemberStatusStats());

        // 2. 일기 현황 (상태별 통계 맵으로 변경 적용)
        int todayDiaries = diaryService.countTodayDiaries();
        model.addAttribute("todayDiaries", todayDiaries);
        model.addAttribute("diaryStats", statsMngService.getDiaryStatusStats());

        // 3. 오늘 경기 수
        List<GameVO> todayGameList = gameService.getAllGamesToday();
        model.addAttribute("todayGameList", todayGameList);

        // 시스템 상태 정보 수집
        addSystemStatus(model);

        // 현재 시스템 점검 모드 여부를 JSP에 전달
        model.addAttribute("isMaintenanceMode", MaintenanceInterceptor.isMaintenanceMode);

        // 회원 전체 통계 영역
        int dau = statsMngService.getDau();
        int mau = statsMngService.getMau();
        double avgWinRate = statsMngService.getTotalAvgWinRate();
        double avgMonthlyDiaries = statsMngService.getAvgMonthlyDiaries(mau);

        model.addAttribute("dau", dau);
        model.addAttribute("mau", mau);
        model.addAttribute("avgWinRate", String.format("%.1f", avgWinRate));
        model.addAttribute("avgMonthlyDiaries", String.format("%.1f", avgMonthlyDiaries));

        // 2. 주간 접속 통계 차트 데이터 가공
        List<Map<String, Object>> weeklyStats = statsMngService.getWeeklyAccessStats();

        // DB 결과를 Map으로 변환 (빠른 매칭을 위함)
        Map<String, Integer> statMap = new HashMap<>();
        for (Map<String, Object> stat : weeklyStats) {
            statMap.put((String) stat.get("logDate"), ((Number) stat.get("cnt")).intValue());
        }

        // 최근 7일의 날짜를 생성하여 빈 날짜(0명)도 그래프에 정상 노출되도록 처리
        List<String> chartDates = new ArrayList<>();
        List<Integer> chartCounts = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (int i = 6; i >= 0; i--) {
            LocalDate targetDate = today.minusDays(i);
            String dbDateStr = targetDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            String displayStr = targetDate.format(DateTimeFormatter.ofPattern("MM.dd")); // 화면 표기용 (예: 02.24)

            chartDates.add("'" + displayStr + "'");
            chartCounts.add(statMap.getOrDefault(dbDateStr, 0));
        }

        // JSTL이 배열 형태로 그대로 찍을 수 있도록 변환하여 전달
        model.addAttribute("chartDates", chartDates.toString());  // ['02.18', '02.19', ...]
        model.addAttribute("chartCounts", chartCounts.toString()); // [0, 5, 12, ...]

        return "mng/main";
    }

    // --- 시스템 상태 정보 수집 메소드 ---
    private void addSystemStatus(Model model) {
        // 1. DB 연결 상태 체크
        boolean dbStatus = false;
        try {
            // 간단한 쿼리로 DB 연결 확인 (예: 회원 수 조회 재활용)
            adminMngMapper.checkLoginId("admin");
            dbStatus = true;
        } catch (Exception e) {
            log.error("DB Connection Check Failed", e);
            dbStatus = false;
        }
        model.addAttribute("sysDbStatus", dbStatus);

        // 2. JVM 메모리 상태 (MB)
        Runtime runtime = Runtime.getRuntime();
        long totalMemory = runtime.totalMemory() / (1024 * 1024);
        long freeMemory = runtime.freeMemory() / (1024 * 1024);
        long usedMemory = totalMemory - freeMemory;

        // 0으로 나누기 방지
        int memoryUsage = 0;
        if (totalMemory > 0) {
            memoryUsage = (int) ((double) usedMemory / totalMemory * 100);
        }

        model.addAttribute("sysMemoryUsed", usedMemory);
        model.addAttribute("sysMemoryTotal", totalMemory);
        model.addAttribute("sysMemoryUsage", memoryUsage);

        // 3. 디스크 공간 (GB)
        File root = new File("/");
        long totalSpace = root.getTotalSpace() / (1024 * 1024 * 1024);
        long freeSpace = root.getUsableSpace() / (1024 * 1024 * 1024);
        long usedSpace = totalSpace - freeSpace;

        int diskUsage = 0;
        if (totalSpace > 0) {
            diskUsage = (int) ((double) usedSpace / totalSpace * 100);
        }

        model.addAttribute("sysDiskUsed", usedSpace);
        model.addAttribute("sysDiskTotal", totalSpace);
        model.addAttribute("sysDiskUsage", diskUsage);

        // (4) 스레드 및 코어 정보
        model.addAttribute("sysActiveThreads", Thread.activeCount());
        model.addAttribute("sysCpuCores", runtime.availableProcessors());

        // (5) OS 정보
        model.addAttribute("sysOsName", System.getProperty("os.name"));
        model.addAttribute("sysJavaVer", System.getProperty("java.version"));
    }
    
    /**
     * 로그아웃
     */
    @GetMapping("/logout.do")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/mng/index.do";
    }

    @PostMapping("/mng/profile/change-password")
    @ResponseBody
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session) {

        // 1. 세션에서 로그인된 관리자 정보 가져오기
        AdminVO admin = (AdminVO) session.getAttribute("admin");

        if (admin == null) {
            return "로그인 정보가 없습니다 (세션 만료).";
        }

        // 2. 서비스 호출 (이메일 대신 ID 전달)
        // AdminVO에 getId() 메서드가 있다고 가정합니다.
        return adminService.changePassword(admin.getLoginId(), currentPassword, newPassword);
    }

    // IP 추출 유틸 메서드
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    /************************************************************
     * **********************************************************
     * KBO 데이터 수집 관련
     * **********************************************************
     * **********************************************************/

    // 수동 업데이트 API
    // 사용법: /admin/game/update-rapid?date=2025-05-05
    /*@GetMapping("/update-rapid")
    public String updateFromRapid(@RequestParam(required = false) String date) {
        LocalDate targetDate = (date != null)
                ? LocalDate.parse(date, DateTimeFormatter.ISO_DATE)
                : LocalDate.now();

        gameDataService.fetchFromRapid(targetDate);
        return targetDate + " 경기 데이터 업데이트 요청 완료!";
    }*/

}