package com.byd.mapper;

import com.byd.vo.ParticipantVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface EventMapper {

    ParticipantVO getParticipantByPhone(String phone);

    ParticipantVO getParticipantBySeq(int seq);

    void insertParticipant(ParticipantVO participantVO);

    ParticipantVO getParticipantByPhoneToday(String phone);

    List<Map<String, Object>> getDriveTimeCountToday();

    int getDriveTimeCount(String testDriveTime);

    void updateParticipant(@Param("vo") ParticipantVO vo, @Param("updateRegDate") boolean updateRegDate);

    int checkTestDriveHistory(@Param("phone") String phone, @Param("seq") Integer seq);

}