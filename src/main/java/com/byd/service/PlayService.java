package com.byd.service;

import com.byd.mapper.GameMapper;
import com.byd.vo.GameVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class PlayService {

    private final GameMapper gameMapper;

    // 특정 날짜의 경기 목록 조회
    public List<GameVO> getGameList(Long memberId, String date) {
        // 더 이상 예측 정보를 덧붙이지 않고 순수 경기 목록만 반환
        return gameMapper.selectGamesByDate(date, memberId);
    }

    // 특정 월의 경기가 있는 날짜 목록 조회
    public List<String> getGameDatesInMonth(String yearMonth) {
        List<GameVO> games = gameMapper.selectGameListByMonth(yearMonth);

        // 날짜 중복 제거 (Set 사용)
        Set<String> dateSet = new HashSet<>();
        if (games != null) {
            for (GameVO game : games) {
                dateSet.add(game.getGameDate()); // yyyy-MM-dd
            }
        }
        // 리스트로 변환하여 반환
        return new ArrayList<>(dateSet);
    }
}