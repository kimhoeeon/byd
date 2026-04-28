package com.byd.mapper;

import com.byd.vo.ContentClickLogVO;
import com.byd.vo.EventVO;
import com.byd.vo.TeamContentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ContentMngMapper {
    // 1. 이벤트 관리
    List<EventVO> selectEventList();
    List<EventVO> selectActiveEventList();   // 사용자용
    EventVO selectEventById(Long eventId);
    void insertEvent(EventVO event);
    void updateEvent(EventVO event);
    void deleteEvent(Long eventId);

    // 2. 팀 콘텐츠 관리
    List<TeamContentVO> selectTeamContentList(@Param("teamCode") String teamCode);
    List<TeamContentVO> selectActiveTeamContentList(@Param("teamCode") String teamCode, @Param("limit") Integer limit);// 사용자용
    TeamContentVO selectTeamContentById(Long contentId);
    void insertTeamContent(TeamContentVO vo);
    void updateTeamContent(TeamContentVO vo);
    void deleteTeamContent(Long contentId);

    // 순서 변경 대상 찾기 (같은 구단 내에서)
    // direction이 UP이면 내 위(작은것 중 최대값), DOWN이면 내 아래(큰것 중 최소값) 조회
    TeamContentVO selectTargetContentForSwap(@Param("teamCode") String teamCode,
                                             @Param("currentSortOrder") int currentSortOrder,
                                             @Param("direction") String direction);
    void updateSortOrder(@Param("contentId") Long contentId, @Param("sortOrder") int sortOrder);

    // 통계 관련 (Map으로 반환)
    List<Map<String, Object>> selectAgeStats(Long contentId);
    List<Map<String, Object>> selectDailyStats(Long contentId);

    // 사용자 기능
    void increaseClickCount(@Param("contentId") Long contentId);
    TeamContentVO selectRandomActiveContent(@Param("teamCode") String teamCode);

    Integer selectMaxSortOrder();

    // 콘텐츠 클릭 로그 저장
    void insertClickLog(ContentClickLogVO log);

    void deleteContentCommentByAdmin(Long commentId);

}