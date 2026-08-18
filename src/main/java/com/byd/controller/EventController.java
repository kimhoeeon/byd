package com.byd.controller;

import com.byd.service.EventService;
import com.byd.util.AES128;
import com.byd.vo.ParticipantVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/apply")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;
    private static final String SECRET_KEY = "bydEventTokenKey";

    @GetMapping("/step1")
    public String step1(HttpSession session) {
        session.removeAttribute("tempInfo");
        return "apply/step1";
    }

    // 1단계 이름/연락처 검증 및 중복 참여 체크 API
    @PostMapping("/checkParticipant")
    @ResponseBody
    public Map<String, Object> checkParticipant(@RequestParam("name") String name,
                                                @RequestParam("phone") String phone,
                                                @RequestParam("privacyAgree") String privacyAgree,
                                                HttpServletRequest request,
                                                HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String cleanPhone = phone.replaceAll("[^0-9]", "");

        try {
            ParticipantVO existing = eventService.getParticipantByPhoneToday(cleanPhone);
            if (existing != null) {
                // 이미 오늘 참여 완료한 유저는 마이페이지 티켓 확인 주소 발행
                AES128 aes128 = new AES128(SECRET_KEY);
                String encryptedSeq = aes128.encrypt(String.valueOf(existing.getSeq()));
                String baseUrl = request.getRequestURL().toString().replace(request.getRequestURI(), "");
                String redirectUrl = baseUrl + "/apply/ticket?token=" + URLEncoder.encode(encryptedSeq, "UTF-8");

                result.put("exists", true);
                result.put("redirectUrl", redirectUrl);
            } else {
                // 신규 유저는 임시 세션 생성 후 2단계 허용
                ParticipantVO temp = new ParticipantVO();
                temp.setName(name);
                temp.setPhone(cleanPhone);
                temp.setPrivacyAgree(privacyAgree);
                session.setAttribute("tempInfo", temp);
                result.put("exists", false);
            }
            result.put("error", false);
        } catch (Exception e) {
            result.put("error", true);
        }
        return result;
    }

    @GetMapping("/step2")
    public String step2(HttpSession session, Model model) {
        ParticipantVO temp = (ParticipantVO) session.getAttribute("tempInfo");
        if (temp == null) {
            return "redirect:/apply/step1";
        }
        model.addAttribute("tempInfo", temp);
        return "apply/step2";
    }

    // 2단계 최종 참여 신청 양식 등록 처리 (JSP의 전송 타깃 경로 매핑 보완)
    @PostMapping({"/submit", "/applyProcess"})
    public String submitParticipant(@ModelAttribute ParticipantVO participantVO,
                                    HttpSession session,
                                    HttpServletRequest request,
                                    RedirectAttributes redirectAttributes) {
        ParticipantVO temp = (ParticipantVO) session.getAttribute("tempInfo");
        if (temp == null) {
            return "redirect:/apply/step1";
        }

        participantVO.setName(temp.getName());
        participantVO.setPhone(temp.getPhone());
        participantVO.setPrivacyAgree(temp.getPrivacyAgree());

        try {
            eventService.insertParticipant(participantVO);
            session.removeAttribute("tempInfo");

            // 고유 식별용 암호화 토큰 링크 발행
            AES128 aes128 = new AES128(SECRET_KEY);
            String encryptedSeq = aes128.encrypt(String.valueOf(participantVO.getSeq()));

            String baseUrl = request.getRequestURL().toString().replace(request.getRequestURI(), "");
            String ticketUrl = baseUrl + "/apply/ticket?token=" + URLEncoder.encode(encryptedSeq, "UTF-8");

            // 알리고 문자 자동 발송
            eventService.sendNotificationSms(participantVO, ticketUrl);

            redirectAttributes.addFlashAttribute("applyCompleteFlag", true);
            return "redirect:/apply/complete";

        } catch (DuplicateKeyException de) {
            redirectAttributes.addFlashAttribute("errorMsg", "이미 오늘 날짜로 신청 완료된 연락처입니다.");
            return "redirect:/apply/step1";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "등록 중 에러가 발생했습니다. 다시 시도해 주세요.");
            return "redirect:/apply/step1";
        }
    }

    @GetMapping("/complete")
    public String complete(HttpServletRequest request, Model model) {
        Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
        if (flashMap == null || !flashMap.containsKey("applyCompleteFlag")) {
            return "redirect:/apply/step1";
        }
        return "apply/complete";
    }

    // 발송된 문자 링크 클릭 시 개인 모바일 티켓(QR)을 조회하는 전용 화면
    @GetMapping("/ticket")
    public String viewTicket(@RequestParam(value = "token", required = false) String token, Model model) {
        if (token == null || token.trim().isEmpty()) {
            return "redirect:/apply/step1";
        }

        try {
            if (token.contains("%")) {
                token = java.net.URLDecoder.decode(token, "UTF-8");
            }
            token = token.replace(" ", "+");

            AES128 aes128 = new AES128(SECRET_KEY);
            String decryptedSeqStr = aes128.decrypt(token);
            int seq = Integer.parseInt(decryptedSeqStr);

            ParticipantVO data = eventService.getParticipantBySeq(seq);
            if (data == null) {
                return "error/404";
            }

            // QR코드 내부에 주입할 URL 데이터 바인딩 주소 생성
            String qrCodeUrl = token;

            model.addAttribute("data", data);
            model.addAttribute("qrCodeImgUrl", "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" + URLEncoder.encode(qrCodeUrl, "UTF-8"));

            // 기존 스크립트 대응용 보완
            model.addAttribute("qrCodeUrl", qrCodeUrl);

            return "apply/mypage";

        } catch (Exception e) {
            return "redirect:/apply/step1";
        }
    }

    // mypage.jsp 내부 비동기 정보 수정 처리 핸들러 (시승 시간 검증부 제외)
    @PostMapping("/updateAjax")
    @ResponseBody
    public Map<String, Object> updateAjax(@ModelAttribute ParticipantVO participantVO) {
        Map<String, Object> result = new HashMap<>();
        try {
            ParticipantVO existing = eventService.getParticipantBySeq(participantVO.getSeq());
            if (existing == null) {
                result.put("success", false);
                result.put("message", "존재하지 않는 참여자 정보입니다.");
                return result;
            }

            // 변경 가능한 데이터 세팅
            existing.setEmail(participantVO.getEmail());
            existing.setShopInfo(participantVO.getShopInfo());
            existing.setCarModel(participantVO.getCarModel());
            existing.setMktAgree(participantVO.getMktAgree());

            eventService.updateParticipant(existing, false);

            result.put("success", true);
            result.put("message", "이벤트 참여 정보가 성공적으로 수정되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "정보 수정 중 오류가 발생했습니다.");
        }
        return result;
    }
}