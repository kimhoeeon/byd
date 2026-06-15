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

    // 2. 정보 입력 1단계
    @GetMapping("/step1")
    public String step1(HttpSession session) {
        // 기존 퀴즈 세션 정보가 있다면 초기화
        session.removeAttribute("quizUserInfo");

        // step1 화면 진입 시 카운트 증가
        try {
            quizService.recordVisit();
        } catch(Exception e) {
            // DB 에러가 나더라도 유저의 퀴즈 진입은 막지 않도록 예외 처리
            e.printStackTrace();
        }

        return "quiz/step1";
    }

    // 3. 정보 입력 2단계
    @PostMapping("/step2")
    public String step2(
            @RequestParam("name") String name,
            @RequestParam("phone") String phone,
            @RequestParam("privacyAgree") String privacyAgree,
            Model model) {

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

    // 4. 퀴즈 진행 페이지
    @GetMapping("/play")
    public String play() {
        return "quiz/play";
    }

    // 5. 퀴즈 결과 페이지
    @GetMapping("/result")
    public String result() {
        return "quiz/result";
    }

    @GetMapping("/host/main")
    public String hostMain() {
        return "quiz/host/main";
    }

    @GetMapping("/host/quest")
    public String hostQuiz() {
        return "quiz/host/quest";
    }

    @GetMapping("/host/end")
    public String hostEnd() {
        return "quiz/host/end";
    }
}