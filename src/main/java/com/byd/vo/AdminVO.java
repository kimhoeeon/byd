package com.byd.vo;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class AdminVO {
    private Long adminId;
    private String loginId;
    private String password;
    private String name;
    private String role; // SUPER, MANAGER, CLIENT

    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;

    // 하위 테이블 데이터 (MyBatis Collection 매핑용)
    private List<String> allowedIpList;     // 허용 IP 목록
    private List<AdminEmailVO> emailList;   // 이메일 목록
}