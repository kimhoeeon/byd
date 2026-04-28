package com.byd.mapper;

import com.byd.dto.WinYoAnalysisDTO;
import com.byd.vo.DiaryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DiaryMapper {

    // 승률 분석용 유효 일기 목록 조회
    List<DiaryVO> selectVerifiedDiaries(Long memberId);

    // 일기 저장
    int insertDiary(DiaryVO diary);

    // 일기 상세 조회
    DiaryVO selectDiaryById(Long diaryId);

    // 중복 작성 방지용 조회
    DiaryVO selectDiaryByMemberAndGame(@Param("memberId") Long memberId, @Param("gameId") Long gameId);

    // 일기 수정
    int updateDiary(DiaryVO diary);

    // [명예의 전당] 승요 랭킹 TOP 10 조회
    List<WinYoAnalysisDTO> selectWinYoRankingTop10();

    List<DiaryVO> selectRecentDiaries(Long memberId);

    List<DiaryVO> selectDiaryList(Long memberId);

    List<DiaryVO> selectFriendDiaryList(Long memberId);

    List<Long> selectVisitedStadiumIds(Long memberId);

    // 일기 상태 변경 (삭제 등)
    int updateDiaryStatus(@Param("diaryId") Long diaryId,
                          @Param("memberId") Long memberId,
                          @Param("status") String status);

    List<DiaryVO> selectAllFriendDiaries(Long memberId);

    // 공유 UUID 업데이트
    int updateShareUuid(@Param("diaryId") Long diaryId, @Param("uuid") String uuid);

    // UUID로 일기 조회 (비회원용)
    DiaryVO selectDiaryByUuid(String uuid);

    int countTotalDiaries();

    int countTodayDiaries();

    List<DiaryVO> selectFollowerDiaries(Long memberId);

    List<DiaryVO> selectAllPublicDiaries();

    List<DiaryVO> selectMemberPublicDiaries(Long targetMemberId);

    // 팔로워 + 팔로잉 합산 일기 조회
    List<DiaryVO> selectRelatedDiaries(Long memberId);

    // 조회수 1 증가
    void updateViewCount(Long diaryId);

    // 사용자가 해당 날짜에 작성한 일기 개수 조회
    int countDiaryByDate(@Param("memberId") Long memberId, @Param("gameDate") String gameDate);

    // 사용자의 팔로우+팔로워 총합 조회
    int countFollowAndFollower(Long memberId);

    // 인기 게시물 조회 (is_popular = 'Y')
    List<DiaryVO> selectPopularDiaries(@Param("limit") int limit);

    // 랜덤 전체공개 게시물 조회 (is_popular = 'N')
    List<DiaryVO> selectRandomPublicDiaries(@Param("limit") int limit);

    // [추가] 특정 날짜 및 팀 필터링 기반 일기 조회 (페이징 포함)
    List<DiaryVO> selectDiariesByDateAndTeam(@Param("date") String date,
                                             @Param("teamCode") String teamCode,
                                             @Param("limit") int limit,
                                             @Param("offset") int offset);

    // [추가] 특정 월에 일기가 작성된 날짜 리스트 조회
    List<String> selectDiaryDatesByMonth(String month);
}