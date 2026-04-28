package com.byd.controller;

import com.byd.config.MaintenanceInterceptor;
import com.byd.service.SystemMngService;
import com.byd.util.FileUtil;
import com.byd.vo.AppVersionVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
public class CommonApiController {

    private final SystemMngService systemMngService;

    /**
     * [공통] Summernote 에디터 이미지 업로드 API
     * 저장 위치: /upload/editor/
     */
    @PostMapping("/api/common/upload/editor")
    public ResponseEntity<String> uploadEditorImage(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body("파일이 없습니다.");
            }

            // FileUtil을 사용해 'editor' 폴더에 저장
            String savedUrl = FileUtil.uploadFile(file, "editor");

            return ResponseEntity.ok(savedUrl); // 이미지 경로 반환

        } catch (Exception e) {
            log.error("에디터 이미지 업로드 실패", e);
            return ResponseEntity.internalServerError().body("업로드 중 오류가 발생했습니다.");
        }
    }

    /**
     * 앱(App) 런칭 시 상태 체크 (점검 및 강제 업데이트 확인)
     * URL: /api/v1/system/init
     */
    @GetMapping("/api/v1/system/init")
    public Map<String, Object> getAppInitStatus(@RequestParam("osType") String osType,
                                                @RequestParam("versionCode") int currentVersionCode) {
        Map<String, Object> response = new HashMap<>();

        // 1. 점검 상태 세팅
        response.put("isMaintenance", MaintenanceInterceptor.isMaintenanceMode);
        response.put("maintenanceMessage", MaintenanceInterceptor.maintenanceMessage);

        // 2. 앱 강제 업데이트 상태 세팅
        AppVersionVO latestVersion = systemMngService.getLatestVersion(osType);

        boolean isUpdateRequired = false;
        boolean isForceUpdate = false;
        String updateMessage = "";

        if (latestVersion != null) {
            if (currentVersionCode < latestVersion.getVersionCode()) {
                isUpdateRequired = true;
                if ("Y".equals(latestVersion.getForceUpdateYn())) {
                    isForceUpdate = true;
                }
                updateMessage = latestVersion.getMessage();
            }
        }

        response.put("isUpdateRequired", isUpdateRequired);
        response.put("isForceUpdate", isForceUpdate);
        response.put("updateMessage", updateMessage);

        return response;
    }
}