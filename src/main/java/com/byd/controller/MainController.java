package com.byd.controller;

import com.byd.dto.WinYoAnalysisDTO;
import com.byd.service.*;
import com.byd.vo.*;
import com.byd.service.*;
import com.byd.vo.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MainController {

    private final GameService gameService;
    private final WinYoService winYoService;
    private final DiaryService diaryService;
    private final LockerService lockerService;
    private final ContentMngService contentMngService;
    private final SystemMngService systemMngService;

    // 1. 처음 접속 시 스플래시 화면 노출
    @GetMapping("/")
    public String splashPage(HttpSession session) {
        // 이미 로그인된 상태라면 바로 메인으로 (선택 사항)
        if (session.getAttribute("loginMember") != null) {
            return "redirect:/main";
        }
        return "splash"; // /WEB-INF/views/splash.jsp
    }

    // 점검 페이지 매핑
    @GetMapping("/maintenance")
    public String maintenance() {
        return "maintenance"; // /WEB-INF/views/maintenance.jsp 연결
    }

    @GetMapping("/main")
    public String mainPage(Model model, HttpSession session) {

        // 1. 세션에서 로그인 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

        // 비로그인 접근 차단
        if (loginMember == null) return "redirect:/member/login";

        try {

            String myTeamCode = loginMember.getMyTeamCode();

            // 1. [오늘 경기]
            if (myTeamCode != null && !"NONE".equals(myTeamCode)) {
                List<GameVO> todayGames = gameService.getTodayGame(myTeamCode);

                // 오늘 경기의 일기 작성 여부를 확인하여 diaryId 세팅
                if (todayGames != null && !todayGames.isEmpty()) {
                    for (GameVO game : todayGames) {
                        DiaryVO myDiary = diaryService.getDiaryByMemberAndGame(loginMember.getMemberId(), game.getGameId());
                        if (myDiary != null) {
                            game.setDiaryId(myDiary.getDiaryId());
                        }
                    }
                }

                model.addAttribute("todayGames", todayGames);
            }

            // 2. [승요력]
            WinYoAnalysisDTO winYoStats = winYoService.analyzeWinYoPower(loginMember.getMemberId());
            model.addAttribute("winYo", winYoStats);

            // 3. [구단 콘텐츠] 랜덤 배너
            /*TeamContentVO randomBanner = contentMngService.getRandomTeamContent(myTeamCode);
            if (randomBanner != null) {
                model.addAttribute("teamBannerItem", randomBanner);
            }*/

            // 4. [이벤트] 최신글 1개
            List<EventVO> events = contentMngService.getActiveEventList();
            if (!events.isEmpty()) {
                model.addAttribute("latestEvent", events.get(0));
            }

            // 5. [직관 일기] 최근 일기 3개
            List<DiaryVO> recentDiaries = diaryService.getRecentDiaries(loginMember.getMemberId()); // Service에 메서드 추가 필요
            model.addAttribute("diaries", recentDiaries);

            // 6. [구단 소식] 최신글 (Active & 내 팀)
            List<TeamContentVO> teamContents = contentMngService.getActiveTeamContentList(loginMember.getMyTeamCode(), 4);
            if (!teamContents.isEmpty()) {
                // 화면 디자인에 따라 리스트 전체를 넘기거나 최신 n개만 넘김
                model.addAttribute("latestContent", teamContents);
            }

        } catch (Exception e) {
            log.error("메인 화면 데이터 로딩 중 오류 발생", e);
        }

        return "main"; // /WEB-INF/views/main.jsp

        // 서비스 준비중 페이지로 연결
        //return "maintenance";
    }

    // 앱 최신 버전 체크 API
    @GetMapping("/api/app/version")
    @ResponseBody
    public Map<String, Object> checkAppVersion(@RequestParam("os") String os) {
        Map<String, Object> result = new HashMap<>();

        // OS 타입 대문자 변환 (android -> ANDROID)
        String osType = os != null ? os.toUpperCase() : "ANDROID";

        AppVersionVO latestVersion = systemMngService.getLatestVersion(osType);

        if (latestVersion != null) {
            result.put("code", "OK");
            result.put("data", latestVersion);
        } else {
            result.put("code", "FAIL");
            result.put("message", "버전 정보가 없습니다.");
        }

        return result;
    }

}