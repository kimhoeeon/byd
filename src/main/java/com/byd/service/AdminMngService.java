package com.byd.service;

import com.byd.mapper.AdminMngMapper;
import com.byd.vo.AdminEmailVO;
import com.byd.vo.AdminVO;
import com.byd.vo.Criteria;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminMngService {

    private final AdminMngMapper adminMngMapper;
    private final PasswordEncoder passwordEncoder;

    public List<AdminVO> getAdminList(Criteria cri) {
        return adminMngMapper.selectAdminList(cri);
    }

    public int getAdminCount(Criteria cri) {
        return adminMngMapper.countAdminList(cri);
    }

    public AdminVO getAdmin(Long adminId) {
        AdminVO vo = adminMngMapper.selectAdminById(adminId);
        if (vo != null) {
            vo.setAllowedIpList(adminMngMapper.selectIpsByAdminId(adminId));
            vo.setEmailList(adminMngMapper.selectEmailsByAdminId(adminId));
        }
        return vo;
    }

    public boolean isIdDuplicate(String loginId) {
        return adminMngMapper.checkLoginId(loginId) > 0;
    }

    @Transactional
    public void saveAdmin(AdminVO vo) {
        // 1. 기본 정보 저장
        if (vo.getAdminId() == null) {
            // 신규: 비번 암호화 필수
            vo.setPassword(passwordEncoder.encode(vo.getPassword()));
            adminMngMapper.insertAdmin(vo);
        } else {
            // 수정: 비번 변경 시에만 암호화
            if (vo.getPassword() != null && !vo.getPassword().isEmpty()) {
                vo.setPassword(passwordEncoder.encode(vo.getPassword()));
            } else {
                vo.setPassword(null); // 비번 변경 안 함
            }
            adminMngMapper.updateAdmin(vo);

            // 하위 데이터 초기화 (삭제 후 재등록 전략)
            adminMngMapper.deleteIpsByAdminId(vo.getAdminId());
            adminMngMapper.deleteEmailsByAdminId(vo.getAdminId());
        }

        // 2. IP 저장
        if (vo.getAllowedIpList() != null) {
            for (String ip : vo.getAllowedIpList()) {
                if (ip != null && !ip.trim().isEmpty()) {
                    adminMngMapper.insertIp(vo.getAdminId(), ip.trim(), "");
                }
            }
        }

        // 3. 이메일 저장
        if (vo.getEmailList() != null) {
            for (AdminEmailVO email : vo.getEmailList()) {
                if (email.getEmailAddress() != null && !email.getEmailAddress().trim().isEmpty()) {
                    email.setAdminId(vo.getAdminId());
                    adminMngMapper.insertEmail(email);
                }
            }
        }
    }

    @Transactional
    public void deleteAdmin(Long adminId) {
        adminMngMapper.deleteIpsByAdminId(adminId);
        adminMngMapper.deleteEmailsByAdminId(adminId);
        adminMngMapper.deleteAdmin(adminId);
    }
}