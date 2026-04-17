package com.nirdist.repository;

import com.nirdist.entity.ChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoom, Integer> {
    @Query("SELECT r FROM ChatRoom r WHERE r.roomId IN (SELECT m.roomId FROM ChatMember m WHERE m.userId = :userId)")
    List<ChatRoom> findRoomsByUserId(@Param("userId") Integer userId);
}
