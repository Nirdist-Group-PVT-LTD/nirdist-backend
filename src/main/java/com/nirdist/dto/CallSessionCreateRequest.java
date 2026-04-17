package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CallSessionCreateRequest {
    private Integer createdBy;
    private String roomId;
}
