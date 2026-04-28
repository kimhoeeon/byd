package com.byd.controller;

import com.byd.service.WinYoMngService;
import com.byd.vo.WinYoMentionVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/winyo")
@RequiredArgsConstructor
public class WinYoMngController {

    private final WinYoMngService winYoMngService;

    // 목록 페이지
    @GetMapping("/mentions")
    public String mentionList(
            @RequestParam(value = "filterCategory", required = false) String filterCategory,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "searchWord", required = false) String searchWord,
            Model model) {

        List<WinYoMentionVO> list = winYoMngService.getMentionList(filterCategory, searchType, searchWord);

        model.addAttribute("list", list);
        model.addAttribute("filterCategory", filterCategory);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);

        return "mng/winyo/mention_list";
    }

    // 상세 페이지 이동
    @GetMapping("/mention/detail")
    public String detailPage(@RequestParam("mentionId") Long mentionId, Model model) {
        WinYoMentionVO mention = winYoMngService.getMention(mentionId);
        if (mention == null) return "redirect:/mng/winyo/mentions";

        model.addAttribute("mention", mention);
        return "mng/winyo/mention_detail";
    }

    @PostMapping("/mention/update")
    @ResponseBody
    public String updateMentionAction(@ModelAttribute WinYoMentionVO mention) {
        try {
            winYoMngService.modifyMention(mention);
            return "ok";
        } catch (Exception e) {
            log.error("멘트 수정 중 오류", e);
            return "fail";
        }
    }
}