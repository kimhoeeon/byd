package com.byd.controller;

import com.byd.service.DevMngService;
import com.byd.util.FileUtil;
import com.byd.vo.*;
import com.byd.vo.*;
import com.byd.dto.PageDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/mng/dev")
@RequiredArgsConstructor
public class DevMngController {

    private final DevMngService devMngService;

    // 1. 목록 페이지
    @GetMapping("/list")
    public String list(Model model, @ModelAttribute("cri") Criteria cri) {
        List<DevRequestVO> list = devMngService.getRequestList(cri);
        int total = devMngService.getRequestTotal(cri);

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total));

        return "mng/dev/dev_list";
    }

    // 2. 등록 및 수정 폼
    @GetMapping("/write")
    public String writeForm(@RequestParam(value = "reqId", required = false) Long reqId, Model model) {
        if (reqId != null) {
            // 수정 모드: 기존 데이터 조회
            DevRequestVO vo = devMngService.getRequest(reqId);
            model.addAttribute("vo", vo);
        }
        return "mng/dev/dev_form";
    }

    // 3. 글 저장 (등록/수정 공용)
    @PostMapping("/save")
    public String save(DevRequestVO vo,
                       @RequestParam(value = "files", required = false) List<MultipartFile> files,
                       HttpSession session) {

        // 세션에서 작성자 정보 획득
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        if (admin != null) {
            // 신규 등록일 때만 작성자 ID 설정 (수정 시에는 기존 작성자 유지)
            if (vo.getReqId() == null) {
                vo.setAdminId(admin.getAdminId());
            }
        }

        // 파일 업로드 처리
        List<DevFileVO> fileList = uploadFiles(files, "REQ");
        vo.setFileList(fileList);

        if (vo.getReqId() == null) {
            // 신규 등록
            devMngService.insertRequest(vo);
        } else {
            // 수정 (내용 업데이트 + 파일 추가/삭제)
            devMngService.updateRequest(vo);
        }

        return "redirect:/mng/dev/list";
    }

    // 4. 상세 페이지 (댓글 포함)
    @GetMapping("/detail")
    public String detail(@RequestParam("reqId") Long reqId,
                         @ModelAttribute("cri") Criteria cri, // 목록 검색 조건 유지를 위해 받음
                         Model model) {

        DevRequestVO vo = devMngService.getRequest(reqId);
        List<DevCommentVO> comments = devMngService.getCommentList(reqId);

        model.addAttribute("vo", vo);
        model.addAttribute("comments", comments);

        return "mng/dev/dev_detail";
    }

    // 5. 상태 변경 (관리자용 - AJAX)
    @PostMapping("/status")
    @ResponseBody
    public String updateStatus(DevRequestVO vo) {
        try {
            devMngService.updateStatus(vo);
            return "ok";
        } catch (Exception e) {
            log.error("상태 변경 오류", e);
            return "fail";
        }
    }

    // 5-1. 상태 일괄 변경 (관리자용 - AJAX 다건)
    @PostMapping("/status/bulk")
    @ResponseBody
    public String updateStatusBulk(@RequestParam("reqIds") List<Long> reqIds,
                                   @RequestParam("status") String status,
                                   @RequestParam(value = "dueDate", required = false) String dueDate) {
        try {
            devMngService.updateStatusBulk(reqIds, status, dueDate);
            return "ok";
        } catch (Exception e) {
            log.error("상태 일괄 변경 오류", e);
            return "fail";
        }
    }

    // 6. 댓글 등록
    @PostMapping("/comment/save")
    public String saveComment(DevCommentVO vo,
                              @RequestParam(value = "coFiles", required = false) List<MultipartFile> files,
                              HttpSession session) {
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        if (admin != null) {
            vo.setAdminId(admin.getAdminId());
            vo.setWriterRole(admin.getRole()); // 알림 발송 로직에서 사용 (CLIENT vs ADMIN 구분)
        }

        List<DevFileVO> fileList = uploadFiles(files, "COM");
        vo.setFileList(fileList);

        devMngService.registerComment(vo);

        return "redirect:/mng/dev/detail?reqId=" + vo.getReqId();
    }

    // 7. 댓글 수정
    @PostMapping("/comment/update")
    public String updateComment(DevCommentVO vo,
                                @RequestParam(value = "coFiles", required = false) List<MultipartFile> files,
                                HttpSession session) {

        // 신규 파일 업로드
        List<DevFileVO> fileList = uploadFiles(files, "COM");
        vo.setFileList(fileList);

        devMngService.updateComment(vo);

        return "redirect:/mng/dev/detail?reqId=" + vo.getReqId();
    }

    // 8. 댓글 삭제 (AJAX)
    @PostMapping("/comment/delete")
    @ResponseBody
    public String deleteComment(@RequestParam("commentId") Long commentId) {
        try {
            devMngService.deleteComment(commentId);
            return "ok";
        } catch (Exception e) {
            log.error("댓글 삭제 오류", e);
            return "fail";
        }
    }

    // --- 유틸리티: 파일 업로드 ---
    private List<DevFileVO> uploadFiles(List<MultipartFile> files, String targetType) {
        List<DevFileVO> list = new ArrayList<>();
        if (files == null || files.isEmpty()) return list;

        for (MultipartFile mf : files) {
            if (!mf.isEmpty()) {
                try {
                    // 1. FileUtil을 통해 "dev" 폴더에 저장 및 경로 획득
                    // 리턴값 예시: "/upload/dev/uuid_filename.ext"
                    String fileUrl = FileUtil.uploadFile(mf, "dev");

                    // 2. VO 정보 설정
                    DevFileVO fileVO = new DevFileVO();
                    fileVO.setTargetType(targetType);
                    fileVO.setOrgFileName(mf.getOriginalFilename());
                    fileVO.setFileSize(mf.getSize());

                    // 파일명만 추출 (DB 구조에 따라 전체 경로를 넣을지, 파일명만 넣을지 결정)
                    // 여기서는 기존 로직에 맞춰 파일명과 경로를 분리합니다.
                    String savedName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
                    fileVO.setSaveFileName(savedName);
                    fileVO.setFilePath("/upload/dev/"); // 저장된 경로

                    list.add(fileVO);
                } catch (Exception e) {
                    log.error("파일 업로드 실패: " + mf.getOriginalFilename(), e);
                }
            }
        }
        return list;
    }
}