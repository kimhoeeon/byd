package com.byd.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/timer")
@RequiredArgsConstructor
public class TimerController {

    // 타이머 화면 라우팅
    @GetMapping("")
    public String timerPage() {
        return "timer";
    }

}