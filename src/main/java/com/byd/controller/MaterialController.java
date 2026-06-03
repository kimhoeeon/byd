package com.byd.controller;
import com.byd.service.MaterialService;
import com.byd.vo.AdminVO;
import com.byd.vo.MaterialHistoryVO;
import com.byd.vo.MaterialVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mng/material")
@RequiredArgsConstructor
public class MaterialController {

    private final MaterialService materialService;

    // 물자 관리 리스트 화면 및 대시보드 데이터 전송
    @GetMapping("/list")
    public String materialList(@RequestParam(required = false) String searchDate,
                               @RequestParam(required = false) String category,
                               @RequestParam(required = false) String keyword,
                               @RequestParam(required = false) String stockStatus,
                               Model model) {

        if (searchDate == null || searchDate.isEmpty()) {
            searchDate = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }

        List<MaterialVO> list = materialService.getMaterialList(searchDate, category, keyword, stockStatus);
        List<String> categoryList = materialService.getCategoryList();

        // [수정] 대시보드 통계를 컨트롤러에서 직접 계산
        int totalItems = list.size();
        int totalInitAssets = 0;
        int totalCurrentAssets = 0;
        int todayTotalOut = 0;
        int safeStockItems = 0;
        int warnStockItems = 0;
        int dangerStockItems = 0;

        for (MaterialVO item : list) {
            totalInitAssets += item.getInitQty();
            totalCurrentAssets += item.getTotalQty();
            todayTotalOut += item.getTodayOutQty();

            int rate = item.getInitQty() > 0 ? (int) Math.round(((double) item.getTotalQty() / item.getInitQty()) * 100) : 0;
            if (rate <= 20) {
                dangerStockItems++;
            } else if (rate <= 50) {
                warnStockItems++;
            } else {
                safeStockItems++;
            }
        }

        int totalRate = totalInitAssets > 0 ? (int) Math.round(((double) totalCurrentAssets / totalInitAssets) * 100) : 0;

        model.addAttribute("list", list);
        model.addAttribute("categoryList", categoryList);
        model.addAttribute("searchDate", searchDate);
        model.addAttribute("category", category);
        model.addAttribute("keyword", keyword);
        model.addAttribute("stockStatus", stockStatus);

        // 계산된 통계값 JSP로 전달
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("totalInitAssets", totalInitAssets);
        model.addAttribute("totalCurrentAssets", totalCurrentAssets);
        model.addAttribute("todayTotalOut", todayTotalOut);
        model.addAttribute("safeStockItems", safeStockItems);
        model.addAttribute("warnStockItems", warnStockItems);
        model.addAttribute("dangerStockItems", dangerStockItems);
        model.addAttribute("totalRate", totalRate);

        return "mng/material/list";
    }

    // 신규 등록 API
    @PostMapping("/api/add")
    @ResponseBody
    public Map<String, Object> addMaterial(MaterialVO vo) {
        Map<String, Object> res = new HashMap<>();
        try {
            materialService.insertMaterial(vo);
            res.put("success", true);
            res.put("message", "물자가 성공적으로 등록되었습니다.");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "등록 중 오류가 발생했습니다.");
        }
        return res;
    }

    // [신규] 물자 마스터 수정 API
    @PostMapping("/api/edit")
    @ResponseBody
    public Map<String, Object> editMaterial(MaterialVO vo) {
        Map<String, Object> res = new HashMap<>();
        try {
            materialService.updateMaterial(vo);
            res.put("success", true);
            res.put("message", "물자 정보가 수정되었습니다.");
        } catch (IllegalArgumentException e) {
            res.put("success", false);
            res.put("message", e.getMessage()); // 마이너스 재고 경고 메시지 등
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "수정 중 오류가 발생했습니다.");
        }
        return res;
    }

    // 입출고 API
    @PostMapping("/api/inout")
    @ResponseBody
    public Map<String, Object> processInOut(MaterialHistoryVO vo, HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        try {
            AdminVO adminInfo = (AdminVO) session.getAttribute("adminInfo");
            vo.setAdminId(adminInfo != null ? adminInfo.getAdminName() : "System");

            materialService.processInOut(vo);
            res.put("success", true);
            res.put("message", ("IN".equals(vo.getChangeType()) ? "입고" : "출고") + " 처리가 완료되었습니다.");
        } catch (IllegalArgumentException e) {
            res.put("success", false);
            res.put("message", e.getMessage());
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "처리 중 오류가 발생했습니다.");
        }
        return res;
    }

    // 타임라인 이력 API
    @GetMapping("/api/history")
    @ResponseBody
    public List<MaterialHistoryVO> getHistory(@RequestParam("materialSeq") int materialSeq) {
        return materialService.getHistoryList(materialSeq);
    }

    // 삭제 API
    @PostMapping("/api/delete")
    @ResponseBody
    public Map<String, Object> deleteMaterial(@RequestParam("seq") int seq) {
        Map<String, Object> res = new HashMap<>();
        try {
            materialService.deleteMaterial(seq);
            res.put("success", true);
            res.put("message", "삭제가 완료되었습니다.");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "삭제 중 오류가 발생했습니다.");
        }
        return res;
    }
}