package com.byd.mapper;

import com.byd.vo.ParticipantVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EventMapper {
    // 신청 정보 저장
    void insertParticipant(ParticipantVO participantVO);

    // 연락처로 기존 신청 정보 조회
    ParticipantVO getParticipantByPhone(String phone);
}