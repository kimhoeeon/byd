package com.byd.controller;

import com.byd.service.TeamInfoMngService;
import com.byd.util.FileUtil;
import com.byd.vo.TeamVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequestMapping("/mng/content/team-info")
@RequiredArgsConstructor
public class TeamInfoMngController {

    private final TeamInfoMngService teamInfoMngService;

    // 목록 페이지
    @GetMapping("/list")
    public String listPage(Model model) {
        model.addAttribute("list", teamInfoMngService.getTeamList());
        return "mng/content/team_info_list"; // JSP 파일명 변경
    }

    // 상세 조회 (AJAX)
    @GetMapping("/get")
    @ResponseBody
    public TeamVO getTeam(@RequestParam("teamCode") String teamCode) {
        return teamInfoMngService.getTeam(teamCode);
    }

    // 수정 처리
    @PostMapping("/save")
    public String saveAction(TeamVO team, @RequestParam(value = "uploadFile", required = false) MultipartFile uploadFile,
                             RedirectAttributes rttr) {
        try {
            // 파일이 첨부된 경우 서버에 업로드 후, 그 경로를 객체에 세팅
            if (uploadFile != null && !uploadFile.isEmpty()) {
                String savedUrl = FileUtil.uploadFile(uploadFile, "logo");
                team.setLogoImageUrl(savedUrl);
            }
            teamInfoMngService.updateTeam(team);
            // 성공 메시지 세팅 (리다이렉트 후 소멸됨)
            rttr.addFlashAttribute("msg", "수정 완료되었습니다.");

        } catch (Exception e) {
            log.error("구단 정보 저장 중 오류 발생", e);
            rttr.addFlashAttribute("msg", "구단 정보 수정 중 오류가 발생했습니다.");
        }
        return "redirect:/mng/content/team-info/list";
    }
}