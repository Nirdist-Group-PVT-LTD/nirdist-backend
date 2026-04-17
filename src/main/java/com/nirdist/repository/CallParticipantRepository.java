package com.nirdist.repository;

import com.nirdist.entity.CallParticipant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CallParticipantRepository extends JpaRepository<CallParticipant, Integer> {
    List<CallParticipant> findBySessionId(Integer sessionId);
    boolean existsBySessionIdAndUserId(Integer sessionId, Integer userId);
}
