package com.byd.mapper;

import com.byd.vo.AdminEmailVO;
import com.byd.vo.AdminVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminMapper {

    // ID로 관리자 정보 조회
    AdminVO selectAdminByLoginId(String loginId);

    // 허용 IP 목록 조회
    List<String> selectAllowedIpsByAdminId(Long adminId);

    // 이메일 설정 목록 조회
    List<AdminEmailVO> selectAdminEmailsByAdminId(Long adminId);

    // 로그인 성공 시 마지막 접속일 업데이트
    void updateLastLogin(Long adminId);

    // 비밀번호 업데이트 (조건: ID)
    int updatePassword(@Param("id") String id, @Param("password") String password);

}