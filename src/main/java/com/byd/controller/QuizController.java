package com.byd.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/quiz")
public class QuizController {

    // 1. 퀴즈 메인 페이지 (quiz_main.html)
    @GetMapping("/main")
    public String mainPage(HttpSession session) {
        // 기존 퀴즈 세션 정보가 있다면 초기화
        session.removeAttribute("quizUserInfo");
        return "quiz/main";
    }

    // 2. 정보 입력 1단계 (apply_01.html)
    @GetMapping("/step1")
    public String step1() {
        return "quiz/step1"; // WEB-INF/views/quiz/step1.jsp
    }

    // 3. 정보 입력 2단계 (apply_02.html) - step1에서 POST로 넘어온 데이터 수신
    @PostMapping("/step2")
    public String step2(
            @RequestParam("name") String name,
            @RequestParam("phone") String phone,
            @RequestParam("privacyAgree") String privacyAgree,
            org.springframework.ui.Model model) {

        // step2.jsp에서 사용할 수 있도록 Model에 담아 전달
        model.addAttribute("name", name);
        model.addAttribute("phone", phone);
        model.addAttribute("privacyAgree", privacyAgree);

        return "quiz/step2";
    }

    // (방어 로직) URL창에 직접 /quiz/step2 를 치고 들어오면 step1으로 튕겨냄
    @GetMapping("/step2")
    public String step2Redirect() {
        return "redirect:/quiz/step1";
    }

    // 4. 퀴즈 진행 페이지 (quiz.html)
    @GetMapping("/play")
    public String play() {
        return "quiz/play";
    }

    // 5. 퀴즈 결과 페이지 (end.html)
    @GetMapping("/result")
    public String result() {
        return "quiz/result";
    }
}