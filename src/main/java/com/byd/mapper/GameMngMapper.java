package com.byd.mapper;

import com.byd.vo.GameVO;
import com.byd.vo.StadiumVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface GameMngMapper {
    // 월별 경기 조회
    List<GameVO> selectGameListByMonth(String yearMonth);

    // 단건 조회
    GameVO selectGameById(Long gameId);

    // 수동 등록
    void insertGame(GameVO game);

    // 수동 수정
    void updateGame(GameVO game);

    // 삭제
    void deleteGame(Long gameId);

    List<StadiumVO> selectStadiumList();
}