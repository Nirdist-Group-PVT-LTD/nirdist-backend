package com.nirdist.service;

import com.nirdist.entity.Post;
import com.nirdist.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PostService {
    @Autowired
    private PostRepository postRepository;

    public Post createPost(Post post) {
        return postRepository.save(post);
    }

    public Post getPostById(Integer pId) {
        Optional<Post> post = postRepository.findByPId(pId);
        return post.orElse(null);
    }

    public List<Post> getPostsByUser(Integer vId) {
        return postRepository.findByVId(vId);
    }

    public Page<Post> getFeed(Pageable pageable) {
        return postRepository.findAll(pageable);
    }

    public void deletePost(Integer pId) {
        postRepository.deleteById(pId);
    }
}
