package com.nirdist.repository;

import com.nirdist.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Integer> {
    @Query("SELECT c FROM Comment c WHERE c.cId = :cId")
    Optional<Comment> findByCId(@Param("cId") Integer cId);
    
    @Query("SELECT c FROM Comment c WHERE c.pId = :pId")
    List<Comment> findByPId(@Param("pId") Integer pId);
    
    @Query("SELECT c FROM Comment c WHERE c.vId = :vId")
    List<Comment> findByVId(@Param("vId") Integer vId);
}
