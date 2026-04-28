package com.byd.controller;

import com.byd.service.SystemMngService;
import com.byd.vo.TermsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/policy")
@RequiredArgsConstructor
public class PolicyController {

    private final SystemMngService systemMngService;

    // 이용약관 (SERVICE)
    @GetMapping("/terms")
    public String terms(Model model) {
        TermsVO vo = systemMngService.getLatestTermsByType("SERVICE");
        model.addAttribute("term", vo);
        return "policy/terms";
    }

    // 개인정보처리방침 (PRIVACY)
    @GetMapping("/privacy")
    public String privacy(Model model) {
        TermsVO vo = systemMngService.getLatestTermsByType("PRIVACY");
        model.addAttribute("term", vo);
        return "policy/privacy";
    }

    // 위치정보 이용약관 (LOCATION)
    @GetMapping("/location")
    public String location(Model model) {
        TermsVO vo = systemMngService.getLatestTermsByType("LOCATION");
        model.addAttribute("term", vo);
        return "policy/location";
    }
}