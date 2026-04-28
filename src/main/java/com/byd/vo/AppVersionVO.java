package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AppVersionVO {
    private Long versionId;
    private String osType;       // ANDROID, IOS
    private String versionName;  // 1.0.0
    private Integer versionCode; // 100
    private String forceUpdateYn;// Y, N
    private String message;
    private LocalDateTime createdAt;
}