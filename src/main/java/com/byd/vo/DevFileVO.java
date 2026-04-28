package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class DevFileVO {
    private Long fileId;
    private String targetType;
    private Long targetId;
    private String orgFileName;
    private String saveFileName;
    private String filePath;
    private Long fileSize;
    private LocalDateTime createdAt;

    public String getName() { return saveFileName; }
}