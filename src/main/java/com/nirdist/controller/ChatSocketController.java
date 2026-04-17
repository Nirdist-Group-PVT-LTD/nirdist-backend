package com.nirdist.controller;

import com.nirdist.dto.ChatMessageRequest;
import com.nirdist.dto.ChatMessageResponse;
import com.nirdist.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class ChatSocketController {
    @Autowired
    private ChatService chatService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/rooms/{roomId}/send")
    public void sendMessage(@DestinationVariable Integer roomId, ChatMessageRequest request) {
        ChatMessageResponse response = chatService.createMessage(roomId, request);
        messagingTemplate.convertAndSend("/topic/rooms/" + roomId, response);
    }
}
