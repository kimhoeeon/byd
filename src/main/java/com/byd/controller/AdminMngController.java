package com.byd.controller;

import com.byd.dto.PageDTO;
import com.byd.dto.ResponseDTO;
import com.byd.service.AdminMngService;
import com.byd.vo.AdminVO;
import com.byd.vo.Criteria;
import com.byd.vo.ParticipantVO;
import com.byd.vo.StatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
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
        return "mng/index";
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
            return "mng/index";
        }
    }

    @GetMapping("/main")
    public String mainPage(HttpSession session, Model model) {
        if (session.getAttribute("adminInfo") == null) return "redirect:/mng/login";

        StatsVO stats = adminMngService.getDashboardSummary();
        if (stats == null) stats = new StatsVO();

        Map<String, Object> chartData = adminMngService.getChartData();

        model.addAttribute("stats", stats);
        model.addAttribute("chartData", chartData);
        return "mng/main";
    }

    // 통합 목록 뷰
    @GetMapping("/participant/list")
    public String participantList(Criteria cri, Model model) {
        // 데이터 목록 조회
        List<ParticipantVO> list = adminMngService.getList(cri);
        // 전체 게시물 수 조회
        int total = adminMngService.getTotalCount(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total)); // 페이징 객체 전달
        model.addAttribute("cri", cri); // 현재 검색 조건 및 페이지 번호 유지용

        return "mng/participant/list";
    }

    // 통합 상세 뷰
    // 상세 화면
    @GetMapping("/participant/detail")
    public String participantDetail(@RequestParam("seq") int seq, @ModelAttribute("cri") Criteria cri, Model model) {
        ParticipantVO data = adminMngService.getParticipantBySeq(seq);
        if (data == null) {
            // 존재하지 않는 데이터 처리
            return "redirect:/mng/participant/list";
        }

        model.addAttribute("data", data);
        return "mng/participant/detail";
    }

    @GetMapping("/scanner")
    public String qrScannerPage() {
        return "mng/scanner"; // mng/scanner.jsp 렌더링
    }

    // 현장 스태프 도착 확인 API
    @PostMapping("/api/checkArrival")
    @ResponseBody
    public ResponseDTO checkArrival(@RequestParam("qrToken") String qrToken) {
        ResponseDTO response = new ResponseDTO();

        try {
            ParticipantVO participant = adminMngService.getParticipantByQrCodeUrl(qrToken);

            // 1. 존재하지 않는 회원인 경우
            if (participant == null) {
                response.setSuccess(false);
                response.setMessage("유효하지 않은 QR 코드입니다.");
                return response;
            }

            if (participant.getQrScanTime() != null) {
                response.setSuccess(false);
                response.setMessage("이미 출석 처리가 완료된 고객입니다. (" + participant.getName() + ")");
                return response;
            }

            // 3. 정상 출석 처리 (qr_scan_time 업데이트)
            adminMngService.updateArrivalStatus(participant.getSeq());

            // 4. 성공 응답 (스태프가 화면에서 확인할 수 있도록 차량/시간 정보 함께 전송)
            response.setSuccess(true);
            response.setMessage("출석 처리 완료! [ " + participant.getName() + "님 / " + participant.getCarModel() + " / " + participant.getTestDriveTime() + " ]");

        } catch (Exception e) {
            response.setSuccess(false);
            response.setMessage("출석 처리 중 시스템 오류가 발생했습니다.");
            e.printStackTrace();
        }

        return response;
    }

    // 수동 도착 확인/취소 토글 API
    @PostMapping("/api/manualArrival")
    @ResponseBody
    public ResponseDTO manualArrival(@RequestParam("seq") int seq, @RequestParam("status") boolean status) {
        ResponseDTO response = new ResponseDTO();
        try {
            if (status) {
                adminMngService.updateArrivalStatus(seq); // 토글 ON (도착)
            } else {
                adminMngService.cancelArrivalStatus(seq); // 토글 OFF (취소)
            }
            response.setSuccess(true);
        } catch (Exception e) {
            response.setSuccess(false);
        }
        return response;
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/mng/index";
    }

}