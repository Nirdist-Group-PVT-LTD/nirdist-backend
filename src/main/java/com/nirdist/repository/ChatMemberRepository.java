package com.nirdist.repository;

import com.nirdist.entity.ChatMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMemberRepository extends JpaRepository<ChatMember, Integer> {
    List<ChatMember> findByRoomId(Integer roomId);
    boolean existsByRoomIdAndUserId(Integer roomId, Integer userId);
}
