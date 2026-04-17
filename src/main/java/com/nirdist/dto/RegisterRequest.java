package com.nirdist.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class RegisterRequest {
    @JsonProperty(value = "vName", required = false)
    private String vName;
    
    @JsonProperty(value = "vUsername", required = false)
    private String vUsername;
    
    @JsonProperty(value = "email", required = false)
    private String email;
    
    @JsonProperty(value = "password", required = false)
    private String password;
    
    @JsonProperty(value = "bio", required = false)
    private String bio;
    
    @JsonProperty(value = "profilePicture", required = false)
    private String profilePicture;
}
