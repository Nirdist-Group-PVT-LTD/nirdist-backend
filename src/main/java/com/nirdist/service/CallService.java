package com.nirdist.service;

import com.nirdist.dto.CallJoinRequest;
import com.nirdist.dto.CallSessionCreateRequest;
import com.nirdist.dto.CallSessionResponse;
import com.nirdist.entity.CallParticipant;
import com.nirdist.entity.CallSession;
import com.nirdist.repository.CallParticipantRepository;
import com.nirdist.repository.CallSessionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class CallService {
    @Autowired
    private CallSessionRepository callSessionRepository;

    @Autowired
    private CallParticipantRepository callParticipantRepository;

    public CallSessionResponse createSession(CallSessionCreateRequest request) {
        if (request.getCreatedBy() == null) {
            throw new IllegalArgumentException("createdBy is required");
        }

        String roomId = request.getRoomId();
        if (roomId == null || roomId.isBlank()) {
            roomId = "call_" + System.currentTimeMillis() + "_" + UUID.randomUUID();
        }

        CallSession session = new CallSession();
        session.setRoomId(roomId);
        session.setCreatedBy(request.getCreatedBy());
        session.setStatus("ACTIVE");

        CallSession savedSession = callSessionRepository.save(session);

        CallParticipant creator = new CallParticipant();
        creator.setSessionId(savedSession.getSessionId());
        creator.setUserId(request.getCreatedBy());
        callParticipantRepository.save(creator);

        return buildSessionResponse(savedSession, getActiveParticipantIds(savedSession.getSessionId()));
    }

    public List<CallSessionResponse> listSessionsForUser(Integer userId) {
        return callSessionRepository.findSessionsByUserId(userId)
                .stream()
                .map(session -> buildSessionResponse(session, getActiveParticipantIds(session.getSessionId())))
                .collect(Collectors.toList());
    }

    public CallSessionResponse joinSession(Integer sessionId, CallJoinRequest request) {
        if (request.getUserId() == null) {
            throw new IllegalArgumentException("userId is required");
        }

        CallSession session = callSessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("session not found"));

        if (!callParticipantRepository.existsBySessionIdAndUserId(sessionId, request.getUserId())) {
            CallParticipant participant = new CallParticipant();
            participant.setSessionId(sessionId);
            participant.setUserId(request.getUserId());
            callParticipantRepository.save(participant);
        }

        return buildSessionResponse(session, getActiveParticipantIds(sessionId));
    }

    public CallSessionResponse leaveSession(Integer sessionId, CallJoinRequest request) {
        if (request.getUserId() == null) {
            throw new IllegalArgumentException("userId is required");
        }

        CallSession session = callSessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("session not found"));

        List<CallParticipant> participants = callParticipantRepository.findBySessionId(sessionId);
        for (CallParticipant participant : participants) {
            if (participant.getUserId().equals(request.getUserId()) && participant.getLeftAt() == null) {
                participant.setLeftAt(LocalDateTime.now());
                callParticipantRepository.save(participant);
            }
        }

        if (getActiveParticipantIds(sessionId).isEmpty()) {
            session.setStatus("ENDED");
            session.setEndedAt(LocalDateTime.now());
            callSessionRepository.save(session);
        }

        return buildSessionResponse(session, getActiveParticipantIds(sessionId));
    }

    public CallSessionResponse endSession(Integer sessionId) {
        CallSession session = callSessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("session not found"));

        session.setStatus("ENDED");
        session.setEndedAt(LocalDateTime.now());
        CallSession savedSession = callSessionRepository.save(session);

        return buildSessionResponse(savedSession, getActiveParticipantIds(sessionId));
    }

    private List<Integer> getActiveParticipantIds(Integer sessionId) {
        return callParticipantRepository.findBySessionId(sessionId)
                .stream()
                .filter(participant -> participant.getLeftAt() == null)
                .map(CallParticipant::getUserId)
                .collect(Collectors.toList());
    }

    private CallSessionResponse buildSessionResponse(CallSession session, List<Integer> participantIds) {
        return new CallSessionResponse(
                session.getSessionId(),
                session.getRoomId(),
                session.getCreatedBy(),
                session.getStatus(),
                session.getCreatedAt(),
                session.getEndedAt(),
                participantIds
        );
    }
}
