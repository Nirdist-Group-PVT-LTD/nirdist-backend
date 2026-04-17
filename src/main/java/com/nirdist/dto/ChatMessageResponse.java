package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageResponse {
    private Integer messageId;
    private Integer roomId;
    private Integer senderId;
    private String content;
    private String messageType;
    private LocalDateTime createdAt;
}
