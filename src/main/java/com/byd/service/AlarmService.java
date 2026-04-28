package com.byd.service;

import com.byd.mapper.AlarmMapper;
import com.byd.vo.AlarmVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AlarmService {

    private final AlarmMapper alarmMapper;

    // 목록 조회
    public List<AlarmVO> getMyAlarms(Long memberId) {
        return alarmMapper.selectAlarmList(memberId);
    }

    // 알림 발송 (다른 서비스에서 호출 가능)
    @Transactional
    public void sendAlarm(Long memberId, String category, String title, String content, String url) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemberId(memberId);
        alarm.setCategory(category);
        alarm.setTitle(title);
        alarm.setContent(content);
        alarm.setRedirectUrl(url);
        alarmMapper.insertAlarm(alarm);
    }

    // 읽음 처리
    @Transactional
    public void readAlarm(Long alarmId, Long memberId) {
        alarmMapper.updateReadStatus(alarmId, memberId);
    }

    // 오래된 알림 삭제 (스케줄러용)
    @Transactional
    public void deleteExpiredAlarms() {
        int deletedCount = alarmMapper.deleteOldAlarms();
        // 로그가 필요하면 @Slf4j 추가 후 log.info("삭제된 알림 수: " + deletedCount);
    }

    public int getUnreadCount(Long memberId) {
        return alarmMapper.selectUnreadCount(memberId);
    }

}