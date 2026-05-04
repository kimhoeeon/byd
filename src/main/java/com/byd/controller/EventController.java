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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Slf4j
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
        ParticipantVO existing = eventService.getParticipantByPhoneToday(phone);

        if (existing != null) {
            try {
                AES128 aes128 = new AES128(SECRET_KEY);
                String encryptedSeq = aes128.encrypt(String.valueOf(existing.getSeq()));
                return "redirect:/apply/ticket?token=" + encryptedSeq;
            } catch (Exception e) {
                log.error("중복 신청자 토큰 생성 오류: ", e);
                return "error/400";
            }
        } else {
            // 오늘 내역이 없으면(어제 신청했더라도) 신규 신청으로 간주
            ParticipantVO newInfo = new ParticipantVO();
            newInfo.setName(name);
            newInfo.setPhone(phone);
            session.setAttribute("tempInfo", newInfo);
            return "redirect:/apply/step2";
        }
    }

    // 시승 시간대별 마감 현황 조회 (Ajax용 API)
    @ResponseBody
    @GetMapping("/getDriveTimeStatus")
    public Map<String, Integer> getDriveTimeStatus() {
        return eventService.getDriveTimeCountToday();
    }

    // 시승 신청 2페이지 (상세 정보 입력)
    @GetMapping("/step2")
    public String step2(HttpSession session, Model model) {
        if (session.getAttribute("tempInfo") == null) return "redirect:/apply/step1";
        return "apply/step2";
    }

    // 최종 제출 처리
    @PostMapping("/applyProcess")
    public String applyProcess(ParticipantVO participantVO, HttpSession session, HttpServletRequest request, RedirectAttributes rttr) {
        ParticipantVO step1Info = (ParticipantVO) session.getAttribute("tempInfo");
        if (step1Info == null) {
            log.warn("세션 만료 또는 1단계 정보 누락으로 인한 비정상 접근");
            return "redirect:/apply/step1";
        }

        participantVO.setName(step1Info.getName());
        participantVO.setPhone(step1Info.getPhone());

        try {
            eventService.insertParticipant(participantVO);
        } catch (IllegalArgumentException e) {
            // 3일간 1회 참여 제한에 걸렸을 경우 사용자에게 알림
            log.warn("행사 기간 중 시승 신청 1회 초과: {}", participantVO.getPhone());
            rttr.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/apply/step2";
        } catch (IllegalStateException e) {
            log.warn("시승 시간 마감: {}", e.getMessage());
            rttr.addFlashAttribute("errorMsg", "선택하신 시간대는 인원이 마감되었습니다. 다른 시간을 선택해 주세요.");
            return "redirect:/apply/step2";
        } catch (DuplicateKeyException e) {
            log.warn("중복 시승 신청 감지 (DB Unique Key 방어): {}", participantVO.getPhone());
            ParticipantVO existing = eventService.getParticipantByPhoneToday(participantVO.getPhone());
            if (existing != null) {
                try {
                    AES128 aes128 = new AES128(SECRET_KEY);
                    String encryptedSeq = aes128.encrypt(String.valueOf(existing.getSeq()));
                    return "redirect:/apply/ticket?token=" + encryptedSeq;
                } catch (Exception ex) {
                    return "error/400";
                }
            }
            return "redirect:/apply/step1";
        } catch (Exception e) {
            log.error("신청 처리 중 예기치 않은 오류 발생: ", e);
            return "error/400";
        }

        session.removeAttribute("tempInfo"); // 세션 정리

        try {
            AES128 aes128 = new AES128(SECRET_KEY);
            String encryptedSeq = aes128.encrypt(String.valueOf(participantVO.getSeq()));

            String domain = "https://meetingtest.store"; // 실제 도메인으로 변경 필수
            String ticketUrl = domain + "/apply/ticket?token=" + encryptedSeq;

            eventService.sendAligoSms(participantVO.getPhone(), participantVO.getName(), ticketUrl);

        } catch (Exception e) {
            log.error("알림 발송 실패 (신청은 완료됨): ", e);
        }

        return "redirect:/apply/complete";
    }

    // 신규 추가: 마이페이지 정보 수정 프로세스 (AJAX 통신 용도)
    @PostMapping("/updateAjax")
    @ResponseBody
    public Map<String, Object> updateAjax(ParticipantVO participantVO) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (!"시승 미신청".equals(participantVO.getTestDriveTime())) {
                ParticipantVO existing = eventService.getParticipantBySeq(participantVO.getSeq());
                if (existing != null && !existing.getTestDriveTime().equals(participantVO.getTestDriveTime())) {
                    int count = eventService.getDriveTimeCount(participantVO.getTestDriveTime());
                    if (count >= 4) {
                        response.put("success", false);
                        response.put("message", "선택하신 시간대는 이미 마감되었습니다.");
                        return response;
                    }
                }
            }

            eventService.updateParticipant(participantVO);
            response.put("success", true);
            response.put("message", "정보가 성공적으로 수정되었습니다.");

        } catch (IllegalArgumentException e) {
            // 마이페이지에서 미신청 -> 시간 선택으로 수정할 때 1회 제한에 걸린 경우 차단
            log.warn("마이페이지 수정 중 1회 제한 초과 방어: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
        } catch (Exception e) {
            log.error("AJAX 정보 수정 중 오류 발생: ", e);
            response.put("success", false);
            response.put("message", "정보 수정 중 서버 오류가 발생했습니다.");
        }
        return response;
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

            // QR 인식률을 높이고 스캐너 로직과 맞추기 위해 전체 URL이 아닌 순수 토큰값만 삽입
            String qrCodeImgUrl = "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" + data.getQrCodeUrl();

            model.addAttribute("data", data);
            model.addAttribute("qrCodeImgUrl", qrCodeImgUrl);

        } catch (NumberFormatException e) {
            log.error("티켓 접근 오류 - 변조된 토큰(숫자 변환 실패): {}", token);
            return "error/400";
        } catch (Exception e) {
            log.error("티켓 접근 오류 - 잘못된 토큰: ", e);
            return "error/400";
        }

        return "apply/mypage";
    }
}