package com.byd.controller;

import com.byd.service.QuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
@RequestMapping("/quiz")
public class QuizController {

    private final QuizService quizService;

    // 1. 정보 입력 1단계 진입
    @GetMapping("/step1")
    public String step1(HttpSession session) {
        session.removeAttribute("quizUserInfo");
        try {
            quizService.recordVisit();
        } catch(Exception e) {
            e.printStackTrace();
        }
        return "quiz/step1";
    }

    // 2. 정보 입력 2단계 진입
    @PostMapping("/step2")
    public String step2(
            @RequestParam("name") String name,
            @RequestParam("phone") String phone,
            @RequestParam("privacyAgree") String privacyAgree,
            Model model) {

        model.addAttribute("name", name);
        model.addAttribute("phone", phone);
        model.addAttribute("privacyAgree", privacyAgree);

        return "quiz/step2";
    }

    @GetMapping("/step2")
    public String step2Redirect() {
        return "redirect:/quiz/step1";
    }

    // 3. 사용자가 단독으로 개인 퀴즈를 진행하는 플레이 화면
    @GetMapping("/play")
    public String play() {
        return "quiz/play";
    }

    // 4. 결과 및 당첨용 경품 QR 출력 화면
    @GetMapping("/result")
    public String result() {
        return "quiz/result";
    }

    /*@GetMapping("/host/main")
    public String hostMain() {
        return "quiz/host/main";
    }

    @GetMapping("/host/quest")
    public String hostQuiz() {
        return "quiz/host/quest";
    }

    @GetMapping("/host/perfect")
    public String hostPerfect() {
        return "quiz/host/perfect";
    }

    @GetMapping("/host/end")
    public String hostEnd() {
        return "quiz/host/end";
    }*/
}