package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatRoomCreateRequest {
    private String name;
    private Boolean isGroup;
    private Integer createdBy;
    private List<Integer> participantIds;
}
