package com.byd.mapper;

import com.byd.vo.Criteria;
import com.byd.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface MemberMngMapper {
    // 페이징 + 검색이 적용된 목록 조회
    List<MemberVO> selectMemberListWithPaging(Criteria cri);

    // 전체 데이터 개수 (페이징 계산용)
    int getTotalCount(Criteria cri);

    // 상세 조회
    MemberVO selectMemberById(Long memberId);

    // 상태 변경
    void updateMemberStatus(@Param("memberId") Long memberId, @Param("status") String status);

    void updatePassword(MemberVO member);

    List<MemberVO> selectMemberListForExcel();

    void updateAdminMemberInfo(MemberVO member);
}