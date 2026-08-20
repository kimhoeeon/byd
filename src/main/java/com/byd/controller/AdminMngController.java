package com.byd.controller;

import com.byd.dto.PageDTO;
import com.byd.service.AdminMngService;
import com.byd.util.AES128;
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
import java.util.*;

@Slf4j
@Controller
@RequestMapping("/mng")
@RequiredArgsConstructor
public class AdminMngController {

    private final AdminMngService adminMngService;

    private static final String SECRET_KEY = "bydEventTokenKey";

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
            // 1. 전체 요약 통계
            Map<String, Object> stats = adminMngService.getDashboardSummaryStats();

            // 2. DB에서 실제 통계 데이터 조회
            List<Map<String, Object>> shopRaw = adminMngService.getShopDistributionStats();
            List<Map<String, Object>> timeRaw = adminMngService.getHourlyCheckinStats();
            List<Map<String, Object>> carRaw = adminMngService.getCarModelDistributionStats(); // 추가된 실제 차종별 데이터 호출
            List<Map<String, Object>> dailyRaw = adminMngService.getDailyCheckinStats(); // 추가된 실제 일별 데이터 호출

            Map<String, Object> chartData = new HashMap<>();

            // 차종별 통계
            List<Map<String, Object>> carStats = new ArrayList<>();
            if (carRaw != null) {
                for(Map<String, Object> m : carRaw) {
                    Map<String, Object> cObj = new HashMap<>();
                    cObj.put("label", m.get("CAR_MODEL"));
                    cObj.put("cnt", m.get("CNT"));
                    carStats.add(cObj);
                }
            }
            chartData.put("carStats", carStats);

            // 전시장별 통계
            List<Map<String, Object>> shopStats = new ArrayList<>();
            if (shopRaw != null) {
                for(Map<String, Object> m : shopRaw) {
                    Map<String, Object> sObj = new HashMap<>();
                    sObj.put("label", m.get("SHOP_INFO"));
                    sObj.put("cnt", m.get("CNT"));
                    shopStats.add(sObj);
                }
            }
            chartData.put("shopStats", shopStats);

            // 시간대별 통계
            List<Map<String, Object>> timeStats = new ArrayList<>();
            if (timeRaw != null) {
                for(Map<String, Object> t : timeRaw) {
                    Map<String, Object> tObj = new HashMap<>();
                    tObj.put("dateLabel", "오늘");
                    tObj.put("timeLabel", t.get("TIME_STR"));
                    tObj.put("cnt", t.get("CNT"));
                    timeStats.add(tObj);
                }
            }
            chartData.put("timeStats", timeStats);

            // 일별 통계
            List<String> dailyLabels = new ArrayList<>();
            List<Integer> dailyData = new ArrayList<>();
            if (dailyRaw != null) {
                for(Map<String, Object> d : dailyRaw) {
                    dailyLabels.add(String.valueOf(d.get("DATE_STR")));
                    dailyData.add(Integer.parseInt(String.valueOf(d.get("CNT"))));
                }
            }
            chartData.put("dailyLabels", dailyLabels);
            chartData.put("dailyData", dailyData);

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

        return "mng/participant/list";
    }

    @GetMapping("/participant/detail")
    public String participantDetail(@RequestParam("seq") int seq, Criteria cri, Model model) {
        ParticipantVO data = adminMngService.getParticipantBySeq(seq);
        model.addAttribute("data", data);
        model.addAttribute("cri", cri);
        return "mng/participant//detail";
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

    @GetMapping("/scanner")
    public String qrScannerPage(@RequestParam(value = "type", defaultValue = "challenge") String type, Model model) {
        if ("gift".equals(type)) {
            model.addAttribute("adminCode", "303");
            model.addAttribute("eventName", "경품수령");
            model.addAttribute("themeColor", "#f6c23e");
        }
        return "mng/scanner";
    }

    @PostMapping("/api/checkArrival")
    @ResponseBody
    public Map<String, Object> checkArrival(@RequestParam("qrToken") String qrToken,
                                            @RequestParam(value = "adminCode", required = false) String adminCode) {
        Map<String, Object> res = new HashMap<>();
        try {
            // 1. 넘어온 토큰 복호화
            AES128 aes128 = new AES128(SECRET_KEY);
            String decryptedSeqStr = aes128.decrypt(qrToken);
            int seq = Integer.parseInt(decryptedSeqStr);

            // 2. 해당 참여자 데이터 조회
            ParticipantVO data = adminMngService.getParticipantBySeq(seq);
            if (data == null) {
                res.put("success", false);
                res.put("message", "유효하지 않은 QR 코드입니다.");
                return res;
            }

            // 3. 중복 수령 방지 로직
            if ("Y".equals(data.getGiftCheckYn())) {
                res.put("success", false);
                res.put("message", data.getName() + "님은 이미 경품을 수령하셨습니다.");
                return res;
            }

            // 4. 경품 수령 상태 즉시 업데이트
            adminMngService.updateGiftStatus(seq, "Y");

            res.put("success", true);
            res.put("message", data.getName() + "님 경품 수령이 확인되었습니다.");

        } catch (Exception e) {
            log.error("QR 스캔 에러: {}", e.getMessage());
            res.put("success", false);
            res.put("message", "잘못된 형식의 QR 코드이거나 처리 중 오류가 발생했습니다.");
        }
        return res;
    }

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