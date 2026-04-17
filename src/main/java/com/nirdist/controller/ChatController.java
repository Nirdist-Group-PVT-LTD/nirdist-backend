package com.nirdist.controller;

import com.nirdist.dto.ChatMessageRequest;
import com.nirdist.dto.ChatMessageResponse;
import com.nirdist.dto.ChatRoomCreateRequest;
import com.nirdist.dto.ChatRoomResponse;
import com.nirdist.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*")
public class ChatController {
    @Autowired
    private ChatService chatService;

    @PostMapping("/rooms")
    public ResponseEntity<ChatRoomResponse> createRoom(@RequestBody ChatRoomCreateRequest request) {
        try {
            ChatRoomResponse response = chatService.createRoom(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @GetMapping("/rooms")
    public ResponseEntity<Map<String, Object>> listRooms(@RequestParam Integer userId) {
        List<ChatRoomResponse> rooms = chatService.listRoomsForUser(userId);
        Map<String, Object> response = new HashMap<>();
        response.put("data", rooms);
        response.put("count", rooms.size());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/rooms/{roomId}/messages")
    public ResponseEntity<Map<String, Object>> listMessages(@PathVariable Integer roomId) {
        List<ChatMessageResponse> messages = chatService.listMessages(roomId);
        Map<String, Object> response = new HashMap<>();
        response.put("data", messages);
        response.put("count", messages.size());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/rooms/{roomId}/messages")
    public ResponseEntity<ChatMessageResponse> createMessage(
            @PathVariable Integer roomId,
            @RequestBody ChatMessageRequest request) {
        try {
            ChatMessageResponse response = chatService.createMessage(roomId, request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}
