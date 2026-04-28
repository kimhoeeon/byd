package com.byd.controller;

import com.byd.dto.ResponseDTO;
import com.byd.dto.WinYoAnalysisDTO;
import com.byd.service.*;
import com.byd.vo.*;
import com.byd.service.*;
import com.byd.util.StringUtil;
import com.byd.vo.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.jsoup.Jsoup.connect;

@Slf4j
@Controller
@RequestMapping("/locker")
@RequiredArgsConstructor
public class LockerController {

    private final LockerService lockerService;
    private final ContentMngService contentMngService; // 이벤트/구단콘텐츠
    private final SystemMngService systemMngService; // 공지사항

    private final WinYoService winYoService;
    private final DiaryService diaryService;
    private final GameService gameService;

    // ==========================================
    // 1. 라커룸 메인 (대시보드)
    // ==========================================

    @GetMapping("/main")
    public String lockerMain(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        Long memberId = loginMember.getMemberId();

        // [이동된 로직] 승요력 통계 및 직관 인증하기 버튼 처리
        WinYoAnalysisDTO winYo = winYoService.analyzeWinYoPower(memberId);
        model.addAttribute("winYo", winYo);

        boolean hasTodayGame = false;
        Long todayDiaryId = null;

        List<GameVO> todayGames = gameService.getAllGamesToday(memberId);
        if (todayGames != null && !todayGames.isEmpty()) {
            for (GameVO game : todayGames) {
                if (!"CANCELLED".equals(game.getStatus())) {
                    hasTodayGame = true;
                    // 해당 경기에 대해 작성한 일기가 있는지 확인
                    DiaryVO todayDiary = diaryService.getDiaryByMemberAndGame(memberId, game.getGameId());
                    if (todayDiary != null) {
                        todayDiaryId = todayDiary.getDiaryId();
                        break;
                    }
                    break;
                }
            }
        }
        model.addAttribute("hasTodayGame", hasTodayGame);
        model.addAttribute("todayDiaryId", todayDiaryId);

        // 1. 이벤트 리스트
        List<EventVO> events = contentMngService.getActiveEventList();
        model.addAttribute("events", events);

        // 2. 공지사항 리스트
        List<NoticeVO> notices = systemMngService.getActiveNoticeList();
        if (notices.size() > 4) {
            notices = notices.subList(0, 4); // 0번째부터 4개만 잘라내기
        }
        model.addAttribute("notices", notices);

        // 3. 일반 콘텐츠 (기존 로직 유지, 예: 최신순 20개)
        String myTeam = loginMember.getMyTeamCode();
        List<TeamContentVO> contents = contentMngService.getActiveTeamContentList(myTeam, 4);
        model.addAttribute("contents", contents);

        /* 만약 유저 게시글(locker_posts)을 보여주는 것이라면 아래 코드를 사용:
           List<LockerVO> contents = lockerService.getPostList("TALK", 1, 5);
           model.addAttribute("contents", contents);
        */

        return "locker/locker_main";
    }

    // ==========================================
    // 2. 공지사항 (Notice)
    // ==========================================

    // 공지 목록
    @GetMapping("/notice/list")
    public String noticeList(HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        List<NoticeVO> list = systemMngService.getActiveNoticeList();
        model.addAttribute("list", list);

        return "locker/notice_list"; // views/locker/notice_list.jsp
    }

    // 공지 상세
    @GetMapping("/notice/detail")
    public String noticeDetail(@RequestParam("noticeId") Long noticeId, HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        // 공지사항 클릭 시 조회수 1 증가
        systemMngService.increaseNoticeViewCount(noticeId);

        NoticeVO notice = systemMngService.getNoticeById(noticeId);
        model.addAttribute("post", notice);

        return "locker/notice_detail"; // views/locker/notice_detail.jsp
    }

    // ==========================================
    // 3. 구단 콘텐츠 (Content)
    // ==========================================

    // 콘텐츠 목록
    @GetMapping("/content/list")
    public String contentList(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 필요 시 사용자 팀 코드를 파라미터로 넘길 수 있음
        List<TeamContentVO> list = contentMngService.getActiveTeamContentList(loginMember.getMyTeamCode(), null);
        model.addAttribute("list", list);

        return "locker/content_list";
    }

    // 콘텐츠 상세
    @GetMapping("/content/detail")
    public String contentDetail(@RequestParam("contentId") Long contentId, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 콘텐츠를 클릭했으므로 로그 기록 및 조회수 증가 처리
        contentMngService.logContentClick(contentId, loginMember);
        TeamContentVO content = contentMngService.getTeamContent(contentId);
        model.addAttribute("post", content);

        // 댓글 목록 및 유저 반응 상태 전달
        model.addAttribute("comments", lockerService.getContentComments(contentId));
        model.addAttribute("userReaction", lockerService.getUserReaction(contentId, loginMember.getMemberId()));

        return "locker/content_detail";
    }

