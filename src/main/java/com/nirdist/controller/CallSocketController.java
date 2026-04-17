package com.nirdist.controller;

import com.nirdist.dto.CallSignalRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class CallSocketController {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/calls/{sessionId}/signal")
    public void signal(@DestinationVariable Integer sessionId, CallSignalRequest request) {
        messagingTemplate.convertAndSend("/topic/calls/" + sessionId, request);
    }
}
