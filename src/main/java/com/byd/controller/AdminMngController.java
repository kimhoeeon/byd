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
import java.util.ArrayList;
import java.util.LinkedHashMap;
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
    public ResponseDTO checkArrival(@RequestParam("qrToken") String qrToken,
                                    @RequestParam(value = "adminCode", required = false, defaultValue = "101") String adminCode) {
        ResponseDTO response = new ResponseDTO();

        try {
            ParticipantVO participant = adminMngService.getParticipantByQrCodeUrl(qrToken);

            if (participant == null) {
                response.setSuccess(false);
                response.setMessage("유효하지 않은 QR 코드입니다.");
                return response;
            }

            // 분기별 이미 출석 처리된 경우 방어
            if ("101".equals(adminCode) && "Y".equals(participant.getChallengeCheckYn())) {
                response.setSuccess(false);
                response.setMessage("이미 챌린지 출석 처리가 완료된 고객입니다. (" + participant.getName() + ")");
                return response;
            } else if ("202".equals(adminCode) && "Y".equals(participant.getDriveCheckYn())) {
                response.setSuccess(false);
                response.setMessage("이미 시승 출석 처리가 완료된 고객입니다. (" + participant.getName() + ")");
                return response;
            }

            adminMngService.updateArrivalStatus(participant.getSeq(), adminCode);

            String eventType = "101".equals(adminCode) ? "챌린지" : "시승";
            response.setSuccess(true);
            response.setMessage(eventType + " 출석 완료! [ " + participant.getName() + "님 / " + participant.getCarModel() + " / " + participant.getTestDriveTime() + " ]");

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
    public ResponseDTO manualArrival(@RequestParam("seq") int seq,
                                     @RequestParam("status") boolean status,
                                     @RequestParam("type") String type) {
        ResponseDTO response = new ResponseDTO();
        try {
            String columnName = "challenge".equals(type) ? "challenge_check_yn" : "drive_check_yn";
            String adminCode = "challenge".equals(type) ? "101" : "202";

            if (status) {
                adminMngService.updateArrivalStatus(seq, adminCode);
            } else {
                adminMngService.cancelArrivalStatus(seq, columnName);
            }
            response.setSuccess(true);
        } catch (Exception e) {
            response.setSuccess(false);
        }
        return response;
    }

    // ==========================================
    // 엑셀 다운로드를 위한 전체 목록 조회 API
    // ==========================================
    @GetMapping("/api/participant/excelData")
    @ResponseBody
    public List<Map<String, String>> getExcelData(Criteria cri) {
        List<ParticipantVO> list = adminMngService.getAllList(cri);
        List<Map<String, String>> excelData = new ArrayList<>();

        for (ParticipantVO vo : list) {
            Map<String, String> row = new LinkedHashMap<>();

            String regDateStr = "";
            if (vo.getRegDate() != null) {
                regDateStr = vo.getRegDate().toString();
                if (regDateStr.endsWith(".0")) {
                    regDateStr = regDateStr.substring(0, regDateStr.length() - 2);
                }
            }

            row.put("문의일자", regDateStr);
            row.put("전시장 코드", getShopCode(vo.getShopInfo()));
            row.put("전시장명", vo.getShopInfo());

            row.put("유입경로 코드", "4040");
            row.put("유입경로명", "오프라인");

            row.put("고객명", vo.getName());
            row.put("연락처", vo.getPhone());

            row.put("관심모델그룹 코드", getCarModelCode(vo.getCarModel()));
            row.put("관심모델명", vo.getCarModel());

            row.put("시승타임 선택", vo.getTestDriveTime());
            row.put("개인정보 동의여부", "Y");
            row.put("마케팅 동의여부", vo.getMktAgree() != null ? vo.getMktAgree() : "N");

            // 챌린지 및 시승 참여 여부를 분리된 컬럼으로 출력
            row.put("챌린지 참여", vo.getChallengeCheckYn() != null ? vo.getChallengeCheckYn() : "N");
            row.put("시승 참여", vo.getDriveCheckYn() != null ? vo.getDriveCheckYn() : "N");

            excelData.add(row);
        }

        return excelData;
    }

    // 엑셀 맵핑용 - 전시장 코드 변환 함수
    private String getShopCode(String shopName) {
        if (shopName == null || shopName.trim().isEmpty()) return "";
        switch (shopName.trim()) {
            case "BYD 동탄": return "APKR0001AW0011SW";
            case "BYD 부산 동래": return "APKR0001AW0010SW";
            case "BYD 분당": return "APKR0001AW0003SW";
            case "BYD 서초": return "APKR0001AW0002SW";
            case "BYD 수영": return "APKR0001AW0005SW";
            case "BYD 수원": return "APKR0001AW0001SW";
            case "BYD 스타필드 명지": return "APKR0001AW0014SW";
            case "BYD 스타필드 안성": return "APKR0001AW0016SW";
            case "BYD 스타필드 운정": return "APKR0001AW0017SW";
            case "BYD 스타필드 일산": return "APKR0001AW0013SW";
            case "BYD 스타필드 하남": return "APKR0001AW0015SW";
            case "BYD 일산": return "APKR0001AW0007SW";
            case "BYD 창원": return "APKR0001AW0012SW";
            case "BYD 강서": return "APKR0002AW0004SW";
            case "BYD 김포": return "APKR0002AW0005SW";
            case "BYD 마포": return "APKR0002AW0006SW";
            case "BYD 용산": return "APKR0002AW0001SW";
            case "BYD 의정부": return "APKR0002AW0010SW";
            case "BYD 제주": return "APKR0002AW0002SW";
            case "BYD 천안": return "APKR0002AW0008SW";
            case "BYD 청주": return "APKR0002AW0009SW";
            case "BYD 강동": return "APKR0003AW0010SW";
            case "BYD 목동": return "APKR0003AW0002SW";
            case "BYD 부천": return "APKR0003AW0007SW";
            case "BYD 서해구": return "APKR0003AW0008SW";
            case "BYD 송도": return "APKR0003AW0001SW";
            case "BYD 송파": return "APKR0003AW0009SW";
            case "BYD 안양": return "APKR0003AW0003SW";
            case "BYD 대구": return "APKR0004AW0001SW";
            case "BYD 포항": return "APKR0004AW0002SW";
            case "BYD 원주": return "APKR0005AW0001SW";
            case "BYD 광주": return "APKR0006AW0003SW";
            case "BYD 대전": return "APKR0006AW0001SW";
            case "BYD 전주": return "APKR0006AW0005SW";
            default: return "";
        }
    }

    private String getCarModelCode(String carModel) {
        if (carModel == null || carModel.trim().isEmpty()) return "";
        switch (carModel.trim().toUpperCase()) {
            case "BYD DOLPHIN": return "BYD0004";
            case "BYD ATTO 3": return "BYD0001";
            case "BYD SEAL": return "BYD0005";
            case "BYD SEALION 7": return "BYD0019";
            default: return "";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/mng/index";
    }

}