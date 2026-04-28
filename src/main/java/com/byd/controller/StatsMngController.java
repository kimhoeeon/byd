package com.byd.controller;

import com.byd.service.StatsMngService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mng/stats")
@RequiredArgsConstructor
public class StatsMngController {

    private final StatsMngService statsMngService;

    // 직관 랭킹 페이지
    @GetMapping("/ranking")
    public String rankingList(Model model) {
        model.addAttribute("list", statsMngService.getRankingList());
        return "mng/stats/ranking_list";
    }
}