package com.byd.vo;

import lombok.Data;
import java.util.Date;

@Data
public class ContentClickLogVO {
    private Long logId;         // 로그 ID (PK)
    private Long contentId;     // 컨텐츠 ID
    private Long memberId;      // 회원 ID (비회원일 경우 NULL)
    private String gender;      // 성별 (M/F/U)
    private String ageGroup;    // 연령대 (10대, 20대...)
    private Date clickedAt;     // 클릭 일시
}