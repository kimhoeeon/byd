package com.byd.mapper;

import com.byd.dto.CommentDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CommentMapper {

    List<CommentDTO> selectMyCommentList(Long memberId);

    // 삭제 요청자 ID(requestMemberId)를 넘겨서 권한 체크
    int deleteComment(@Param("commentId") Long commentId, @Param("requestMemberId") Long requestMemberId);

    List<CommentDTO> selectCommentListByDiaryId(Long diaryId);

    int insertComment(CommentDTO comment);

}