package com.nirdist.repository;

import com.nirdist.entity.Story;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface StoryRepository extends JpaRepository<Story, Integer> {
    @Query("SELECT s FROM Story s WHERE s.sId = :sId")
    Optional<Story> findBySId(@Param("sId") Integer sId);
    
    @Query("SELECT s FROM Story s WHERE s.vId = :vId")
    List<Story> findByVId(@Param("vId") Integer vId);
    
    @Query("SELECT s FROM Story s WHERE s.statuse = true AND s.expiresAt > :now ORDER BY s.createdAt DESC")
    List<Story> findActiveStories(@Param("now") LocalDateTime now);
}
