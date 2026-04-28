package com.byd.controller;

import com.byd.dto.WinYoAnalysisDTO;
import com.byd.exception.AlertException;
import com.byd.service.DiaryMngService;
import com.byd.service.MemberMngService;
import com.byd.service.WinYoService;
import com.byd.vo.Criteria;
import com.byd.vo.DiaryVO;
import com.byd.vo.MemberVO;
import com.byd.dto.PageDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/members")
@RequiredArgsConstructor
public class MemberMngController {

    private final MemberMngService memberMngService;
    private final DiaryMngService diaryMngService;
    private final WinYoService winYoService;

    // 목록 페이지 (페이징 + 검색)
    @GetMapping("/list")
    public String listPage(Model model, Criteria cri) {

        // 1. 목록 데이터 조회
        List<MemberVO> list = memberMngService.getMemberList(cri);

        // 2. 전체 데이터 개수 조회 (페이징 계산용)
        int total = memberMngService.getTotal(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total)); // 페이징 정보 전달

        return "mng/member/member_list";
    }

    // 상세 페이지 (기존 유지)
    @GetMapping("/detail")
    public String detailPage(@RequestParam("memberId") Long memberId,
                             @ModelAttribute("cri") Criteria cri, // 목록으로 돌아갈 때 정보 유지를 위해 받음
                             Model model) {
        MemberVO member = memberMngService.getMember(memberId);
        if (member == null) return "redirect:/mng/members/list";

        List<DiaryVO> diaries = diaryMngService.getMemberDiaryHistory(memberId);

        WinYoAnalysisDTO winYo = winYoService.analyzeWinYoPower(memberId);

        model.addAttribute("member", member);
        model.addAttribute("diaries", diaries); // 이력 데이터 전달
        model.addAttribute("winYo", winYo);

        return "mng/member/member_detail";
    }

    // 상태 변경 (기존 유지)
    @PostMapping("/updateStatus")
    @ResponseBody
    public String updateStatus(@RequestParam("memberId") Long memberId,
                               @RequestParam("status") String status) {
        try {
            memberMngService.updateStatus(memberId, status);
            return "ok";
        } catch (Exception e) {
            log.error(">>> 회원 상태 변경 중 시스템 오류 발생 (memberId={})", memberId, e);
            return "fail";
        }
    }

    // 비밀번호 초기화 (AJAX)
    @PostMapping("/resetPassword")
    @ResponseBody
    public String resetPassword(@RequestParam("memberId") Long memberId) {
        try {
            return memberMngService.resetPassword(memberId);
        } catch (Exception e) {
            return "fail";
        }
    }

    // 관리자: 회원 닉네임 및 연락처 수정
    @PostMapping("/updateInfo")
    @ResponseBody
    public String updateAdminInfo(MemberVO member) {
        try {
            memberMngService.updateAdminMemberInfo(member);
            return "ok";
        } catch (AlertException ae) {
            log.info("회원 닉네임 및 연락처 수정 알럿: {}", ae.getMessage());
            return ae.getMessage();
        } catch (Exception e) {
            log.error("회원 닉네임 및 연락처 수정 중 시스템 오류", e);
            return "fail";
        }
    }

    // 회원 목록 엑셀 다운로드
    @GetMapping("/excel")
    public void downloadExcel(HttpServletResponse response) throws Exception {
        memberMngService.downloadExcel(response);
    }

}