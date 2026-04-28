package com.byd.service;

import com.byd.mapper.SupportMngMapper;
import com.byd.vo.Criteria;
import com.byd.vo.FaqVO;
import com.byd.vo.InquiryVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class SupportMngService {

    private final SupportMngMapper supportMapper;
    private final AlarmService alarmService;

    public List<FaqVO> getFaqList() {
        return supportMapper.selectFaqList();
    }

    public FaqVO getFaq(Long faqId) {
        return supportMapper.selectFaqById(faqId);
    }

    @Transactional
    public void saveFaq(FaqVO vo) {
        if (vo.getFaqId() == null) supportMapper.insertFaq(vo);
        else supportMapper.updateFaq(vo);
    }

    @Transactional
    public void deleteFaq(Long faqId) {
        supportMapper.deleteFaq(faqId);
    }

    // --- 1:1 문의 ---
    public List<InquiryVO> getInquiryList(Criteria cri) {
        return supportMapper.selectInquiryList(cri);
    }

    public int getInquiryTotal(Criteria cri) {
        return supportMapper.getInquiryTotalCount(cri);
    }

    public InquiryVO getInquiry(Long inquiryId) {
        return supportMapper.selectInquiryById(inquiryId);
    }

    /**
     * 답변 등록 및 알림 발송
     */
    @Transactional
    public void answerInquiry(InquiryVO vo) {
        // 1. 답변 내용 업데이트
        supportMapper.updateInquiryAnswer(vo);

        // 2. 알림 발송을 위해 원본 데이터 조회 (작성자 ID 필요)
        try {
            InquiryVO origin = supportMapper.selectInquiryById(vo.getInquiryId());

            if (origin != null) {
                // 알림 내용 구성
                String title = "1:1 문의 답변";
                String content = "문의하신 내용에 답변이 등록되었습니다.";
                // 사용자 앱 내 문의 내역 페이지 URL (예시)
                String url = "/member/mypage/inquiry";

                // 알림 발송 (수신자ID, 타입, 내용, URL)
                // 타입은 'SYSTEM', 'NOTICE' 등 DB에 정의된 코드 사용
                alarmService.sendAlarm(origin.getMemberId(), "SYSTEM", title, content, url);
            }
        } catch (Exception e) {
            // 알림 발송 실패가 답변 등록 트랜잭션을 롤백시키지 않도록 로깅만 처리
            log.error("답변 알림 발송 실패 : inquiryId={}", vo.getInquiryId(), e);
        }
    }

}