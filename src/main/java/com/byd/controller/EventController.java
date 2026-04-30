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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
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
        // "오늘" 신청된 시간대별 카운트를 DB에서 조회하여 Map으로 반환
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
    public String applyProcess(ParticipantVO participantVO, HttpSession session, HttpServletRequest request) {
        ParticipantVO step1Info = (ParticipantVO) session.getAttribute("tempInfo");
        if (step1Info == null) {
            log.warn("세션 만료 또는 1단계 정보 누락으로 인한 비정상 접근");
            return "redirect:/apply/step1";
        }

        participantVO.setName(step1Info.getName());
        participantVO.setPhone(step1Info.getPhone());

        try {
            eventService.insertParticipant(participantVO);
        } catch (DuplicateKeyException e) {
            // [방어 로직 수정] 1단계 검증과 동일하게 '오늘' 중복 신청 여부 기준으로 조회
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

            String domain = "https://your-byd-domain.com"; // 실제 도메인으로 변경 필수
            String ticketUrl = domain + "/apply/ticket?token=" + encryptedSeq;

            eventService.sendAligoSms(participantVO.getPhone(), participantVO.getName(), ticketUrl);

        } catch (Exception e) {
            log.error("알림 발송 실패 (신청은 완료됨): ", e);
        }

        return "redirect:/apply/complete";
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