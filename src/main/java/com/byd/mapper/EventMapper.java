package com.byd.mapper;

import com.byd.vo.ParticipantVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface EventMapper {

    // 연락처로 기존 신청 정보 조회
    ParticipantVO getParticipantByPhone(String phone);

    ParticipantVO getParticipantBySeq(int seq);

    // 신청 정보 저장
    void insertParticipant(ParticipantVO participantVO);

    ParticipantVO getParticipantByPhoneToday(String phone);

    // 시간대별 인원 카운트 맵 리스트 반환
    List<Map<String, Object>> getDriveTimeCountToday();

    // 특정 시간대의 오늘 예약자 수 조회 (정원 초과 검증용)
    int getDriveTimeCount(String testDriveTime);

    // 마이페이지 상세 정보 수정
    void updateParticipant(ParticipantVO participantVO);

}