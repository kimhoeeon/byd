package com.byd.controller;

import com.byd.dto.StadiumVisitDTO;
import com.byd.service.DiaryService;
import com.byd.service.GameService;
import com.byd.service.WinYoService;
import com.byd.vo.DiaryVO;
import com.byd.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/diary")
public class WinYoController {

    private final WinYoService winYoService;
    private final DiaryService diaryService;
    private final GameService gameService;

    /**
     * 일기 탭 메인 (대시보드)
     * URL: /diary/winyo
     * 기능: 승요력 통계, 내 일기(최신 3개), 친구 일기(최신 3개), 스코어카드
     */
    @GetMapping("/winyo")
    public String winYoMain(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        Long memberId = loginMember.getMemberId();

        // 1. 친구 수 확인 및 플래그 설정
        int friendCount = diaryService.getFriendCount(memberId);
        boolean hasFriends = (friendCount > 0);
        model.addAttribute("hasFriends", hasFriends); // JSP에서 사용할 플래그

        // 1. 승요력 통계 (Fire Card) - LockerController Main 으로 이동
        /*WinYoAnalysisDTO winYo = winYoService.analyzeWinYoPower(memberId);
        model.addAttribute("winYo", winYo);*/

        // 2. 나의 최신 일기 (최대 4개)
        List<DiaryVO> myAllDiaries = diaryService.getMyDiaryList(memberId);
        List<DiaryVO> myDiaries = myAllDiaries.size() > 4 ? myAllDiaries.subList(0, 4) : myAllDiaries;
        model.addAttribute("myDiaries", myDiaries);

        // 3. 친구들의 일기
        // ★ 수정됨: 무조건 친구 일기를 가져오는 getFriendDiaryList 대신 조건부 로직 호출
        List<DiaryVO> friendDiaries = diaryService.getRecommendedFriendDiaries(memberId);
        model.addAttribute("friendDiaries", friendDiaries);

        // 4. 스코어카드 (구장 방문 현황)
        List<StadiumVisitDTO> stadiumStatus = diaryService.getStadiumVisitStatus(memberId);
        int visitedCount = diaryService.getVisitedStadiumCount(memberId);

        model.addAttribute("stadiumStatus", stadiumStatus);
        model.addAttribute("visitedCount", visitedCount);

        // 오늘 경기 존재 여부 확인 (취소된 경기 제외) - LockerController Main 으로 이동
        /*boolean hasTodayGame = false;
        Long todayDiaryId = null;

        List<GameVO> todayGames = gameService.getAllGamesToday(memberId);
        if (todayGames != null && !todayGames.isEmpty()) {
            for (GameVO game : todayGames) {
                if (!"CANCELLED".equals(game.getStatus())) {
                    hasTodayGame = true;
                    // 해당 경기에 대해 작성한 일기가 있는지 확인
                    DiaryVO todayDiary = diaryService.getDiaryByMemberAndGame(memberId, game.getGameId());
                    if (todayDiary != null) {
                        todayDiaryId = todayDiary.getDiaryId();
                        break; // 작성한 일기를 찾았으면 더 이상 찾지 않음
                    }
                    break;
                }
            }
        }
        model.addAttribute("hasTodayGame", hasTodayGame);
        model.addAttribute("todayDiaryId", todayDiaryId);*/

        return "diary/diary_main";
    }

    /**
     * [추가] 전체 보기 탭 메인
     * URL: /diary/all
     */
    @GetMapping("/all")
    public String diaryAll(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 알림 뱃지 플래그 (기존 레이아웃 유지용)
        model.addAttribute("hasUnreadAlarm", false); // 실제 알림 서비스 연동 필요

        // 내 팀 코드 전달 (JSP 필터링용)
        model.addAttribute("myTeamCode", loginMember.getMyTeamCode());

        // 이번 주 HOT 직관 일기 (인기 게시물) 조회
        List<DiaryVO> popularDiaries = diaryService.getPopularDiaries();
        model.addAttribute("popularDiaries", popularDiaries);

        return "diary/diary_all";
    }

    /**
     * [추가] 달력: 날짜별 직관 일기 목록 (AJAX)
     */
    @GetMapping("/api/list-by-date")
    @ResponseBody
    public List<DiaryVO> getDiariesByDate(
            @RequestParam("date") String date,
            @RequestParam(value="teamCode", required=false) String teamCode,
            @RequestParam(value="page", defaultValue="1") int page,
            @RequestParam(value="limit", defaultValue="5") int limit) { // limit 추가

        return diaryService.getDiariesByDate(date, teamCode, page, limit);
    }

    /**
     * [추가] 달력: 월별 일기가 존재하는 날짜 목록 조회 (AJAX)
     */
    @GetMapping("/api/calendar-dates")
    @ResponseBody
    public List<String> getCalendarDates(@RequestParam("month") String month) {
        // month 포맷: "2026-04"
        return diaryService.getDiaryDatesByMonth(month);
    }
}