package com.byd.controller;

import com.byd.config.MaintenanceInterceptor;
import com.byd.service.AdminMngService;
import com.byd.service.SystemMngService;
import com.byd.vo.AdminVO;
import com.byd.vo.Criteria;
import com.byd.dto.PageDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/mng/system/admin")
@RequiredArgsConstructor
public class AdminMngController {

    private final AdminMngService adminMngService;
    private final SystemMngService systemMngService;

    @GetMapping("/list")
    public String list(Model model, @ModelAttribute("cri") Criteria cri) {
        int total = adminMngService.getAdminCount(cri);
        model.addAttribute("list", adminMngService.getAdminList(cri));
        model.addAttribute("pageMaker", new PageDTO(cri, total));
        return "mng/system/admin_list";
    }

    @GetMapping("/form")
    public String form(@RequestParam(value = "id", required = false) Long adminId, Model model) {
        if (adminId != null) {
            model.addAttribute("vo", adminMngService.getAdmin(adminId));
        }
        return "mng/system/admin_form";
    }

    @PostMapping("/save")
    public String save(AdminVO vo) {
        adminMngService.saveAdmin(vo);
        return "redirect:/mng/system/admin/list";
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam("adminId") Long adminId) {
        try {
            adminMngService.deleteAdmin(adminId);
            return "ok";
        } catch (Exception e) {
            return "fail";
        }
    }

    @GetMapping("/checkId")
    @ResponseBody
    public boolean checkId(@RequestParam("loginId") String loginId) {
        return adminMngService.isIdDuplicate(loginId);
    }

    /**
     * 점검 모드 ON/OFF 제어 API
     * URL: /mng/system/admin/maintenance/toggle
     */
    @PostMapping("/maintenance/toggle")
    @ResponseBody
    public Map<String, Object> toggleMaintenance(@RequestParam("mode") boolean mode,
                                                 @RequestParam(value="message", required=false) String message) {

        // DB 상태 저장 및 메모리 즉시 반영을 위해 Service 호출
        systemMngService.setMaintenanceMode(mode);

        // 점검 메시지가 함께 넘어올 경우 세팅
        if (message != null && !message.isEmpty()) {
            MaintenanceInterceptor.maintenanceMessage = message;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("isMaintenanceMode", MaintenanceInterceptor.isMaintenanceMode);
        return result;
    }

}