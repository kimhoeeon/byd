package com.byd.controller;

import com.byd.dto.PageDTO;
import com.byd.service.QuizService;
import com.byd.vo.*;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/mng/quiz")
@RequiredArgsConstructor
public class QuizAdminController {

    private final QuizService quizService;

    // 날짜와 회차 검색 파라미터 추가
    @GetMapping("/list")
    public String quizList(Criteria cri,
                           @RequestParam(required = false) String keyword,
                           @RequestParam(required = false) String perfectScoreOnly,
                           @RequestParam(required = false) String searchDate,
                           @RequestParam(required = false) String searchSession,
                           Model model) {

        cri.setAmount(50); // 페이지당 50건으로 고정

        // 빈 문자열("") 방어 로직 추가: 값이 있을 때만 숫자로 변환
        Integer sessionNo = null;
        if (searchSession != null && !searchSession.trim().isEmpty()) {
            try {
                sessionNo = Integer.parseInt(searchSession);
            } catch (NumberFormatException e) {
                sessionNo = null;
            }
        }

        List<QuizUserVO> list = quizService.getQuizAdminList(keyword, perfectScoreOnly, searchDate, sessionNo, cri);
        int total = quizService.getQuizAdminTotalCount(keyword, perfectScoreOnly, searchDate, sessionNo);

        // 최근 7일 접속자 통계 데이터 조회
        List<DailyStatsVO> visitStats = quizService.getQuizDailyVisitStats();

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total)); // 페이징 처리 객체
        model.addAttribute("cri", cri);
        model.addAttribute("visitStats", visitStats);
        model.addAttribute("keyword", keyword);
        model.addAttribute("perfectScoreOnly", perfectScoreOnly);
        model.addAttribute("searchDate", searchDate);
        model.addAttribute("searchSession", sessionNo);

        return "mng/quiz/list";
    }

    @GetMapping("/api/excelDownload")
    public void downloadExcel(@RequestParam(required = false) String keyword,
                              @RequestParam(required = false) String perfectScoreOnly,
                              @RequestParam(required = false) String searchDate,
                              @RequestParam(required = false) String searchSession,
                              HttpServletResponse response) throws Exception {

        Integer sessionNo = null;
        if (searchSession != null && !searchSession.trim().isEmpty()) {
            try { sessionNo = Integer.parseInt(searchSession); } catch (Exception e) {}
        }

        // 페이징 없이 조건에 맞는 전체 데이터 조회
        List<QuizUserVO> list = quizService.getQuizAdminListAll(keyword, perfectScoreOnly, searchDate, sessionNo);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("퀴즈 참여자 목록");

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
        String[] headers = {"이름", "연락처", "이메일", "방문 지역", "방문 전시장", "관심차량", "참여날짜", "회차", "점수", "상태", "기념품 수령"};

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        int rowNum = 1;

        // 고객 1명당 여러 회차 이력이 있을 수 있으므로 회차를 기준으로 행(Row) 생성
        for (QuizUserVO user : list) {
            if (user.getHistoryList() != null && !user.getHistoryList().isEmpty()) {
                for (QuizHistoryVO hist : user.getHistoryList()) {
                    Row row = sheet.createRow(rowNum++);

                    String scoreStr = "IN_PROGRESS".equals(hist.getStatus()) ? "진행중" : String.valueOf(hist.getScore());
                    String statusStr = "COMPLETED".equals(hist.getStatus()) ? "완료" : "진행중";

                    String[] rowData = {
                            user.getName(),
                            user.getPhone(),
                            user.getEmail() != null ? user.getEmail() : "",
                            user.getRegion() != null ? user.getRegion() : "",
                            user.getShopInfo() != null ? user.getShopInfo() : "",
                            user.getCarModelCode() != null ? user.getCarModelCode() : "",
                            hist.getPlayDate(),
                            hist.getSessionNo() + "회차",
                            scoreStr,
                            statusStr,
                            hist.getGiftReceivedYn() != null ? hist.getGiftReceivedYn() : "N"
                    };

                    for (int i = 0; i < rowData.length; i++) {
                        Cell cell = row.createCell(i);
                        cell.setCellValue(rowData[i]);
                        cell.setCellStyle(dataStyle);
                    }
                }
            }
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.setColumnWidth(i, 4000);
        }

        SimpleDateFormat fileDateFmt = new SimpleDateFormat("yyyyMMdd");
        String today = fileDateFmt.format(new java.util.Date());
        String fileName = "BYD_퀴즈참여자_" + today + ".xlsx";
        fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    @PostMapping("/api/toggleGift")
    @ResponseBody
    public Map<String, Object> toggleGift(@RequestParam("historySeq") int historySeq, @RequestParam("status") String status) {
        Map<String, Object> res = new HashMap<>();
        try {
            quizService.toggleGiftStatus(historySeq, status);
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "오류가 발생했습니다.");
        }
        return res;
    }

    @GetMapping("/question/list")
    public String questionList(Model model) {
        model.addAttribute("qList", quizService.getQuestionList());
        return "mng/quiz/question/list";
    }

    @GetMapping("/question/api/get")
    @ResponseBody
    public Map<String, Object> getQuestion(@RequestParam("questionId") int questionId) {
        Map<String, Object> res = new HashMap<>();
        try {
            res.put("success", true);
            res.put("data", quizService.getQuestionById(questionId));
        } catch (Exception e) {
            res.put("success", false);
        }
        return res;
    }

    @PostMapping("/question/api/save")
    @ResponseBody
    public Map<String, Object> saveQuestion(QuizQuestionVO question) {
        Map<String, Object> res = new HashMap<>();
        try {
            quizService.saveQuestion(question);
            res.put("success", true);
            res.put("message", "정상적으로 저장되었습니다.");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "저장 중 오류가 발생했습니다.");
        }
        return res;
    }

    @PostMapping("/question/api/delete")
    @ResponseBody
    public Map<String, Object> deleteQuestion(@RequestParam("questionId") int questionId) {
        Map<String, Object> res = new HashMap<>();
        try {
            quizService.deleteQuestion(questionId);
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "삭제 중 오류가 발생했습니다.");
        }
        return res;
    }
}