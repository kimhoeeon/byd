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

    // 물자 관리 리스트 화면
    @GetMapping("/list")
    public String materialList(@RequestParam(required = false) String searchDate,
                               @RequestParam(required = false) String category,
                               @RequestParam(required = false) String keyword,
                               @RequestParam(required = false) String stockStatus,
                               Model model) {

        // 날짜 선택이 없으면 오늘 날짜로 기본 세팅 (금일 불출량 조회를 위함)
        if (searchDate == null || searchDate.isEmpty()) {
            searchDate = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }

        List<MaterialVO> list = materialService.getMaterialList(searchDate, category, keyword, stockStatus);
        List<String> categoryList = materialService.getCategoryList();

        model.addAttribute("list", list);
        model.addAttribute("categoryList", categoryList);
        model.addAttribute("searchDate", searchDate);
        model.addAttribute("category", category);
        model.addAttribute("keyword", keyword);
        model.addAttribute("stockStatus", stockStatus);

        return "mng/material/list";
    }

    // 신규 물자 등록 API
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

    // 입출고 처리 API
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

    // 타임라인 이력 조회 API
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
            res.put("message", "삭제되었습니다.");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "오류가 발생했습니다.");
        }
        return res;
    }
}