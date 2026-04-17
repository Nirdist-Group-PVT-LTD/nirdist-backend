package com.nirdist.controller;

import com.nirdist.dto.CallJoinRequest;
import com.nirdist.dto.CallSessionCreateRequest;
import com.nirdist.dto.CallSessionResponse;
import com.nirdist.service.CallService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/calls")
@CrossOrigin(origins = "*")
public class CallController {
    @Autowired
    private CallService callService;

    @PostMapping("/sessions")
    public ResponseEntity<CallSessionResponse> createSession(@RequestBody CallSessionCreateRequest request) {
        try {
            CallSessionResponse response = callService.createSession(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @GetMapping("/sessions")
    public ResponseEntity<Map<String, Object>> listSessions(@RequestParam Integer userId) {
        List<CallSessionResponse> sessions = callService.listSessionsForUser(userId);
        Map<String, Object> response = new HashMap<>();
        response.put("data", sessions);
        response.put("count", sessions.size());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/sessions/{sessionId}/join")
    public ResponseEntity<CallSessionResponse> joinSession(
            @PathVariable Integer sessionId,
            @RequestBody CallJoinRequest request) {
        try {
            return ResponseEntity.ok(callService.joinSession(sessionId, request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PostMapping("/sessions/{sessionId}/leave")
    public ResponseEntity<CallSessionResponse> leaveSession(
            @PathVariable Integer sessionId,
            @RequestBody CallJoinRequest request) {
        try {
            return ResponseEntity.ok(callService.leaveSession(sessionId, request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PostMapping("/sessions/{sessionId}/end")
    public ResponseEntity<CallSessionResponse> endSession(@PathVariable Integer sessionId) {
        try {
            return ResponseEntity.ok(callService.endSession(sessionId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
}
