package com.byd.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.UUID;

public class FileUtil {

    // 공통 루트 경로 상수
    private static final String UPLOAD_ROOT = "/usr/local/tomcat/webapps/upload";

    /**
     * 파일 저장 함수
     * @param file 업로드할 파일
     * @param subDirectory 하위 폴더명 (예: "diary", "notice", "inquiry")
     * @return DB에 저장할 웹 접근 URL
     */
    public static String uploadFile(MultipartFile file, String subDirectory) throws Exception {
        if (file == null || file.isEmpty()) return null;

        // 1. 저장할 물리적 경로 생성
        File dir = new File(UPLOAD_ROOT, subDirectory);
        if (!dir.exists()) dir.mkdirs();

        // 2. 파일명 생성
        String savedName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        File target = new File(dir, savedName);

        // 3. 저장
        file.transferTo(target);

        // 4. URL 반환 (예: /upload/diary/uuid_filename.jpg)
        return "/upload/" + subDirectory + "/" + savedName;
    }
}