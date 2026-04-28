package com.byd.mapper;

import com.byd.vo.PushLogVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PushMngMapper {
    // 발송 이력 목록 조회
    List<PushLogVO> selectPushLogList();

    // 발송 이력 저장
    void insertPushLog(PushLogVO vo);

    // 전체 회원 수 조회 (발송 대상 수 집계용)
    int countAllMembers();

    List<String> selectTargetFcmTokens(@Param("targetType") String targetType, @Param("targetTeam") String targetTeam);

    List<Long> selectTargetMemberIds(@Param("targetType") String targetType, @Param("targetTeam") String targetTeam);
}