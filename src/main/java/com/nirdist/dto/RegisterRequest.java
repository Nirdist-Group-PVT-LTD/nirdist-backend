package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    private String vName;
    private String vUsername;
    private String email;
    private String password;
    private String bio;
    private String profilePicture;
}
