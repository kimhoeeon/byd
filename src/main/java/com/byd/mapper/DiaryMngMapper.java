package com.byd.mapper;

import com.byd.vo.Criteria;
import com.byd.vo.DiaryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface DiaryMngMapper {

    // 일기 목록 조회 (페이징 + 검색)
    // 검색 조건: 작성자 닉네임, 내용
    List<DiaryVO> selectDiaryList(Criteria cri);

    // 전체 개수 (페이징용)
    int getTotalCount(Criteria cri);

    // 일기 상세 조회
    DiaryVO selectDiaryById(Long diaryId);

    // 일기 숨김 처리 (관리자 권한으로 상태 변경 -> BLIND)
    void blindDiary(Long diaryId);

    // 일기 삭제 (관리자 권한으로 상태 변경 -> DELETED)
    void deleteDiary(Long diaryId);

    // 관리자 화면 전용 특정 회원의 직관 기록 이력 조회
    List<DiaryVO> selectMemberDiaryHistory(Long memberId);

    // 현재 인기 게시물로 등록된 개수 조회
    int getPopularDiaryCount();

    // 인기 게시물 상태 업데이트
    void updatePopularStatus(@Param("diaryId") Long diaryId, @Param("status") String status);

}