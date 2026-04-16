package com.nirdist.service;

import com.nirdist.entity.Comment;
import com.nirdist.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CommentService {
    @Autowired
    private CommentRepository commentRepository;

    public Comment createComment(Comment comment) {
        return commentRepository.save(comment);
    }

    public Comment getCommentById(Integer cId) {
        Optional<Comment> comment = commentRepository.findByCId(cId);
        return comment.orElse(null);
    }

    public List<Comment> getCommentsByPost(Integer pId) {
        return commentRepository.findByPId(pId);
    }

    public void deleteComment(Integer cId) {
        commentRepository.deleteById(cId);
    }
}
