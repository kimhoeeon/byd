package com.byd.mapper;

import com.byd.vo.MaterialHistoryVO;
import com.byd.vo.MaterialVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MaterialMapper {
    // [수정] 다중 검색 필터 적용
    List<MaterialVO> getMaterialList(@Param("searchDate") String searchDate,
                                     @Param("category") String category,
                                     @Param("keyword") String keyword,
                                     @Param("stockStatus") String stockStatus);

    // [추가] 등록된 카테고리 목록 중복 없이 조회
    List<String> getCategoryList();

    MaterialVO getMaterialBySeq(int seq);

    void insertMaterial(MaterialVO vo);

    void updateMaterialQty(@Param("seq") int seq, @Param("qtyModifier") int qtyModifier);

    void insertHistory(MaterialHistoryVO vo);

    List<MaterialHistoryVO> getHistoryList(int materialSeq);

    void deleteHistoryByMaterialSeq(int materialSeq);

    void deleteMaterial(int seq);
}