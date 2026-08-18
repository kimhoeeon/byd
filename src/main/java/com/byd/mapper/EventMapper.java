package com.byd.mapper;

import com.byd.vo.ParticipantVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface EventMapper {

    // 휴대폰 번호로 기존 신청 내역 조회
    ParticipantVO getParticipantByPhone(String phone);

    // 고유번호(Seq)로 모바일 티켓용 정보 조회
    ParticipantVO getParticipantBySeq(int seq);

    // 신규 이벤트 참여 신청 데이터 삽입
    void insertParticipant(ParticipantVO participantVO);

    // 오늘 이미 신청했는지 확인용
    ParticipantVO getParticipantByPhoneToday(String phone);

    // 기존 신청자 정보 업데이트
    void updateParticipant(@Param("vo") ParticipantVO vo, @Param("updateRegDate") boolean updateRegDate);
}