package com.byd.service;

import com.byd.mapper.AdminMngMapper;
import com.byd.vo.*;
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

    public List<ParticipantVO> getAllParticipantList() {
        return adminMngMapper.getAllParticipantList();
    }

    public ParticipantVO getParticipantBySeq(int seq) {
        return adminMngMapper.getParticipantBySeq(seq);
    }

    public void updateArrivalStatus(int seq) {
        adminMngMapper.updateArrivalStatus(seq);
    }

    public void cancelArrivalStatus(int seq) {
        adminMngMapper.cancelArrivalStatus(seq);
    }

    // [추가] 관리자 목록 조회
    public List<ParticipantVO> getList(Criteria cri) {
        return adminMngMapper.getList(cri);
    }

    // [추가] 관리자 목록 전체 개수 (페이징용)
    public int getTotalCount(Criteria cri) {
        return adminMngMapper.getTotalCount(cri);
    }

    public StatsVO getDashboardSummary() {
        return adminMngMapper.getDashboardSummary();
    }

    public Map<String, Object> getChartData() {
        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();

        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM.dd");

        for (int i = 6; i >= 0; i--) {
            labels.add(today.minusDays(i).format(formatter));
            data.add(0);
        }

        List<DailyStatsVO> dbStats = adminMngMapper.getDailyStats();
        for (DailyStatsVO stat : dbStats) {
            int index = labels.indexOf(stat.getRegDateStr());
            if (index != -1) {
                data.set(index, stat.getCnt());
            }
        }

        Map<String, Object> chartMap = new HashMap<>();
        chartMap.put("labels", labels);
        chartMap.put("data", data);
        return chartMap;
    }
}