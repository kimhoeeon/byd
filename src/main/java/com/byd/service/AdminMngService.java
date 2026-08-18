package com.byd.service;

import com.byd.mapper.AdminMngMapper;
import com.byd.vo.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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

    public List<ParticipantVO> getList(Criteria cri) {
        return adminMngMapper.getList(cri);
    }

    public List<ParticipantVO> getAllList(Criteria cri) {
        return adminMngMapper.getAllList(cri);
    }

    public int getTotalCount(Criteria cri) {
        return adminMngMapper.getTotalCount(cri);
    }

    public ParticipantVO getParticipantBySeq(int seq) {
        return adminMngMapper.getParticipantBySeq(seq);
    }

    public void deleteParticipant(int seq) {
        adminMngMapper.deleteParticipant(seq);
    }

    public void updateGiftStatus(int seq, String status) {
        adminMngMapper.updateGiftStatus(seq, status);
    }

    public Map<String, Object> getDashboardSummaryStats() {
        Map<String, Object> stats = new HashMap<>();

        int totalParticipants = adminMngMapper.getTotalParticipantsCount();
        int todayParticipants = adminMngMapper.getTodayParticipantsCount();
        int todayGifts = adminMngMapper.getTodayGiftsCount();

        int todayQuizCount = adminMngMapper.getTodayQuizCount();
        int quizPerfectCount = adminMngMapper.getQuizPerfectCount();
        int quizFailCount = adminMngMapper.getQuizFailCount();

        stats.put("totalCnt", totalParticipants);
        stats.put("todayCnt", todayParticipants);
        stats.put("giftCnt", todayGifts);
        stats.put("challengeCnt", todayQuizCount);
        stats.put("quizPerfectCount", quizPerfectCount);
        stats.put("quizFailCount", quizFailCount == 0 && quizPerfectCount == 0 ? 1 : quizFailCount);

        return stats;
    }

    public List<Map<String, Object>> getShopDistributionStats() {
        List<Map<String, Object>> rawList = adminMngMapper.getShopDistributionStats();
        int total = rawList.stream().mapToInt(m -> Integer.parseInt(String.valueOf(m.get("CNT")))).sum();

        if (total > 0) {
            for (Map<String, Object> map : rawList) {
                int cnt = Integer.parseInt(String.valueOf(map.get("CNT")));
                long per = Math.round((double) cnt / total * 100);
                map.put("PER", per);
            }
        }
        return rawList;
    }

    public List<Map<String, Object>> getHourlyCheckinStats() {
        return adminMngMapper.getHourlyCheckinStats();
    }

    public List<Map<String, Object>> getCarModelDistributionStats() {
        return adminMngMapper.getCarModelDistributionStats();
    }

    public List<Map<String, Object>> getDailyCheckinStats() {
        return adminMngMapper.getDailyCheckinStats();
    }

}