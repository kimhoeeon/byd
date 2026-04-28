package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class DevRequestVO {
    private Long reqId;
    private Long adminId;       // admins PK
    private String category;    // MAINTENANCE, INQUIRY, BUG
    private String urgency;     // Y, N
    private String title;
    private String content;
    private String status;      // WAITING, PROCESS, DONE, DISCUSS, REJECT
    private String dueDate;     // YYYY-MM-DD
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 조인 데이터
    private String writerName;
    private String writerRole;

    // 부가 데이터
    private int commentCount;
    private List<DevFileVO> fileList;

    // 삭제할 파일 ID 목록 (Form 전송용)
    private List<Long> deleteFileIds;

    public String getStatusBadge() {
        if ("WAITING".equals(status)) return "badge-light-warning";
        if ("PROCESS".equals(status)) return "badge-light-primary";
        if ("DONE".equals(status)) return "badge-light-success";
        if ("DISCUSS".equals(status)) return "badge-light-info";
        return "badge-light-danger";
    }

    // 카테고리 명칭 반환 (메일 발송 및 화면 표시용)
    public String getCategoryName() {
        if ("MAINTENANCE".equals(category)) return "유지보수";
        if ("BUG".equals(category)) return "기능오류";
        if ("INQUIRY".equals(category)) return "단순문의";
        return "기타";
    }

}