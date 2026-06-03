package com.byd.service;
import com.byd.mapper.MaterialMapper;
import com.byd.vo.MaterialHistoryVO;
import com.byd.vo.MaterialVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MaterialService {

    private final MaterialMapper materialMapper;

    public List<MaterialVO> getMaterialList(String searchDate, String category, String keyword, String stockStatus) {
        return materialMapper.getMaterialList(searchDate, category, keyword, stockStatus);
    }

    public List<String> getCategoryList() {
        return materialMapper.getCategoryList();
    }

    public void insertMaterial(MaterialVO vo) {
        materialMapper.insertMaterial(vo);
    }

    @Transactional
    public void updateMaterial(MaterialVO vo) {
        MaterialVO oldData = materialMapper.getMaterialBySeq(vo.getSeq());
        if (oldData == null) throw new IllegalArgumentException("물자를 찾을 수 없습니다.");

        // 세팅 수량을 줄였을 때, 이미 불출된 수량보다 작아져서 잔여고가 마이너스가 되는 현상 차단
        int newTotalQty = oldData.getTotalQty() + (vo.getInitQty() - oldData.getInitQty());
        if (newTotalQty < 0) {
            throw new IllegalArgumentException("이미 사용된 수량이 있어 세팅 수량을 그 이하로 줄일 수 없습니다.");
        }
        materialMapper.updateMaterial(vo);
    }

    @Transactional
    public void processInOut(MaterialHistoryVO historyVO) {
        MaterialVO material = materialMapper.getMaterialBySeq(historyVO.getMaterialSeq());
        if (material == null) throw new IllegalArgumentException("존재하지 않는 물자입니다.");

        int modifier = historyVO.getChangeQty();
        if ("OUT".equals(historyVO.getChangeType())) {
            if (material.getTotalQty() < historyVO.getChangeQty()) {
                throw new IllegalArgumentException("현재고(" + material.getTotalQty() + ")보다 많은 수량을 출고할 수 없습니다.");
            }
            modifier = -historyVO.getChangeQty();
        }

        // 1. 이력 저장
        materialMapper.insertHistory(historyVO);
        // 2. 마스터 재고 업데이트
        materialMapper.updateMaterialQty(historyVO.getMaterialSeq(), modifier);
    }

    public List<MaterialHistoryVO> getHistoryList(int materialSeq) {
        return materialMapper.getHistoryList(materialSeq);
    }

    public void deleteMaterial(int seq) {
        materialMapper.deleteHistoryByMaterialSeq(seq); // 1. 찌꺼기 이력 데이터 먼저 청소
        materialMapper.deleteMaterial(seq);             // 2. 마스터 데이터 삭제
    }
}