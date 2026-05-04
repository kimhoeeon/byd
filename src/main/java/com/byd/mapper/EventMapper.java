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

    void updateParticipant(ParticipantVO participantVO);

    int checkTestDriveHistory(@Param("phone") String phone, @Param("seq") Integer seq);

}