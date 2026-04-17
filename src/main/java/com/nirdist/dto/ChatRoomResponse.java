package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatRoomResponse {
    private Integer roomId;
    private String name;
    private Boolean isGroup;
    private Integer createdBy;
    private LocalDateTime createdAt;
    private List<Integer> participantIds;
}
