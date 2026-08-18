package com.byd.controller;

import com.byd.dto.PageDTO;
import com.byd.service.AdminMngService;
import com.byd.vo.AdminVO;
import com.byd.vo.Criteria;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;

@Slf4j
@Controller
@RequestMapping("/mng")
@RequiredArgsConstructor
public class AdminMngController {

    private final AdminMngService adminMngService;

    @GetMapping({"/", "/index", "/login"})
    public String loginPage(HttpSession session) {
        if (session.getAttribute("adminInfo") != null) {
            return "redirect:/mng/main";
        }
        return "mng/index";
    }

    @PostMapping("/loginProcess")
    public String loginProcess(@RequestParam("adminId") String adminId,
                               @RequestParam("adminPw") String adminPw,
                               HttpSession session, Model model) {
        AdminVO admin = adminMngService.getAdminById(adminId);
        if (admin != null && admin.getAdminPw().equals(adminPw)) {
            session.setAttribute("adminInfo", admin);
            return "redirect:/mng/main";
        }
        model.addAttribute("errorMessage", "아이디 또는 비밀번호가 일치하지 않습니다.");
        return "mng/index";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/mng/login";
    }

    @GetMapping("/main")
    public String mainDashboard(Model model) {
        try {
            Map<String, Object> stats = adminMngService.getDashboardSummaryStats();
            List<Map<String, Object>> shopRaw = adminMngService.getShopDistributionStats();
            List<Map<String, Object>> timeRaw = adminMngService.getHourlyCheckinStats();

            Map<String, Object> chartData = new HashMap<>();

            // 차종별 기본 목업 구성
            List<Map<String, Object>> carStats = new ArrayList<>();
            Map<String, Object> c1 = new HashMap<>(); c1.put("label", "BYD SEAL"); c1.put("cnt", 15); carStats.add(c1);
            Map<String, Object> c2 = new HashMap<>(); c2.put("label", "BYD ATTO 3"); c2.put("cnt", 25); carStats.add(c2);
            chartData.put("carStats", carStats);

            List<Map<String, Object>> shopStats = new ArrayList<>();
            for(Map<String, Object> m : shopRaw) {
                Map<String, Object> sObj = new HashMap<>();
                sObj.put("label", m.get("SHOP_INFO"));
                sObj.put("cnt", m.get("CNT"));
                shopStats.add(sObj);
            }
            chartData.put("shopStats", shopStats);

            List<Map<String, Object>> timeStats = new ArrayList<>();
            for(Map<String, Object> t : timeRaw) {
                Map<String, Object> tObj = new HashMap<>();
                tObj.put("dateLabel", "오늘");
                tObj.put("timeLabel", t.get("TIME_STR"));
                tObj.put("cnt", t.get("CNT"));
                timeStats.add(tObj);
            }
            chartData.put("timeStats", timeStats);

            chartData.put("dailyLabels", Arrays.asList("08.15", "08.16", "08.17", "08.18"));
            chartData.put("dailyData", Arrays.asList(5, 10, 8, stats.get("todayCnt")));

            model.addAttribute("stats", stats);
            model.addAttribute("chartData", chartData);
        } catch (Exception e) {
            log.error("대시보드 에러: {}", e.getMessage());
        }
        return "mng/main";
    }

    @GetMapping("/participant/list")
    public String participantList(Criteria cri, Model model) {
        if (cri.getAmount() == 0) cri.setAmount(15);
        if (cri.getPageNum() == 0) cri.setPageNum(1);

        List<ParticipantVO> list = adminMngService.getList(cri);
        int total = adminMngService.getTotalCount(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        model.addAttribute("cri", cri);

        return "mng/list";
    }

    @GetMapping("/participant/detail")
    public String participantDetail(@RequestParam("seq") int seq, Criteria cri, Model model) {
        ParticipantVO data = adminMngService.getParticipantBySeq(seq);
        model.addAttribute("data", data);
        model.addAttribute("cri", cri);
        return "mng/detail";
    }

    @PostMapping("/api/manualArrival")
    @ResponseBody
    public Map<String, Object> updateGiftCheck(@RequestParam("seq") int seq,
                                               @RequestParam("status") boolean status,
                                               @RequestParam("type") String type) {
        Map<String, Object> res = new HashMap<>();
        try {
            if ("gift".equals(type)) {
                adminMngService.updateGiftStatus(seq, status ? "Y" : "N");
                res.put("success", true);
                res.put("message", "기념품 수령 상태가 반영되었습니다.");
            } else {
                res.put("success", false);
                res.put("message", "올바르지 않은 접근 유형입니다.");
            }
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "DB 업데이트 중 오류가 발생했습니다.");
        }
        return res;
    }

    @PostMapping("/api/participant/delete")
    @ResponseBody
    public Map<String, Object> deleteParticipant(@RequestParam("seq") int seq) {
        Map<String, Object> res = new HashMap<>();
        try {
            adminMngService.deleteParticipant(seq);
            res.put("success", true);
            res.put("message", "데이터가 삭제되었습니다.");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "삭제 오류 발생.");
        }
        return res;
    }

    @RequestMapping({"/api/participant/excelDownload"})
    public void downloadExcel(Criteria cri, HttpServletResponse response) throws Exception {
        List<ParticipantVO> list = adminMngService.getAllList(cri);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("이벤트_참여목록");

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

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);
        dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        Row headerRow = sheet.createRow(0);
        String[] headers = {"등록일시", "경품수령확인(QR)", "이름", "연락처", "이메일", "방문전시장", "관심차량", "마케팅동의"};

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        int rowNum = 1;

        for (ParticipantVO vo : list) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(vo.getRegDate() != null ? sdf.format(vo.getRegDate()) : "");
            // XML에서 Alias 처리되었으므로 getGiftCheckYn() 호출 가능
            row.createCell(1).setCellValue("Y".equals(vo.getGiftCheckYn()) ? "수령 완료" : "미수령");
            row.createCell(2).setCellValue(vo.getName());
            row.createCell(3).setCellValue(vo.getPhone());
            row.createCell(4).setCellValue(vo.getEmail() != null ? vo.getEmail() : "");
            row.createCell(5).setCellValue(vo.getShopInfo() != null ? vo.getShopInfo() : "");
            row.createCell(6).setCellValue(vo.getCarModel() != null ? vo.getCarModel() : "");
            row.createCell(7).setCellValue(vo.getMktAgree() != null ? vo.getMktAgree() : "N");

            for (int i = 0; i < 8; i++) {
                row.getCell(i).setCellStyle(dataStyle);
            }
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.setColumnWidth(i, 4000);
        }

        SimpleDateFormat fileDateFmt = new SimpleDateFormat("yyyyMMdd");
        String today = fileDateFmt.format(new Date());
        String fileName = "BYD_이벤트참여목록_" + today + ".xlsx";
        fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

        workbook.write(response.getOutputStream());
        workbook.close();
    }
}