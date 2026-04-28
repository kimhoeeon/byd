package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class DevCommentVO {
    private Long commentId;
    private Long reqId;
    private Long adminId;
    private Long parentId;
    private String content;
    private String delYn;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 조인 데이터
    private String writerName;
    private String writerRole;

    private int depth;
    private List<DevFileVO> fileList;

    // 삭제할 파일 ID 목록
    private List<Long> deleteFileIds;
}