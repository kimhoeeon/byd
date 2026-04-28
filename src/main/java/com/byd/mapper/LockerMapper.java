package com.byd.mapper;

import com.byd.dto.CommentDTO;
import com.byd.vo.LockerVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LockerMapper {
    List<LockerVO> selectPostList(LockerVO params);

    LockerVO selectPostById(Long postId);

    int insertPost(LockerVO lockerVO);

    int updateViewCount(Long postId);

    // 팀 콘텐츠 공감/댓글 관련
    List<CommentDTO> selectContentComments(Long contentId);
    void insertContentComment(@Param("contentId") Long contentId, @Param("memberId") Long memberId, @Param("content") String content);
    void deleteContentComment(@Param("commentId") Long commentId, @Param("memberId") Long memberId);
    String selectUserReaction(@Param("contentId") Long contentId, @Param("memberId") Long memberId);
    void insertReaction(@Param("contentId") Long contentId, @Param("memberId") Long memberId, @Param("reactionType") String reactionType);
    void updateReaction(@Param("contentId") Long contentId, @Param("memberId") Long memberId, @Param("reactionType") String reactionType);
    void deleteReaction(@Param("contentId") Long contentId, @Param("memberId") Long memberId);
    void updateTeamContentReactionCount(@Param("contentId") Long contentId, @Param("likeInc") int likeInc, @Param("sadInc") int sadInc, @Param("angryInc") int angryInc);
}