package com.byd.mapper;

import com.byd.vo.WinYoMentionVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface WinYoMentionMapper {
    List<WinYoMentionVO> selectMentionList(@Param("filterCategory") String filterCategory, @Param("searchType") String searchType, @Param("searchWord") String searchWord);

    WinYoMentionVO selectMention(Long mentionId);

    void updateMention(WinYoMentionVO vo);

    // 사용자 분석용: 범위로 멘트 조회
    WinYoMentionVO selectMentionByValue(@Param("category") String category, @Param("value") Integer value);

    // 사용자 분석용: 코드로 멘트 조회 (최근 흐름 등)
    WinYoMentionVO selectMentionByCode(@Param("category") String category, @Param("conditionCode") String conditionCode);
}