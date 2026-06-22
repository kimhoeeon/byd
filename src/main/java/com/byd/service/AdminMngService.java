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

    // 차종별 최대 예약 가능 인원 
    private final Map<String, Integer> carCapacityMap = new HashMap<String, Integer>() {{
        put("BYD DOLPHIN", 2);
        put("BYD ATTO 3", 2);
        put("BYD SEAL", 2);
        put("BYD SEALION 7", 2);
    }};

    public int getCarCapacity(String carModel) {
        if(carModel == null || carModel.isEmpty()) return 2;
        return carCapacityMap.getOrDefault(carModel.toUpperCase(), 2);
    }

    // 현재 유효한(노쇼가 아닌) 예약자 수 조회
    public int getValidReservationCount(java.util.Date regDate, String testDriveTime, String carModel) {
        return adminMngMapper.getValidReservationCount(regDate, testDriveTime, carModel);
    }
    
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

    public void updateSignatureAndArrival(int seq, String signatureData, String adminCode) {
        adminMngMapper.updateSignatureAndArrival(seq, signatureData, adminCode);
    }

    public void updateNoshow(int seq) {
        adminMngMapper.updateNoshow(seq);
    }

    public void cancelNoshow(int seq) {
        adminMngMapper.cancelNoshow(seq);
    }
}