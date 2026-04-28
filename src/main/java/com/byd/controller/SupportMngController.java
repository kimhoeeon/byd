package com.byd.controller;

import com.byd.service.SupportMngService;
import com.byd.vo.Criteria;
import com.byd.vo.FaqVO;
import com.byd.vo.InquiryVO;
import com.byd.dto.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/mng/support")
@RequiredArgsConstructor
public class SupportMngController {

    private final SupportMngService supportService;

    // --- FAQ 관리 ---
    @GetMapping("/faq/list")
    public String faqList(Model model) {
        model.addAttribute("list", supportService.getFaqList());
        return "mng/support/faq_list";
    }

    // 상세/수정용 데이터 (AJAX)
    @GetMapping("/faq/get")
    @ResponseBody
    public FaqVO getFaq(@RequestParam("faqId") Long faqId) {
        return supportService.getFaq(faqId);
    }

    @PostMapping("/faq/save")
    public String faqSave(FaqVO vo) {
        supportService.saveFaq(vo);
        return "redirect:/mng/support/faq/list";
    }

    @PostMapping("/faq/delete")
    @ResponseBody
    public String faqDelete(@RequestParam("faqId") Long faqId) {
        try {
            supportService.deleteFaq(faqId);
            return "ok";
        } catch(Exception e) { return "fail"; }
    }

    // --- 1:1 문의 관리 ---

    // 목록
    @GetMapping("/inquiry/list")
    public String inquiryList(Model model, Criteria cri) {
        // 기본 정렬: 답변 대기중인 것을 찾기 쉽게
        if(cri.getStatus() == null) cri.setStatus("");

        List<InquiryVO> list = supportService.getInquiryList(cri);
        int total = supportService.getInquiryTotal(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total));

        return "mng/support/inquiry_list";
    }

    // 상세
    @GetMapping("/inquiry/detail")
    public String inquiryDetail(@RequestParam("inquiryId") Long inquiryId,
                                @ModelAttribute("cri") Criteria cri,
                                Model model) {
        InquiryVO inquiry = supportService.getInquiry(inquiryId);
        if (inquiry == null) return "redirect:/mng/support/inquiry/list";

        model.addAttribute("inquiry", inquiry);
        return "mng/support/inquiry_detail";
    }

    // 답변 등록
    @PostMapping("/inquiry/answer")
    public String inquiryAnswer(InquiryVO vo, Criteria cri) {
        supportService.answerInquiry(vo);

        // 목록으로 돌아가거나 상세페이지 유지
        return "redirect:/mng/support/inquiry/detail?inquiryId=" + vo.getInquiryId()
                + "&pageNum=" + cri.getPageNum() + "&keyword=" + cri.getKeyword() + "&status=" + cri.getStatus();
    }

}