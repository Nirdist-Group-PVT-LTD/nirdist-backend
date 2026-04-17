package com.nirdist.controller;

import com.nirdist.dto.AuthResponse;
import com.nirdist.dto.LoginRequest;
import com.nirdist.dto.RegisterRequest;
import com.nirdist.service.AuthService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);
    
    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        logger.info("POST /api/auth/register - Request received");
        AuthResponse response = authService.register(request);
        if (response.getToken() != null) {
            logger.info("Registration successful");
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } else {
            logger.warn("Registration failed: {}", response.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        logger.info("POST /api/auth/login - Request received");
        AuthResponse response = authService.login(request);
        if (response.getToken() != null) {
            logger.info("Login successful");
            return ResponseEntity.ok(response);
        } else {
            logger.warn("Login failed: {}", response.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }
}
