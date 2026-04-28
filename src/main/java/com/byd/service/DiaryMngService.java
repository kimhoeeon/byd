package com.byd.service;

import com.byd.mapper.DiaryMngMapper;
import com.byd.vo.Criteria;
import com.byd.vo.DiaryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DiaryMngService {

    private final DiaryMngMapper diaryMngMapper;

    public List<DiaryVO> getDiaryList(Criteria cri) {
        return diaryMngMapper.selectDiaryList(cri);
    }

    public int getTotal(Criteria cri) {
        return diaryMngMapper.getTotalCount(cri);
    }

    public DiaryVO getDiary(Long diaryId) {
        return diaryMngMapper.selectDiaryById(diaryId);
    }

    @Transactional
    public void blindDiary(Long diaryId) {
        diaryMngMapper.blindDiary(diaryId);
    }

    @Transactional
    public void deleteDiary(Long diaryId) {
        diaryMngMapper.deleteDiary(diaryId);
    }

    public List<DiaryVO> getMemberDiaryHistory(Long memberId) {
        return diaryMngMapper.selectMemberDiaryHistory(memberId);
    }

    public int getPopularDiaryCount() {
        return diaryMngMapper.getPopularDiaryCount();
    }

    @Transactional
    public void updatePopularStatus(Long diaryId, String status) {
        diaryMngMapper.updatePopularStatus(diaryId, status);
    }

}