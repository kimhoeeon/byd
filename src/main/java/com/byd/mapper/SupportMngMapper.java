package com.byd.mapper;

import com.byd.vo.Criteria;
import com.byd.vo.FaqVO;
import com.byd.vo.InquiryVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface SupportMngMapper {
    // --- FAQ ---
    List<FaqVO> selectFaqList();

    FaqVO selectFaqById(Long faqId);

    void insertFaq(FaqVO vo);

    void updateFaq(FaqVO vo);

    void deleteFaq(Long faqId);

    // --- 1:1 문의 ---
    // 목록 (검색+페이징)
    List<InquiryVO> selectInquiryList(Criteria cri);

    // 전체 개수
    int getInquiryTotalCount(Criteria cri);

    // 상세 조회
    InquiryVO selectInquiryById(Long inquiryId);

    // 답변 등록/수정
    void updateInquiryAnswer(InquiryVO vo);
}