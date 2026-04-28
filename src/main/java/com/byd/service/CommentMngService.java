package com.byd.service;

import com.byd.dto.CommentDTO;
import com.byd.mapper.CommentMngMapper;
import com.byd.vo.Criteria;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentMngService {

    private final CommentMngMapper commentMngMapper;

    public List<CommentDTO> getCommentList(Criteria cri) {
        return commentMngMapper.selectCommentList(cri);
    }

    public int getTotal(Criteria cri) {
        return commentMngMapper.getTotalCount(cri);
    }

    @Transactional
    public void deleteComment(Long commentId) {
        commentMngMapper.deleteComment(commentId);
    }
}