package com.byd.controller;

import com.byd.service.AdminMngService;
import com.byd.vo.AdminVO;
import com.byd.vo.ParticipantVO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.byd.vo.StatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mng")
@RequiredArgsConstructor
public class AdminMngController {

    private final AdminMngService adminMngService;

    @GetMapping({"", "/", "/login"})
    public String loginPage(HttpSession session) {
        // 이미 로그인된 상태라면 대시보드로 즉시 이동
        if (session.getAttribute("adminInfo") != null) {
            return "redirect:/mng/main";
        }
        return "mng/login";
    }

    @PostMapping("/loginProcess")
    public String loginProcess(@RequestParam("adminId") String adminId,
                               @RequestParam("adminPw") String adminPw,
                               HttpServletRequest request, Model model) {
        AdminVO adminVO = adminMngService.getAdminById(adminId);

        if (adminVO != null && adminVO.getAdminPw().equals(adminPw)) {
            request.getSession().setAttribute("adminInfo", adminVO);
            return "redirect:/mng/main";
        } else {
            model.addAttribute("errorMessage", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "mng/login";
        }
    }

    @GetMapping("/main")
    public String mainPage(HttpSession session, Model model) {
        if (session.getAttribute("adminInfo") == null) {
            return "redirect:/mng/login";
        }

        // 1. 대시보드 상단 요약 데이터 가져오기
        StatsVO stats = adminMngService.getDashboardSummary();
        // 통계 데이터가 없을 경우(NULL) 기본값 0 처리
        if(stats == null) stats = new StatsVO();

        // 2. 차트 데이터 (최근 7일 및 타입별 누적) 가져오기
        Map<String, Object> chartData = adminMngService.getChartData();

        model.addAttribute("stats", stats);
        model.addAttribute("chartData", chartData);

        return "mng/main";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/mng/login";
    }

    @GetMapping("/event/list")
    public String eventList(HttpSession session, Model model) {
        if (session.getAttribute("adminInfo") == null) return "redirect:/mng/login";

        List<ParticipantVO> list = adminMngService.getParticipantListByType("EVENT");
        model.addAttribute("list", list);
        return "mng/event/event_list";
    }

    @GetMapping({"/event/detail", "/drive/detail"})
    public String participantDetail(@RequestParam("seq") int seq, HttpSession session, Model model) {
        if (session.getAttribute("adminInfo") == null) return "redirect:/mng/login";

        ParticipantVO data = adminMngService.getParticipantBySeq(seq);
        model.addAttribute("data", data);

        return "mng/detail/participant_detail";
    }

    @GetMapping("/drive/list")
    public String driveList(HttpSession session, Model model) {
        if (session.getAttribute("adminInfo") == null) return "redirect:/mng/login";

        List<ParticipantVO> list = adminMngService.getParticipantListByType("DRIVE");
        model.addAttribute("list", list);
        return "mng/drive/drive_list";
    }

    // 현장 스태프가 도착 확인 버튼 클릭 시 처리하는 비동기 API
    @PostMapping("/api/checkArrival")
    @ResponseBody
    public String checkArrival(@RequestParam("seq") int seq, HttpSession session) {
        if (session.getAttribute("adminInfo") == null) return "FAIL";

        try {
            adminMngService.updateQrScanTime(seq);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }
}