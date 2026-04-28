package com.byd.controller;

import com.byd.service.DiaryMngService;
import com.byd.vo.Criteria;
import com.byd.vo.DiaryVO;
import com.byd.dto.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mng/diary")
@RequiredArgsConstructor
public class DiaryMngController {

    private final DiaryMngService diaryMngService;

    // 목록 (검색 + 페이징)
    @GetMapping("/list")
    public String listPage(Model model, Criteria cri) {
        List<DiaryVO> list = diaryMngService.getDiaryList(cri);
        int total = diaryMngService.getTotal(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total));

        return "mng/diary/diary_list";
    }

    // 상세
    @GetMapping("/detail")
    public String detailPage(@RequestParam("diaryId") Long diaryId,
                             @ModelAttribute("cri") Criteria cri,
                             Model model) {
        DiaryVO diary = diaryMngService.getDiary(diaryId);
        if (diary == null) return "redirect:/mng/diary/list";

        model.addAttribute("diary", diary);
        return "mng/diary/diary_detail";
    }

    // 블라인드 처리 (AJAX)
    @PostMapping("/blind")
    @ResponseBody
    public String blindAction(@RequestParam("diaryId") Long diaryId) {
        try {
            diaryMngService.blindDiary(diaryId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    // 삭제 (AJAX)
    @PostMapping("/delete")
    @ResponseBody
    public String deleteAction(@RequestParam("diaryId") Long diaryId) {
        try {
            diaryMngService.deleteDiary(diaryId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    // 인기 게시물 상태 변경 (AJAX)
    @PostMapping("/popular/toggle")
    @ResponseBody
    public Map<String, Object> togglePopularStatus(@RequestParam("diaryId") Long diaryId,
                                                   @RequestParam("currentStatus") String currentStatus) {
        Map<String, Object> response = new HashMap<>();
        try {
            String targetStatus = "Y".equals(currentStatus) ? "N" : "Y";

            // 인기 게시물로 지정('Y')하려는 경우에만 개수 체크
            if ("Y".equals(targetStatus)) {

                // 해당 일기가 '전체 공개(PUBLIC)'인지 먼저 확인
                DiaryVO diary = diaryMngService.getDiary(diaryId);
                if (!"PUBLIC".equals(diary.getIsPublic()) || !"COMPLETED".equals(diary.getStatus())) {
                    response.put("result", "FAIL");
                    response.put("message", "전체 공개 및 정상 등록된 일기만 인기 게시물로 선정할 수 있습니다.");
                    return response;
                }

                int count = diaryMngService.getPopularDiaryCount();
                if (count >= 4) {
                    response.put("result", "FAIL");
                    response.put("message", "인기 게시물 지정은 최대 4개까지 가능합니다. 취소 후 다시 시도해 주세요");
                    return response;
                }
            }

            diaryMngService.updatePopularStatus(diaryId, targetStatus);
            response.put("result", "SUCCESS");
            response.put("message", "변경되었습니다.");
        } catch (Exception e) {
            response.put("result", "ERROR");
            response.put("message", "서버 통신 중 오류가 발생했습니다.");
        }
        return response;
    }
}