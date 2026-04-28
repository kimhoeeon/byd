package com.byd.service;

import com.byd.dto.CommentDTO;
import com.byd.mapper.LockerMapper;
import com.byd.vo.LockerVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LockerService {

    private final LockerMapper lockerMapper;

    // 목록 조회 (페이징 적용)
    public List<LockerVO> getPostList(String category, int page, int size) {
        LockerVO params = new LockerVO();
        params.setCategory(category);
        params.setPage(page);
        params.setSize(size); // 필요한 만큼 설정 (예: 메인화면은 5개)

        List<LockerVO> list = lockerMapper.selectPostList(params);

        // 시간 포맷팅
        for (LockerVO vo : list) {
            vo.setTimeAgo(formatTimeAgo(vo.getCreatedAt()));
        }
        return list;
    }

    // 게시글 작성
    @Transactional
    public Long writePost(LockerVO lockerVO) {
        lockerMapper.insertPost(lockerVO);
        return lockerVO.getPostId();
    }

    // 상세 조회 (조회수 증가 포함)
    @Transactional
    public LockerVO getPostDetail(Long postId) {
        lockerMapper.updateViewCount(postId);
        return lockerMapper.selectPostById(postId);
    }

    // [유틸] 시간 계산 (간단 구현)
    private String formatTimeAgo(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        Duration duration = Duration.between(dateTime, LocalDateTime.now());
        long seconds = duration.getSeconds();

        if (seconds < 60) return "방금 전";
        if (seconds < 3600) return (seconds / 60) + "분 전";
        if (seconds < 86400) return (seconds / 3600) + "시간 전";
        return (seconds / 86400) + "일 전";
    }

    public List<CommentDTO> getContentComments(Long contentId) {
        return lockerMapper.selectContentComments(contentId);
    }

    public void addContentComment(Long contentId, Long memberId, String content) {
        lockerMapper.insertContentComment(contentId, memberId, content);
    }

    public void deleteContentComment(Long commentId, Long memberId) {
        lockerMapper.deleteContentComment(commentId, memberId);
    }

    public String getUserReaction(Long contentId, Long memberId) {
        return lockerMapper.selectUserReaction(contentId, memberId);
    }

    @Transactional
    public void toggleReaction(Long contentId, Long memberId, String reqType) {
        String currType = lockerMapper.selectUserReaction(contentId, memberId);
        int likeInc = 0, sadInc = 0, angryInc = 0;

        if (currType == null) {
            // 새 반응
            lockerMapper.insertReaction(contentId, memberId, reqType);
            if ("LIKE".equals(reqType)) likeInc = 1;
            else if ("SAD".equals(reqType)) sadInc = 1;
            else if ("ANGRY".equals(reqType)) angryInc = 1;
        } else if (currType.equals(reqType)) {
            // 동일 반응 클릭 -> 취소
            lockerMapper.deleteReaction(contentId, memberId);
            if ("LIKE".equals(reqType)) likeInc = -1;
            else if ("SAD".equals(reqType)) sadInc = -1;
            else if ("ANGRY".equals(reqType)) angryInc = -1;
        } else {
            // 다른 반응으로 변경
            lockerMapper.updateReaction(contentId, memberId, reqType);
            if ("LIKE".equals(currType)) likeInc = -1;
            else if ("SAD".equals(currType)) sadInc = -1;
            else if ("ANGRY".equals(currType)) angryInc = -1;

            if ("LIKE".equals(reqType)) likeInc += 1;
            else if ("SAD".equals(reqType)) sadInc += 1;
            else if ("ANGRY".equals(reqType)) angryInc += 1;
        }
        lockerMapper.updateTeamContentReactionCount(contentId, likeInc, sadInc, angryInc);
    }

}