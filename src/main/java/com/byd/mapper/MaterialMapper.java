package com.byd.mapper;

import com.byd.vo.MaterialHistoryVO;
import com.byd.vo.MaterialVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MaterialMapper {
    List<MaterialVO> getMaterialList(@Param("searchDate") String searchDate,
                                     @Param("category") String category,
                                     @Param("keyword") String keyword,
                                     @Param("stockStatus") String stockStatus);

    List<String> getCategoryList();

    MaterialVO getMaterialBySeq(int seq);

    void insertMaterial(MaterialVO vo);

    void updateMaterial(MaterialVO vo);

    void updateMaterialQty(@Param("seq") int seq, @Param("qtyModifier") int qtyModifier);

    void insertHistory(MaterialHistoryVO vo);

    List<MaterialHistoryVO> getHistoryList(int materialSeq);

    void deleteHistoryByMaterialSeq(int materialSeq);

    void deleteMaterial(int seq);
}