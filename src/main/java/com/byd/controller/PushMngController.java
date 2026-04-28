package com.byd.controller;

import com.byd.service.PushMngService;
import com.byd.vo.PushLogVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mng/system/push")
@RequiredArgsConstructor
public class PushMngController {

    private final PushMngService pushMngService;

    // 목록 및 발송 페이지
    @GetMapping("/list")
    public String listPage(Model model) {
        model.addAttribute("list", pushMngService.getPushLogList());
        return "mng/system/push_list";
    }

    // 발송 처리
    @PostMapping("/send")
    public String sendAction(PushLogVO vo) {
        pushMngService.sendPush(vo);
        return "redirect:/mng/system/push/list";
    }
}