    // 반응, 댓글추가, 댓글삭제)
    @PostMapping("/content/reaction")
    @ResponseBody
    public ResponseDTO toggleReaction(@RequestParam("contentId") Long contentId, @RequestParam("reactionType") String reactionType, HttpSession session) {
        ResponseDTO res = new ResponseDTO();
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            res.setResultCode("FAIL"); res.setResultMessage("로그인이 필요합니다."); return res;
        }
        lockerService.toggleReaction(contentId, loginMember.getMemberId(), reactionType);
        res.setResultCode("SUCCESS");
        return res;
    }

    @PostMapping("/content/comment/add")
    @ResponseBody
    public ResponseDTO addComment(@RequestParam("contentId") Long contentId, @RequestParam("content") String content, HttpSession session) {
        ResponseDTO res = new ResponseDTO();
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            res.setResultCode("FAIL");
            res.setResultMessage("로그인이 필요합니다.");
            return res;
        }

        // [금칙어 필터링 로직 추가]
        if (StringUtil.containsBannedWord(content)) {
            res.setResultCode("FAIL");
            res.setResultMessage("댓글에 부적절한 단어가 포함되어 있습니다.");
            return res;
        }

        lockerService.addContentComment(contentId, loginMember.getMemberId(), content);
        res.setResultCode("SUCCESS");
        return res;
    }

    @PostMapping("/content/comment/delete")
    @ResponseBody
    public ResponseDTO deleteComment(@RequestParam("commentId") Long commentId, HttpSession session) {
        ResponseDTO res = new ResponseDTO();
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) { res.setResultCode("FAIL"); return res; }
        lockerService.deleteContentComment(commentId, loginMember.getMemberId());
        res.setResultCode("SUCCESS");
        return res;
    }

    // ==========================================
    // 4. 이벤트 (event)
    // ==========================================

    // 이벤트 상세 페이지
    @GetMapping("/event/detail")
    public String eventDetail(@RequestParam("eventId") Long eventId, HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";

        EventVO event = contentMngService.getEvent(eventId);
        model.addAttribute("post", event);

        return "locker/event_detail";
    }

    @GetMapping("/extract-og")
    @ResponseBody
    public Map<String, String> extractOgMeta(@RequestParam("url") String url) {
        Map<String, String> result = new HashMap<>();

        // [방어 로직 추가] 파라미터가 비어있거나, 올바른 URL 형식(http/https)이 아니면 조기 차단
        if (url == null || url.trim().isEmpty() || (!url.startsWith("http://") && !url.startsWith("https://"))) {
            log.warn("잘못된 URL 형식으로 OG Meta 추출 시도 차단됨: {}", url);
            result.put("error", "true");
            result.put("message", "유효한 URL이 아닙니다.");
            return result; // 서버 뻗음 방지
        }

        try {
            // Jsoup 라이브러리를 사용해 해당 URL의 HTML 메타태그를 스크래핑합니다.
            Document doc = connect(url)
                    .userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
                    .timeout(10000)
                    .get();

            result.put("title", getMetaContent(doc, "og:title", doc.title()));
            result.put("image", getMetaContent(doc, "og:image", ""));
            result.put("description", getMetaContent(doc, "og:description", ""));
            result.put("domain", new URL(url).getHost());
        } catch (java.net.SocketTimeoutException ste) {
            // 단순 응답 지연: 수십 줄의 로그 대신 한 줄짜리 짧은 경고만 출력
            log.warn("OG Meta 추출 타임아웃 (응답 지연): {}", url);
            result.put("error", "true");
            result.put("message", "해당 사이트의 응답이 지연되어 미리보기를 가져올 수 없습니다.");
        } catch (org.jsoup.HttpStatusException hse) {
            // HTTP 접근 권한 에러 (404, 403 등): 차단된 사이트
            log.warn("OG Meta 추출 HTTP 에러 [{}]: {}", hse.getStatusCode(), url);
            result.put("error", "true");
            result.put("message", "해당 사이트의 미리보기 접근이 차단되었습니다.");
        } catch (Exception e) {
            // 기타 알 수 없는 진짜 에러
            log.error("OG Meta 추출 실패: {}", url, e);
            result.put("error", "true");
            result.put("message", "데이터를 가져오는 중 오류가 발생했습니다.");
        }
        return result;
    }

    private String getMetaContent(Document doc, String property, String defaultValue) {
        Element el = doc.selectFirst("meta[property=" + property + "]");
        if (el == null) el = doc.selectFirst("meta[name=" + property + "]");
        return el != null ? el.attr("content") : defaultValue;
    }

}