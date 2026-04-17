package com.nirdist.repository;

import com.nirdist.entity.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PostRepository extends JpaRepository<Post, Integer> {
    @Query("SELECT p FROM Post p WHERE p.pId = :pId")
    Optional<Post> findByPId(@Param("pId") Integer pId);
    
    @Query("SELECT p FROM Post p WHERE p.vId = :vId")
    List<Post> findByVId(@Param("vId") Integer vId);
    
    Page<Post> findAll(Pageable pageable);
    
    @Query("SELECT p FROM Post p WHERE p.vId = :vId ORDER BY p.postTime DESC")
    Page<Post> findByVIdOrderByPostTimeDesc(@Param("vId") Integer vId, Pageable pageable);
}
