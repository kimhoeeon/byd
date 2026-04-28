package com.byd.controller;

import com.byd.service.EventService;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/apply")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;

    // 시승 신청 1페이지 (이름, 연락처 입력)
    @GetMapping("/step1")
    public String step1() {
        return "apply/step1";
    }

    // 1페이지 제출 시 기존 정보 확인 및 분기 처리
    @PostMapping("/checkParticipant")
    public String checkParticipant(@RequestParam String name, @RequestParam String phone, HttpSession session, Model model) {
        ParticipantVO existing = eventService.getParticipantByPhone(phone);

        if (existing != null) {
            // 기존 정보가 있는 경우 -> 마이페이지로 이동
            model.addAttribute("data", existing);
            return "apply/mypage";
        } else {
            // 신규 신청인 경우 -> 2페이지로 이동 (1페이지 정보 세션 보관)
            ParticipantVO newInfo = new ParticipantVO();
            newInfo.setName(name);
            newInfo.setPhone(phone);
            session.setAttribute("tempInfo", newInfo);
            return "redirect:/apply/step2";
        }
    }

    // 시승 신청 2페이지 (상세 정보 입력)
    @GetMapping("/step2")
    public String step2(HttpSession session, Model model) {
        if (session.getAttribute("tempInfo") == null) return "redirect:/step1";
        return "apply/step2";
    }

    // 최종 제출 처리
    @PostMapping("/applyProcess")
    public String applyProcess(ParticipantVO participantVO, HttpSession session) {
        ParticipantVO step1Info = (ParticipantVO) session.getAttribute("tempInfo");
        if (step1Info != null) {
            participantVO.setName(step1Info.getName());
            participantVO.setPhone(step1Info.getPhone());
        }

        eventService.insertParticipant(participantVO);
        session.removeAttribute("tempInfo"); // 세션 정리
        return "apply/complete";
    }

}