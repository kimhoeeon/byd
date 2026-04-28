package com.byd.controller;

import com.byd.dto.CommentDTO;
import com.byd.dto.WinYoAnalysisDTO;
import com.byd.exception.AlertException;
import com.byd.service.*;
import com.byd.service.*;
import com.byd.util.DistanceUtil;
import com.byd.util.FileUtil;
import com.byd.vo.DiaryVO;
import com.byd.vo.GameVO;
import com.byd.vo.MemberVO;
import com.byd.vo.StadiumVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/diary")
@RequiredArgsConstructor
public class DiaryController {

    private final DiaryService diaryService;
    private final GameService gameService;
    private final CommentService commentService;
    private final WinYoService winYoService;
    private final MemberService memberService;

    // 1. 일기 작성 페이지 이동
    @GetMapping("/write")
    public String writePage(@RequestParam(value = "gameId", required = false) Long gameId,
                            HttpSession session, Model model, HttpServletResponse response) throws Exception {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 이미 작성된 일기가 있는지 체크
        DiaryVO existingDiary = diaryService.getDiaryByMemberAndGame(loginMember.getMemberId(), gameId);
        if (existingDiary != null) {
            // 이미 작성한 기록이 있다면 alert 후 상세 페이지로 이동
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('이미 작성된 기록입니다.'); location.href='/diary/detail?diaryId=" + existingDiary.getDiaryId() + "';</script>");
            out.flush();
            return null; // 뷰를 렌더링하지 않고 스크립트만 실행 후 종료
        }

        boolean isScoreEditable = true; // 기본적으로 스코어 작성 가능 상태
        boolean isVerifyPossible = true; // 기본적으로 직관 인증 가능 상태
        String verifyRejectReason = ""; // 인증 불가 사유

        // 메인에서 '오늘의 경기 기록하기'로 넘어온 경우, 해당 경기 정보를 미리 세팅
        if (gameId != null) {
            GameVO game = gameService.getGameById(gameId);

            if (game != null) {

                // 화면 진입 단계에서 하루 1개 제한 체크
                int dailyCount = diaryService.countDiaryByDate(loginMember.getMemberId(), game.getGameDate());
                if (dailyCount >= 1) {
                    response.setContentType("text/html; charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script>alert('직관 일기는 하루에 1개 경기만 작성할 수 있어요!'); history.back();</script>");
                    out.flush();
                    return null;
                }

                model.addAttribute("selectedGame", game);
                model.addAttribute("targetGameId", gameId);

                // 신규 작성 시에도 경기 종료/취소 또는 시작 1시간 이후면 스코어 입력 차단
                if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                    isScoreEditable = false;
                    isVerifyPossible = false; // 이미 종료되거나 취소된 경기는 인증 불가
                    verifyRejectReason = "종료된 경기";
                } else {
                    try {
                        String timeStr = game.getGameTime();
                        if (timeStr != null && timeStr.length() == 5) timeStr += ":00";
                        String dateTimeStr = game.getGameDate() + " " + timeStr;
                        LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                        LocalDateTime now = LocalDateTime.now();

                        // 스코어 편집 제어: 경기 시작 1시간 전이 지났으면 스코어 입력 불가
                        if (now.isAfter(gameStart.minusHours(1))) {
                            isScoreEditable = false;
                        }

                        // 직관 인증 제어: 경기 시작 2시간 전 미만이거나 경기 시작 1시간 이후면 불가
                        if (now.isBefore(gameStart.minusHours(2))) {
                            isVerifyPossible = false;
                            verifyRejectReason = "인증 시간 전";
                        } else if (now.isAfter(gameStart.plusHours(1))) {
                            isVerifyPossible = false;
                            verifyRejectReason = "인증 시간 초과";
                        }

                    } catch (Exception e) {
                        log.error("경기 시작시간 파싱 오류", e);
                    }
                }
            }
        }

        model.addAttribute("isScoreEditable", isScoreEditable);
        model.addAttribute("isVerifyPossible", isVerifyPossible);
        model.addAttribute("verifyRejectReason", verifyRejectReason);

