package com.nirdist.repository;

import com.nirdist.entity.CallSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CallSessionRepository extends JpaRepository<CallSession, Integer> {
    Optional<CallSession> findByRoomId(String roomId);

    @Query("SELECT s FROM CallSession s WHERE s.sessionId IN (SELECT p.sessionId FROM CallParticipant p WHERE p.userId = :userId)")
    List<CallSession> findSessionsByUserId(@Param("userId") Integer userId);
}
