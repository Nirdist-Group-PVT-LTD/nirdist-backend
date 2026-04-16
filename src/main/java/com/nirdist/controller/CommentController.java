package com.nirdist.controller;

import com.nirdist.entity.Comment;
import com.nirdist.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/comments")
@CrossOrigin(origins = "*")
public class CommentController {
    @Autowired
    private CommentService commentService;

    @PostMapping
    public ResponseEntity<Comment> createComment(@RequestBody Comment comment) {
        Comment createdComment = commentService.createComment(comment);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdComment);
    }

    @GetMapping("/{cId}")
    public ResponseEntity<Comment> getComment(@PathVariable Integer cId) {
        Comment comment = commentService.getCommentById(cId);
        if (comment != null) {
            return ResponseEntity.ok(comment);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/post/{pId}")
    public ResponseEntity<List<Comment>> getPostComments(@PathVariable Integer pId) {
        List<Comment> comments = commentService.getCommentsByPost(pId);
        return ResponseEntity.ok(comments);
    }

    @DeleteMapping("/{cId}")
    public ResponseEntity<Void> deleteComment(@PathVariable Integer cId) {
        commentService.deleteComment(cId);
        return ResponseEntity.noContent().build();
    }
}
