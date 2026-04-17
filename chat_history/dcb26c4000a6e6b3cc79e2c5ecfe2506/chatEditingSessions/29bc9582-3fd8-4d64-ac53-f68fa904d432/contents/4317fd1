package com.nirdist.controller;

import com.nirdist.entity.Post;
import com.nirdist.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/posts")
@CrossOrigin(origins = "*")
public class PostController {
    @Autowired
    private PostService postService;

    @PostMapping
    public ResponseEntity<Post> createPost(@RequestBody Post post) {
        Post createdPost = postService.createPost(post);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdPost);
    }

    @GetMapping("/{pId}")
    public ResponseEntity<Post> getPost(@PathVariable Integer pId) {
        Post post = postService.getPostById(pId);
        if (post != null) {
            return ResponseEntity.ok(post);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/user/{vId}")
    public ResponseEntity<List<Post>> getUserPosts(@PathVariable Integer vId) {
        List<Post> posts = postService.getPostsByUser(vId);
        return ResponseEntity.ok(posts);
    }

    @GetMapping("/feed")
    public ResponseEntity<Map<String, Object>> getFeed(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        Pageable pageable = PageRequest.of(page - 1, limit);
        Page<Post> posts = postService.getFeed(pageable);
        
        Map<String, Object> response = new HashMap<>();
        response.put("data", posts.getContent());
        response.put("page", page);
        response.put("limit", limit);
        response.put("total", posts.getTotalElements());
        
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{pId}")
    public ResponseEntity<Void> deletePost(@PathVariable Integer pId) {
        postService.deletePost(pId);
        return ResponseEntity.noContent().build();
    }
}
