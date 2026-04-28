package com.byd.mapper;

import com.byd.vo.AdminEmailVO;
import com.byd.vo.AdminVO;
import com.byd.vo.Criteria;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface AdminMngMapper {
    // 목록
    List<AdminVO> selectAdminList(Criteria cri);
    int countAdminList(Criteria cri);

    // 상세
    AdminVO selectAdminById(Long adminId);

    // 중복 체크
    int checkLoginId(String loginId);

    // 기본 정보 관리
    void insertAdmin(AdminVO vo);
    void updateAdmin(AdminVO vo);
    void deleteAdmin(Long adminId);

    // IP 관리 (삭제 후 재등록 방식 사용)
    List<String> selectIpsByAdminId(Long adminId);
    void insertIp(@Param("adminId") Long adminId, @Param("ipAddress") String ipAddress, @Param("memo") String memo);
    void deleteIpsByAdminId(Long adminId);

    // 이메일 관리 (삭제 후 재등록 방식 사용)
    List<AdminEmailVO> selectEmailsByAdminId(Long adminId);
    void insertEmail(AdminEmailVO vo);
    void deleteEmailsByAdminId(Long adminId);
}