package com.byd.service;

import com.byd.mapper.AdminMngMapper;
import com.byd.vo.AdminVO;
import com.byd.vo.DailyStatsVO;
import com.byd.vo.ParticipantVO;
import com.byd.vo.StatsVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminMngService {

    private final AdminMngMapper adminMngMapper;

    public AdminVO getAdminById(String adminId) {
        return adminMngMapper.getAdminById(adminId);
    }

    public List<ParticipantVO> getParticipantList() {
        return adminMngMapper.getParticipantList();
    }

    public StatsVO getDashboardSummary() {
        return adminMngMapper.getDashboardSummary();
    }

    // 최근 7일의 라벨과 데이터를 Chart.js 양식에 맞게 반환
    public Map<String, Object> getChartData() {
        List<String> labels = new ArrayList<>();
        List<Integer> eventData = new ArrayList<>();
        List<Integer> driveData = new ArrayList<>();

        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.dd");

        // 1. 최근 7일 날짜 라벨 및 기본값 0 세팅
        for (int i = 6; i >= 0; i--) {
            labels.add(today.minusDays(i).format(formatter));
            eventData.add(0);
            driveData.add(0);
        }

        // 2. DB에서 그룹핑된 일별 데이터 가져오기
        List<DailyStatsVO> dbStats = adminMngMapper.getDailyStats();

        // 3. 가져온 데이터를 해당 날짜 인덱스에 맞춰 매핑
        for (DailyStatsVO stat : dbStats) {
            int index = labels.indexOf(stat.getRegDateStr());
            if (index != -1) {
                if ("EVENT".equals(stat.getEntryType())) {
                    eventData.set(index, stat.getCnt());
                } else if ("DRIVE".equals(stat.getEntryType())) {
                    driveData.set(index, stat.getCnt());
                }
            }
        }

        Map<String, Object> chartMap = new HashMap<>();
        chartMap.put("labels", labels);
        chartMap.put("eventData", eventData);
        chartMap.put("driveData", driveData);

        return chartMap;
    }

    public List<ParticipantVO> getParticipantListByType(String entryType) {
        return adminMngMapper.getParticipantListByType(entryType);
    }

    public void updateQrScanTime(int seq) {
        adminMngMapper.updateQrScanTime(seq);
    }

    public ParticipantVO getParticipantBySeq(int seq) {
        return adminMngMapper.getParticipantBySeq(seq);
    }
}