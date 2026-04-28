package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AlarmVO {
    private Long alarmId;
    private Long memberId;
    private String category;    // GAME, NEWS, EVENT, FRIEND, SYSTEM(관리자 푸시)
    private String title;       // 알림 제목
    private String content;     // 알림 내용
    private String redirectUrl; // 클릭 시 이동할 링크Url
    private boolean isRead;
    private LocalDateTime createdAt;

    // 화면 표시용 (날짜 포맷 등)
    private String displayTime;
}