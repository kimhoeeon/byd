package com.byd.mapper;

import com.byd.vo.AlarmVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AlarmMapper {
    List<AlarmVO> selectAlarmList(Long memberId);

    int insertAlarm(AlarmVO alarm);

    int updateReadStatus(@Param("alarmId") Long alarmId, @Param("memberId") Long memberId);

    int deleteOldAlarms();

    int selectUnreadCount(Long memberId);
}