package com.byd.mapper;

import com.byd.vo.GameVO;
import com.byd.vo.StadiumVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GameMapper {

    /**
     * 경기 데이터 저장 (API 크롤링 시 사용)
     * api_game_id가 같으면 UPDATE, 없으면 INSERT
     */
    int upsertGame(GameVO game);

    /**
     * [관리자용/검증용] 특정 날짜에 두 팀 간의 경기가 있는지 조회
     * 용도: 수동 등록 시 중복 체크
     */
    GameVO selectGameByDateAndTeams(@Param("gameDate") String gameDate,
                                    @Param("homeTeam") String homeTeam,
                                    @Param("awayTeam") String awayTeam);

    /**
     * [메인화면용] 특정 날짜의 '내 팀' 경기 조회
     * 용도: 로그인 유저의 오늘 경기 정보 (홈/원정 무관하게 조회)
     */
    GameVO selectGameByDateAndTeam(@Param("gameDate") String gameDate,
                                   @Param("teamCode") String teamCode);

    /**
     * [메인화면용] 특정 날짜의 전체 경기 조회
     * 용도: 타구장 소식 및 비로그인 유저용
     */
    List<GameVO> selectGamesByDate(@Param("gameDate") String gameDate, @Param("memberId") Long memberId);


    GameVO selectTodayGameByTeam(String teamCode);

    List<GameVO> selectTodayGame(String teamCode);

    GameVO selectGameById(Long gameId);

    void updateGameScoreAndStatus(GameVO game);

    GameVO selectGameByApiId(String apiGameId);

    StadiumVO selectStadiumById(Integer stadiumId);

    // [관리자] 월별 경기 목록 조회 (YYYY-MM)
    List<GameVO> selectGameListByMonth(@Param("yearMonth") String yearMonth);

    int countTodayGames();

    List<StadiumVO> selectAllStadiums();

    int updateGameStatusOnly(GameVO game);

    // 자정 넘어가는 연장전 대비 (어제~오늘 진행/예정 경기 조회)
    List<GameVO> selectOngoingGames();

}