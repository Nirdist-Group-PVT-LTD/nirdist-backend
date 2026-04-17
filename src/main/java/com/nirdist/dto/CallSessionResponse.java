package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CallSessionResponse {
    private Integer sessionId;
    private String roomId;
    private Integer createdBy;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime endedAt;
    private List<Integer> participantIds;
}
