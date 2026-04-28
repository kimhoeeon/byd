package com.byd.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.byd.service.ContentMngService;
import com.byd.service.LockerService;
import com.byd.util.FileUtil;
import com.byd.vo.EventVO;
import com.byd.vo.TeamContentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/mng/content")
@RequiredArgsConstructor
public class ContentMngController {

    private final ContentMngService contentService;
    private final LockerService lockerService;

    // ==========================================
    // 1. 이벤트 관리
    // ==========================================

    // 목록 페이지
    @GetMapping("/events")
    public String eventList(Model model) {
        List<EventVO> events = contentService.getEventList();
        model.addAttribute("events", events);
        return "mng/content/event_list";
    }

    // 이벤트 상세 페이지
    @GetMapping("/events/detail")
    public String eventDetail(@RequestParam("eventId") Long eventId, Model model) {
        if (eventId != null) {
            EventVO event = contentService.getEvent(eventId);
            model.addAttribute("event", event);
        }
        return "mng/content/event_detail";
    }

    // 단건 조회 (수정 팝업용 AJAX)
    @GetMapping("/events/get")
    @ResponseBody
    public EventVO getEvent(@RequestParam("eventId") Long eventId) {
        return contentService.getEvent(eventId);
    }

    // 등록 및 수정 처리
    @PostMapping("/events/save")
    public String eventSave(EventVO event,
                            @RequestParam(value = "file", required = false) MultipartFile file) {

        // 1. 파일 업로드 처리 (단일 파일)
        if (file != null && !file.isEmpty()) {
            try {
                String savedUrl = FileUtil.uploadFile(file, "event");
                event.setImageUrl(savedUrl);
            } catch (Exception e) {
                log.error("이벤트 썸네일 업로드 실패", e);
            }
        }

        // 2. 서비스 호출
        if (event.getEventId() == null) {
            contentService.insertEvent(event);
        } else {
            contentService.updateEvent(event);
        }

        return "redirect:/mng/content/events";
    }

    // 삭제 처리 (AJAX)
    @PostMapping("/events/delete")
    @ResponseBody
    public String eventDelete(@RequestParam("eventId") Long eventId) {
        try {
            contentService.deleteEvent(eventId);
            return "ok";
        } catch (Exception e) {
            log.error("이벤트 삭제 실패", e);
            return "fail";
        }
    }

    // ==========================================
    // 2. 구단 콘텐츠 관리
    // ==========================================

    // 목록 페이지 (필터 적용)
    @GetMapping("/teams")
    public String teamList(Model model, @RequestParam(value = "teamCode", required = false) String teamCode) {
        List<TeamContentVO> list = contentService.getTeamContentList(teamCode);
        model.addAttribute("list", list);
        model.addAttribute("paramTeamCode", teamCode);
        return "mng/content/team_list";
    }

    // 상세/수정 페이지 (통계 포함)
    @GetMapping("/teams/detail")
    public String teamDetail(@RequestParam("contentId") Long contentId, Model model) {
        TeamContentVO content = contentService.getTeamContent(contentId);
        model.addAttribute("content", content);

        // 관리자 화면에 노출할 댓글 목록 가져오기
        model.addAttribute("comments", lockerService.getContentComments(contentId));

        // 통계 데이터 조회 및 JSON 변환
        Map<String, Object> stats = contentService.getStats(contentId);
        try {
            model.addAttribute("statsJson", new ObjectMapper().writeValueAsString(stats)); // Jackson 필요
        } catch (JsonProcessingException e) {
            log.error("통계 데이터 JSON 변환 실패", e);
            model.addAttribute("statsJson", "{}");
        }

        return "mng/content/team_detail";
    }

    // 관리자 전용 콘텐츠 댓글 삭제 기능
    @PostMapping("/teams/comment/delete")
    @ResponseBody
    public String deleteTeamContentComment(@RequestParam("commentId") Long commentId) {
        try {
            contentService.deleteContentCommentByAdmin(commentId);
            return "ok";
        } catch (Exception e) {
            log.error("관리자 콘텐츠 댓글 삭제 실패", e);
            return "fail";
        }
    }

    // URL 메타데이터(썸네일) 추출 API
    @GetMapping("/teams/meta")
    @ResponseBody
    public String extractUrlMeta(@RequestParam("url") String url) {
        return contentService.extractOgImage(url);
    }

    // 저장
    @PostMapping("/teams/save")
    @ResponseBody
    public String teamContentSave(TeamContentVO content, @RequestParam(value = "file", required = false) MultipartFile file) {
        try {
            contentService.saveTeamContent(content, file);
            return "ok"; // 성공 시 ok 반환
        } catch (Exception e) {
            log.error("팀 콘텐츠 저장 실패", e);
            return "fail"; // 실패 시 fail 반환
        }
    }

    // 삭제 처리 (AJAX)
    @PostMapping("/teams/delete")
    @ResponseBody
    public String teamContentDelete(@RequestParam("contentId") Long contentId) {
        try {
            contentService.deleteTeamContent(contentId);
            return "ok";
        } catch (Exception e) {
            log.error("팀 콘텐츠 삭제 실패", e);
            return "fail";
        }
    }

    // 순서 변경 (AJAX)
    @PostMapping("/teams/reorder")
    @ResponseBody
    public String changeOrder(@RequestParam("contentId") Long contentId,
                              @RequestParam("direction") String direction) {
        try {
            contentService.changeSortOrder(contentId, direction);
            return "ok";
        } catch (Exception e) {
            log.error("순서 변경 실패", e);
            return "fail";
        }
    }

    // 단건 조회 (수정 팝업용 AJAX)
    @GetMapping("/teams/get")
    @ResponseBody
    public TeamContentVO getTeamContent(@RequestParam("contentId") Long contentId) {
        return contentService.getTeamContent(contentId);
    }

}