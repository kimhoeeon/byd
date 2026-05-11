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
        Map<String, Object> chartMap = new HashMap<>();

        // 1. 기존 7일 추이
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
        chartMap.put("dailyLabels", labels);
        chartMap.put("dailyData", data);

        // 2. 신규 대시보드 통계 추가
        chartMap.put("carStats", adminMngMapper.getCarModelStats());
        chartMap.put("timeStats", adminMngMapper.getTimeStats());
        chartMap.put("shopStats", adminMngMapper.getShopStats());

        // Null 방어 처리
        Map<String, Object> att = adminMngMapper.getAttendanceStats();
        if (att == null) {
            att = new HashMap<>();
            att.put("challengeCnt", 0);
            att.put("driveCnt", 0);
            att.put("giftCnt", 0);
        } else {
            att.put("challengeCnt", att.get("challengeCnt") != null ? att.get("challengeCnt") : 0);
            att.put("driveCnt", att.get("driveCnt") != null ? att.get("driveCnt") : 0);
            att.put("giftCnt", att.get("giftCnt") != null ? att.get("giftCnt") : 0);
        }
        chartMap.put("attStats", att);

        return chartMap;
    }

    public void deleteParticipant(int seq) {
        adminMngMapper.deleteParticipant(seq);
    }

}