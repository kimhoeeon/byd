package com.byd.controller;

import com.byd.service.DiaryService;
import com.byd.vo.DiaryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/share")
@RequiredArgsConstructor
public class ShareController {

    private final DiaryService diaryService;

    // 공유된 일기 보기 (로그인 불필요)
    @GetMapping("/diary/{uuid}")
    public String sharedDiaryView(@PathVariable String uuid, Model model) {
        DiaryVO diary = diaryService.getSharedDiary(uuid);

        // 1. 일기가 없거나 삭제된 경우
        if (diary == null) {
            model.addAttribute("errorMsg", "삭제되었거나 존재하지 않는 일기입니다.");
            return "diary/diary_share_error"; // 에러 페이지 (별도 생성 필요)
        }

        // 2. 비공개 일기인 경우 (작성자가 나만 보기로 변경했을 때)
        if ("PRIVATE".equals(diary.getIsPublic())) {
            model.addAttribute("errorMsg", "비공개 처리된 일기입니다.");
            return "diary/diary_share_error";
        }

        model.addAttribute("diary", diary);
        return "diary/diary_share"; // 비회원용 공유 페이지
    }
}