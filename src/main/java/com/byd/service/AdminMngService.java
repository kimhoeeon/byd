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

    public ParticipantVO getParticipantBySeq(int seq) {
        return adminMngMapper.getParticipantBySeq(seq);
    }

    public ParticipantVO getParticipantByQrCodeUrl(String qrCodeUrl) {
        return adminMngMapper.getParticipantByQrCodeUrl(qrCodeUrl);
    }

    public void updateArrivalStatus(int seq, String adminCode) {
        adminMngMapper.updateArrivalStatus(seq, adminCode);
    }

    public void cancelArrivalStatus(int seq, String columnName) {
        adminMngMapper.cancelArrivalStatus(seq, columnName);
    }

    public List<ParticipantVO> getList(Criteria cri) {
        return adminMngMapper.getList(cri);
    }

    public List<ParticipantVO> getAllList(Criteria cri) {
        return adminMngMapper.getAllList(cri);
    }

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