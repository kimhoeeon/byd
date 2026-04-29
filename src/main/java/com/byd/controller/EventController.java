package com.byd.controller;

import com.byd.service.EventService;
import com.byd.util.AES128;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/apply")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;

    private static final String SECRET_KEY = "bydEventTokenKey";

    // 시승 신청 1페이지 (이름, 연락처 입력)
    @GetMapping("/step1")
    public String step1(HttpSession session) {
        session.removeAttribute("tempInfo");
        return "apply/step1";
    }

    // 1페이지 제출 시 기존 정보 확인 및 분기 처리
    @PostMapping("/checkParticipant")
    public String checkParticipant(@RequestParam String name, @RequestParam String phone, HttpSession session, Model model) {
        ParticipantVO existing = eventService.getParticipantByPhone(phone);

        if (existing != null) {
            // 기존 신청자 -> 암호화 토큰 생성 후 티켓 페이지로 리다이렉트
            try {
                AES128 aes128 = new AES128(SECRET_KEY);
                String encryptedSeq = aes128.encrypt(String.valueOf(existing.getSeq()));
                return "redirect:/apply/ticket?token=" + encryptedSeq;
            } catch (Exception e) {
                e.printStackTrace();
                return "error/400";
            }
        } else {
            // 신규 신청자 -> 2페이지
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
        if (session.getAttribute("tempInfo") == null) return "redirect:/apply/step1";
        return "apply/step2";
    }

    // 최종 제출 처리
    @PostMapping("/applyProcess")
    public String applyProcess(ParticipantVO participantVO, HttpSession session, HttpServletRequest request) {
        ParticipantVO step1Info = (ParticipantVO) session.getAttribute("tempInfo");
        if (step1Info != null) {
            participantVO.setName(step1Info.getName());
            participantVO.setPhone(step1Info.getPhone());
        }

        eventService.insertParticipant(participantVO);
        session.removeAttribute("tempInfo"); // 세션 정리

        try {
            // 2. seq 암호화 (AES128)
            AES128 aes128 = new AES128(SECRET_KEY);
            String encryptedSeq = aes128.encrypt(String.valueOf(participantVO.getSeq()));

            // 3. 모바일 티켓 URL 생성 (도메인은 실제 서비스 도메인으로 변경)
            String domain = "https://your-byd-domain.com";
            String ticketUrl = domain + "/apply/ticket?token=" + encryptedSeq;

            // 4. SMS 전송
            eventService.sendAligoSms(participantVO.getPhone(), participantVO.getName(), ticketUrl);

        } catch (Exception e) {
            e.printStackTrace();
            // 에러 로깅 처리 (문자 발송 실패해도 신청 완료 페이지로는 넘어가야 함)
        }

        return "redirect:/apply/complete"; // 리다이렉트로 변경
    }

    // 3. 완료 페이지 매핑 추가
    @GetMapping("/complete")
    public String completePage() {
        return "apply/complete";
    }

    // 모바일 티켓 (문자 링크 클릭 시 접속)
    @GetMapping("/ticket")
    public String mobileTicket(@RequestParam("token") String token, Model model) {
        try {
            // 1. 토큰 복호화
            AES128 aes128 = new AES128(SECRET_KEY);
            String decryptedSeqStr = aes128.decrypt(token);
            int seq = Integer.parseInt(decryptedSeqStr);

            // 2. DB 정보 조회
            ParticipantVO data = eventService.getParticipantBySeq(seq);

            if (data == null) {
                return "error/404"; // 없는 정보일 경우 에러페이지
            }

            // 3. 관리자 태블릿에서 스캔 시 호출할 Check-in URL 세팅 (QR코드에 들어갈 내용)
            String domain = "https://your-byd-domain.com";
            String qrContentUrl = domain + "/mng/api/checkArrival?seq=" + seq;

            // 구글 차트 API를 이용한 QR 이미지 URL 생성
            String qrCodeImgUrl = "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" + qrContentUrl;

            model.addAttribute("data", data);
            model.addAttribute("qrCodeImgUrl", qrCodeImgUrl);

        } catch (Exception e) {
            e.printStackTrace();
            return "error/400"; // 비정상적인 토큰 접근 시
        }

        // 기존 mypage.jsp를 티켓 화면으로 재활용
        return "apply/mypage";
    }
}