        return "diary/diary_write"; // views/diary/diary_write.jsp
    }

    // 2. 일기 저장 처리
    @PostMapping("/write")
    @ResponseBody
    public String writeAction(DiaryVO diary,
                              @RequestParam(value = "files", required = false) List<MultipartFile> files,
                              HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "<script>alert('로그인이 필요합니다.'); location.href='/member/login';</script>";

        try {
            // 파일 다중 업로드 처리
            if (files != null && !files.isEmpty()) {
                List<String> urls = new java.util.ArrayList<>();
                for (MultipartFile f : files) {
                    if (f != null && !f.isEmpty()) {
                        urls.add(FileUtil.uploadFile(f, "diary"));
                    }
                }
                if (!urls.isEmpty()) {
                    diary.setImageUrl(String.join(",", urls)); // DB에 콤마로 연결하여 저장
                }
            }

            diary.setMemberId(loginMember.getMemberId());
            diary.setSnapshotTeamCode(loginMember.getMyTeamCode());

            // 직관 인증을 했다면 현재 시간을 인증 시간으로 기록
            if (diary.isVerified()) {
                diary.setVerifiedAt(LocalDateTime.now());
            }

            Long diaryId = diaryService.writeDiary(diary);
            // 성공 시 완료 페이지로 이동
            return "<script>location.replace('/diary/complete?diaryId=" + diaryId + "');</script>";
        } catch (AlertException ae) {
            log.info("일기 작성 알럿: {}", ae.getMessage());
            // 실패 시 팝업을 띄우고 원래 화면으로 복귀
            return "<script>alert('" + ae.getMessage() + "'); history.back();</script>";
        } catch (Exception e) {
            log.error("일기 작성 중 치명적 오류", e);
            return "<script>alert('시스템 오류가 발생했습니다.'); history.back();</script>";
        }
    }

    // --- [1] 일기 수정 페이지 이동 (GET) ---
    @GetMapping("/update")
    public String updatePage(@RequestParam("diaryId") Long diaryId,
                             HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 기존 일기 정보 조회
        DiaryVO diary = diaryService.getDiary(diaryId);
        if (diary == null) return "redirect:/diary/list";

        // 2. 권한 확인 (본인 글이 아니면 튕겨냄)
        if (!diary.getMemberId().equals(loginMember.getMemberId())) {
            return "redirect:/diary/detail?diaryId=" + diaryId;
        }

        // 3. 경기 정보 조회 (화면에 "LG vs 두산" 등을 보여주기 위함)
        GameVO game = gameService.getGameById(diary.getGameId());

        // 스코어 수정 가능 여부 판단
        boolean isScoreEditable = true;
        boolean isVerifyPossible = true;

        if (game != null) {
            if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                isScoreEditable = false;
                isVerifyPossible = false;
            } else {
                try {
                    String timeStr = game.getGameTime();
                    if (timeStr != null && timeStr.length() == 5) timeStr += ":00"; // HH:mm 초단위 예외 처리
                    String dateTimeStr = game.getGameDate() + " " + timeStr;
                    LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                    LocalDateTime now = LocalDateTime.now();

                    if (now.isAfter(gameStart.minusHours(1))) {
                        isScoreEditable = false;
                    }

                    // 인증 제어: 2시간 전 미만이거나 1시간 이후면 불가
                    if (now.isBefore(gameStart.minusHours(2)) || now.isAfter(gameStart.plusHours(1))) {
                        isVerifyPossible = false;
                    }

                } catch (Exception e) {
                    log.error("경기 시작시간 파싱 오류", e);
                }
            }
        }

        model.addAttribute("diary", diary);
        model.addAttribute("game", game);
        model.addAttribute("isScoreEditable", isScoreEditable);
        model.addAttribute("isVerifyPossible", isVerifyPossible);

        return "diary/diary_update";
    }

    // --- [2] 일기 수정 처리 (POST) ---
    @PostMapping("/update")
    @ResponseBody
    public String updateAction(@ModelAttribute DiaryVO diary,
                               @RequestParam(value = "files", required = false) List<MultipartFile> files, // 다중 파일
                               @RequestParam(value = "existingImages", required = false) List<String> existingImages, // 유지된 기존 사진들
                               HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "<script>alert('로그인이 필요합니다.'); location.href='/member/login';</script>";
        }

        try {

            // 1. 기존 일기 정보 조회 (GameId 확보용)
            DiaryVO originalDiary = diaryService.getDiary(diary.getDiaryId());
            if (originalDiary == null) {
                return "<script>alert('존재하지 않는 일기입니다.'); history.back();</script>";
            }

            // 2. 작성자 본인 확인
            if (!originalDiary.getMemberId().equals(loginMember.getMemberId())) {
                return "<script>alert('수정 권한이 없습니다.'); history.back();</script>";
            }

            // 3. 경기 시작 1시간 전 체크
            // 원본 일기의 경기 정보를 가져옴
            GameVO game = gameService.getGameById(originalDiary.getGameId());
            boolean isScoreEditable = true;
            if (game != null) {
                if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                    isScoreEditable = false;
                } else {
                    try {
                        String timeStr = game.getGameTime();
                        if (timeStr != null && timeStr.length() == 5) timeStr += ":00";
                        String dateTimeStr = game.getGameDate() + " " + timeStr;
                        LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                        if (LocalDateTime.now().isAfter(gameStart.minusHours(1))) {
                            isScoreEditable = false;
                        }
                    } catch (Exception e) {
                        log.error("경기 시작시간 파싱 오류", e);
                    }
                }
            }

            // 스코어 수정 불가능 시간이면 원본 데이터(기존 스코어) 유지
            if (!isScoreEditable) {
                diary.setGameId(originalDiary.getGameId());
                diary.setPredScoreHome(originalDiary.getPredScoreHome());
                diary.setPredScoreAway(originalDiary.getPredScoreAway());
            }

            // [다중 이미지 처리 로직]
            List<String> finalUrls = new java.util.ArrayList<>();
            // 1. 삭제하지 않고 유지한 기존 이미지 삽입
            if (existingImages != null && !existingImages.isEmpty()) {
                finalUrls.addAll(existingImages);
            }
            // 2. 새롭게 추가 업로드된 이미지 삽입
            if (files != null && !files.isEmpty()) {
                for (MultipartFile f : files) {
                    if (f != null && !f.isEmpty()) {
                        finalUrls.add(FileUtil.uploadFile(f, "diary"));
                    }
                }
            }
            // 3. 콤마로 연결하여 저장 (없으면 null)
            diary.setImageUrl(finalUrls.isEmpty() ? null : String.join(",", finalUrls));

            // 작성자 ID 세팅 (보안)
            diary.setMemberId(loginMember.getMemberId());

            // 3. DB 업데이트
            diaryService.modifyDiary(diary);

            return "<script>alert('수정되었습니다.'); location.href='/diary/detail?diaryId=" + diary.getDiaryId() + "';</script>";

        } catch (AlertException ae) {
            log.info("일기 수정 알럿: {}", ae.getMessage());
            return "<script>alert('" + ae.getMessage() + "'); history.back();</script>";
        } catch (Exception e) {
            log.error("일기 수정 중 치명적 오류", e);
            return "<script>alert('수정 중 오류가 발생했습니다.'); history.back();</script>";
        }
    }

    // 3. 작성 완료 페이지
    @GetMapping("/complete")
    public String completePage(@RequestParam("diaryId") Long diaryId, Model model) {
        // 방금 쓴 일기 정보 조회 (한줄평 등 표시용)
        DiaryVO diary = diaryService.getDiary(diaryId);
        model.addAttribute("diary", diary);
        return "diary/diary_comp";
    }

    // 4. 저장 실패 페이지
    @GetMapping("/fail")
    public String failPage() {
        return "diary/diary_fail";
    }

    // [AJAX] 경기 검색/목록 조회 (팝업용)
    @GetMapping("/api/games")
    @ResponseBody
    public List<GameVO> getGameList(HttpSession session) {
        // 이번 달 또는 최근 경기 리스트를 반환
        // 여기서는 간단히 '오늘 전체 경기' 또는 '최근 7일 경기' 등을 조회하도록 구현
        return gameService.getAllGamesToday(); // 실제로는 날짜 범위 조회 필요
    }

    // 5. 일기 상세 페이지
    @GetMapping("/detail")
    public String detailPage(@RequestParam("diaryId") Long diaryId,
                             HttpSession session, Model model) {

        // 페이지 진입 시 먼저 조회수 1 증가
        diaryService.increaseViewCount(diaryId);

        // 1. 일기 정보 조회
        DiaryVO diary = diaryService.getDiary(diaryId);
        if (diary == null) return "redirect:/diary/list";

        // 2. 댓글 목록 조회
        List<CommentDTO> comments = commentService.getCommentsByDiaryId(diaryId);

        // 3. 권한 및 상태 체크
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        boolean isOwner = (loginMember != null && loginMember.getMemberId().equals(diary.getMemberId()));

        // 수정 가능 여부 체크 (경기 시작 1시간 전까지만 수정 가능)
        // diary.gameDate(yyyy-MM-dd)와 diary.gameTime(HH:mm)을 합쳐서 비교
        boolean isEditable = true;
        // 스코어 수정 가능 여부만 따로 체크해서 멘트 제어용으로 전달
        boolean isScoreEditable = true;
        String lockReason = ""; // JSP에서 멘트 구분을 위해 사용

        // 정확한 상태 판단을 위해 Game 정보 조회
        GameVO game = gameService.getGameById(diary.getGameId());

        if (game != null) {
            // 1. 경기 종료/취소 여부 확인
            if ("FINISHED".equals(game.getStatus()) || "CANCELLED".equals(game.getStatus())) {
                isScoreEditable = false;
                lockReason = "FINISHED"; // 이미 종료됨
            } else {
                try {
                    // 2. 경기 시작 1시간 전 체크
                    String timeStr = game.getGameTime();
                    if (timeStr != null && timeStr.length() == 5) timeStr += ":00";
                    String dateTimeStr = game.getGameDate() + " " + timeStr;
                    LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                    if (LocalDateTime.now().isAfter(gameStart.minusHours(1))) {
                        isScoreEditable = false;
                        lockReason = "IMMINENT"; // 임박함
                    }
                } catch (Exception e) {
                    log.error("경기 상태 체크 중 오류: {}", e.getMessage());
                }
            }
        }

        model.addAttribute("diary", diary);
        model.addAttribute("comments", comments);
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("isEditable", isEditable);
        model.addAttribute("isScoreEditable", isScoreEditable);
        model.addAttribute("lockReason", lockReason);

        return "diary/diary_detail";
    }

    // 댓글 삭제 (AJAX)
    @PostMapping("/comment/delete")
    @ResponseBody
    public String deleteCommentAction(@RequestParam("commentId") Long commentId,
                                      HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            // 본인 확인은 Service/Mapper 레벨에서 처리 (requestMemberId 전달)
            commentService.deleteComment(commentId, loginMember.getMemberId());
            return "ok";
        } catch (AlertException ae) {
            log.info("댓글 삭제 거부: {}", ae.getMessage());
            return ae.getMessage();
        } catch (Exception e) {
            log.error("댓글 삭제 중 치명적 오류", e);
            return "댓글 삭제 중 오류가 발생했습니다.";
        }
    }

    // 댓글 작성 처리 (AJAX)
    @PostMapping("/comment/write")
    @ResponseBody
    public String writeCommentAction(@RequestParam("diaryId") Long diaryId,
                                     @RequestParam("content") String content,
                                     HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            CommentDTO comment = new CommentDTO();
            comment.setDiaryId(diaryId);
            comment.setMemberId(loginMember.getMemberId());
            comment.setContent(content);

            commentService.writeComment(comment);

            return "ok";
        } catch (AlertException ae) {
            log.info("댓글 작성 알럿: {}", ae.getMessage());
            return ae.getMessage();
        } catch (Exception e) {
            log.error("댓글 작성 실패", e);
            return "댓글 작성에 실패했습니다.";
        }
    }

    // 일기 목록 페이지
    @GetMapping("/list")
    public String listPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 1. 일기 목록 조회
        List<DiaryVO> list = diaryService.getMyDiaryList(loginMember.getMemberId());
        model.addAttribute("list", list);

        // 2. 승요력 분석 데이터 조회
        WinYoAnalysisDTO winYo = winYoService.analyzeWinYoPower(loginMember.getMemberId());
        model.addAttribute("winYo", winYo);

        return "diary/diary_list";
    }

    // 일기 삭제 처리 (AJAX)
    @PostMapping("/delete")
    @ResponseBody
    public String deleteDiaryAction(@RequestParam("diaryId") Long diaryId,
                                    HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login";

        try {
            diaryService.deleteDiary(diaryId, loginMember.getMemberId());
            return "ok";
        } catch (AlertException ae) {
            log.info("일기 삭제 알럿: {}", ae.getMessage());
            return "fail:" + ae.getMessage(); // 프론트에서 사유를 띄워주기 위해 메시지 포함
        } catch (Exception e) {
            log.error("일기 삭제 중 치명적 오류", e);
            return "fail";
        }
    }

    // 친구 일기 상세 페이지
    @GetMapping("/friend/detail")
    public String friendDetailPage(@RequestParam("diaryId") Long diaryId,
                                   HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        // 친구 일기 페이지 진입 시 조회수 1 증가
        diaryService.increaseViewCount(diaryId);

        // 1. 일기 정보 조회
        DiaryVO diary = diaryService.getDiary(diaryId);
        if (diary == null) return "redirect:/diary/friend/list";

        // 2. 작성자(친구) 정보 조회
        Long writerId = diary.getMemberId();
        MemberVO writer = memberService.getMemberInfo(writerId);

        // 3. 작성자의 승요력(승률) 조회
        WinYoAnalysisDTO writerWinYo = winYoService.analyzeWinYoPower(writerId);

        // 4. 팔로우 여부 확인
        boolean isFollowing = memberService.isFollowing(loginMember.getMemberId(), writerId);

        // 5. 댓글 조회
        List<CommentDTO> comments = commentService.getCommentsByDiaryId(diaryId);

        model.addAttribute("diary", diary);
        model.addAttribute("writer", writer);
        model.addAttribute("writerWinYo", writerWinYo);
        model.addAttribute("isFollowing", isFollowing);
        model.addAttribute("comments", comments);

        return "diary/friend_detail";
    }

    // 친구 일기 목록 (피드)
    @GetMapping("/friend/list")
    public String friendDiaryList(@RequestParam(value = "tab", defaultValue = "all") String tab,
                                  @RequestParam(value = "targetMemberId", required = false) Long targetMemberId,
                                  HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        Long memberId = loginMember.getMemberId();

        // 친구 유무 플래그 전달
        int friendCount = diaryService.getFriendCount(memberId);
        model.addAttribute("hasFriends", friendCount > 0);

        List<DiaryVO> list;
        if (targetMemberId != null) {
            // [CASE 1] 특정 친구의 일기만 모아보기
            list = diaryService.getMemberPublicDiaries(targetMemberId);
            model.addAttribute("pageTitle", "친구의 직관일기");
        } else {
            // [CASE 2] 탭별 피드 조회 분기 처리
            if ("all".equals(tab)) {
                // '전체' 탭: 친구가 0명이면 인기 게시물 노출, 아니면 전체 피드 노출
                list = diaryService.getRecommendedFriendDiaries(loginMember.getMemberId());
            } else {
                // '팔로잉/팔로워' 탭: 인기 게시물 없이, 해당 탭 조건에 맞는 사람의 피드만 순수하게 노출
                list = diaryService.getFeedDiaries(loginMember.getMemberId(), tab);
            }
            model.addAttribute("pageTitle", "친구들의 직관");
        }

        model.addAttribute("list", list);
        model.addAttribute("tab", tab);
        model.addAttribute("targetMemberId", targetMemberId);

        return "diary/friend_list";
    }

    // 공유 링크 발급 (AJAX)
    @PostMapping("/share/create")
    @ResponseBody
    public String createShareLink(@RequestParam("diaryId") Long diaryId, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "fail:login"; // 로그인 필요

        try {
            // 1. 일기 정보 조회 (존재 여부 확인)
            DiaryVO diary = diaryService.getDiary(diaryId);
            if (diary == null) {
                return "fail:not_found"; // 일기가 없음
            }

            // 2. 권한 체크 (작성자 본인만 공유 링크 생성 가능)
            if (!diary.getMemberId().equals(loginMember.getMemberId())) {
                return "fail:permission"; // 권한 없음 (남의 글)
            }

            // 3. 비공개 글인지 체크 (선택 사항: 비공개 글은 공유 불가 정책이라면 추가)
            if ("PRIVATE".equals(diary.getIsPublic())) {
                return "fail:private"; // 비공개 글은 공유 불가
            }

            // 4. 공유 UUID 생성 및 반환
            return diaryService.generateShareLink(diaryId);

        } catch (Exception e) {
            log.error("공유 링크 생성 실패", e);
            return "fail:error";
        }
    }

    // GPS 직관 인증 API
    @PostMapping("/verify/gps")
    @ResponseBody
    public String verifyGps(@RequestParam("gameId") Long gameId,
                            @RequestParam("lat") Double userLat,
                            @RequestParam("lon") Double userLon) {
        try {
            // 1. 경기 정보 조회
            GameVO game = gameService.getGameById(gameId);
            if (game == null) return "fail:game_not_found";

            // 1-1. 취소/종료된 경기는 인증 불가
            if ("CANCELLED".equals(game.getStatus()) || "FINISHED".equals(game.getStatus())) {
                return "fail:game_ended";
            }

            // 1-2. 시간 검증: 경기 시작 2시간 전 ~ 경기 시작 1시간 후까지만 인증 가능
            try {
                String timeStr = game.getGameTime();
                if (timeStr != null && timeStr.length() == 5) timeStr += ":00";
                String dateTimeStr = game.getGameDate() + " " + timeStr;
                LocalDateTime gameStart = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                LocalDateTime now = LocalDateTime.now();

                if (now.isBefore(gameStart.minusHours(2))) {
                    return "fail:not_yet"; // 경기 시작 2시간 전보다 이름
                } else if (now.isAfter(gameStart.plusHours(1))) {
                    return "fail:timeout"; // 경기 시작 1시간 초과로 인증 불가
                }
            } catch (Exception e) {
                log.error("GPS 인증 - 경기 시간 파싱 오류", e);
                return "fail:error";
            }

            // 2. 구장 정보 및 좌표 조회
            StadiumVO stadium = gameService.getStadium(game.getStadiumId());
            if (stadium == null || stadium.getLat() == null || stadium.getLon() == null) {
                // 구장 좌표 데이터가 DB에 없는 경우
                return "fail:stadium_info_missing";
            }

            // 3. 거리 계산 (반경 2km 이내 인정)
            double distance = DistanceUtil.distance(userLat, userLon, stadium.getLat(), stadium.getLon());

            log.info("GPS 인증 시도 - 경기: {}, 유저위치: ({}, {}), 구장: {}, 거리: {}km",
                    gameId, userLat, userLon, stadium.getName(), String.format("%.2f", distance));

            if (distance <= 2.0) { // 2km 이내
                return "ok"; // 인증 성공
            } else {
                return "fail:distance"; // 거리가 멉니다
            }

        } catch (Exception e) {
            log.error("GPS 인증 처리 중 오류", e);
            return "fail:error";
        }
    }

}