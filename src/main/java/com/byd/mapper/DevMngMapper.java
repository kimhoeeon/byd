package com.byd.mapper;

import com.byd.vo.DevCommentVO;
import com.byd.vo.DevFileVO;
import com.byd.vo.DevRequestVO;
import com.byd.vo.Criteria; // 검색/페이징용 (기존 클래스 활용)
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DevMngMapper {

    // --- 요청글 관리 ---
    // 목록 조회 (검색+필터)
    List<DevRequestVO> selectRequestList(Criteria cri);

    int getTotalRequestCount(Criteria cri);

    // 상세 조회
    DevRequestVO selectRequestById(Long reqId);

    // 등록/수정
    void insertRequest(DevRequestVO vo);

    void updateRequest(DevRequestVO vo); // 제목, 내용, 긴급여부 등

    void updateRequestStatus(DevRequestVO vo); // 상태, 처리예정일 변경

    // --- 댓글 관리 ---
    List<DevCommentVO> selectCommentList(Long reqId);

    void insertComment(DevCommentVO vo);

    void updateComment(DevCommentVO vo);

    void deleteComment(Long commentId); // del_yn = 'Y'

    // --- 파일 관리 ---
    void insertFile(DevFileVO vo);

    List<DevFileVO> selectFileList(@Param("targetType") String targetType, @Param("targetId") Long targetId);

    void deleteFile(Long fileId);

    // --- 알림 대상 조회 (핵심) ---
    // 1. 관리자 이메일 조회 (조건: 역할 + 요청카테고리)
    List<String> selectAdminEmailsByType(@Param("type") String type);

    // 2. 특정 작성자(발주사)의 이메일 조회
    List<String> selectWriterEmails(Long adminId);
}