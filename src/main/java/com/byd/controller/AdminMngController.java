package com.byd.controller;

import com.byd.dto.PageDTO;
import com.byd.dto.ResponseDTO;
import com.byd.service.AdminMngService;
import com.byd.vo.AdminVO;
import com.byd.vo.Criteria;
import com.byd.vo.ParticipantVO;
import com.byd.vo.StatsVO;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mng")
@RequiredArgsConstructor
public class AdminMngController {

    private final AdminMngService adminMngService;

    @GetMapping({"/", "/index", "/login"})
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

    // 수동 참가자 조회 화면 (QR 분실 시)
    @GetMapping("/inquiry")
    public String tabletInquiryPage() {
        return "mng/inquiry";
    }

    // 태블릿 조회 화면용 고객 비동기 검색 API
    @GetMapping("/api/searchParticipant")
    @ResponseBody
    public List<ParticipantVO> searchParticipant(Criteria cri) {
        // 태블릿 팝업에서는 페이징 없이 최대 30개 정도만 넉넉히 가져와서 뿌려줌
        cri.setPageNum(1);
        cri.setAmount(30);
        return adminMngService.getList(cri);
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

            // 1. 이미 출석 처리된 경우 방어
            if ("101".equals(adminCode) && "Y".equals(participant.getChallengeCheckYn())) {
                response.setSuccess(false);
                response.setMessage("이미 챌린지 출석 처리가 완료된 고객입니다. (" + participant.getName() + ")");
                return response;
            } else if ("202".equals(adminCode) && "Y".equals(participant.getDriveCheckYn())) {
                response.setSuccess(false);
                response.setMessage("이미 시승 출석 처리가 완료된 고객입니다. (" + participant.getName() + ")");
                return response;
            }

            // ==========================================
            // 시승 미신청 고객 QR 스캔 원천 차단
            // ==========================================
            if ("202".equals(adminCode) && "시승 미신청".equals(participant.getTestDriveTime())) {
                response.setSuccess(false);
                response.setMessage("시승을 신청하지 않은 고객입니다. (" + participant.getName() + "님)");
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

            // ==========================================
            // 관리자 화면 토글 조작 시에도 시승 미신청 고객 방어
            // ==========================================
            if (status && "202".equals(adminCode)) {
                ParticipantVO participant = adminMngService.getParticipantBySeq(seq);
                if (participant != null && "시승 미신청".equals(participant.getTestDriveTime())) {
                    response.setSuccess(false);
                    response.setMessage("시승 미신청 고객은 출석 처리를 할 수 없습니다.");
                    return response;
                }
            }

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

    // 삭제 기능 API 추가
    @PostMapping("/api/participant/delete")
    @ResponseBody
    public ResponseDTO deleteParticipant(@RequestParam("seq") int seq) {
        ResponseDTO response = new ResponseDTO();
        try {
            adminMngService.deleteParticipant(seq);
            response.setSuccess(true);
            response.setMessage("해당 참가자가 삭제되었습니다.");
        } catch (Exception e) {
            response.setSuccess(false);
            response.setMessage("삭제 처리 중 오류가 발생했습니다.");
        }
        return response;
    }

    // ==========================================
    // 엑셀 다운로드를 위한 전체 목록 조회 API
    // ==========================================
    @GetMapping("/api/participant/excelDownload")
    public void downloadExcel(Criteria cri, HttpServletResponse response) throws Exception {
        // 검색 조건에 맞는 전체 목록 조회
        List<ParticipantVO> list = adminMngService.getAllList(cri);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("참여자 목록");

        // 1. 헤더 스타일 지정 (회색 배경, 굵은 글씨, 가운데 정렬, 테두리)
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // 2. 데이터 스타일 지정 (테두리, 세로 가운데 정렬)
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);
        dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        // 3. 헤더 행 생성
        Row headerRow = sheet.createRow(0);
        String[] headers = {"문의일자", "전시장코드", "전시장명", "유입경로코드", "유입경로명", "고객명", "연락처", "관심모델그룹코드", "관심모델그룹코드명", "시승시간", "개인정보동의여부", "마케팅동의여부", "챌린지참여", "시승참여", "주소"};

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 4. 데이터 행 생성
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        int rowNum = 1;

        for (ParticipantVO vo : list) {
            Row row = sheet.createRow(rowNum++);

            // 날짜 포맷 적용
            String regDateStr = "";
            if (vo.getRegDate() != null) {
                regDateStr = sdf.format(vo.getRegDate());
            }

            String[] rowData = {
                    regDateStr,
                    getShopCode(vo.getShopInfo()),
                    vo.getShopInfo() != null ? vo.getShopInfo() : "",
                    "4040",
                    "오프라인",
                    vo.getName(),
                    vo.getPhone(),
                    getCarModelCode(vo.getCarModel()),
                    vo.getCarModel() != null ? vo.getCarModel() : "",
                    vo.getTestDriveTime() != null ? vo.getTestDriveTime() : "",
                    "Y",
                    "Y",
                    vo.getChallengeCheckYn() != null ? vo.getChallengeCheckYn() : "N",
                    vo.getDriveCheckYn() != null ? vo.getDriveCheckYn() : "N",
                    vo.getAddress() != null ? vo.getAddress() : ""
            };

            for (int i = 0; i < rowData.length; i++) {
                Cell cell = row.createCell(i);
                cell.setCellValue(rowData[i]);
                cell.setCellStyle(dataStyle);
            }
        }

        // 5. 컬럼 너비 자동 조정
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + (short) 1024);
        }

        // 6. 브라우저 응답 설정 및 파일 전송
        SimpleDateFormat fileDateFmt = new SimpleDateFormat("yyyyMMdd");
        String today = fileDateFmt.format(new java.util.Date());
        String fileName = "BYD_참여자_" + today + ".xlsx";
        // 한글 파일명 깨짐 방지
        fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

        workbook.write(response.getOutputStream());
        workbook.close();
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