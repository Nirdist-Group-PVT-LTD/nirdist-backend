package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    private Integer vId;
    private String vName;
    private String vUsername;
    private String email;
    private String bio;
    private String profilePicture;
    private Integer followerCount;
    private Integer followingCount;
    private Integer postCount;
}
