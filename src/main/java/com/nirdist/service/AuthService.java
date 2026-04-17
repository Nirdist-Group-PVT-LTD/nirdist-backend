package com.nirdist.service;

import com.nirdist.dto.AuthResponse;
import com.nirdist.dto.LoginRequest;
import com.nirdist.dto.RegisterRequest;
import com.nirdist.dto.UserDTO;
import com.nirdist.entity.User;
import com.nirdist.repository.UserRepository;
import com.nirdist.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class AuthService {
    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public AuthResponse register(RegisterRequest request) {
        logger.info("=== REGISTRATION REQUEST ===");
        logger.info("Email: {}", request.getEmail());
        logger.info("Password: {}", request.getPassword() != null ? "***" : "null");
        logger.info("VUsername: {}", request.getVUsername());
        logger.info("VName: {}", request.getVName());
        logger.info("Bio: {}", request.getBio());
        logger.info("ProfilePicture: {}", request.getProfilePicture());
        
        // Validate required fields
        if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
            logger.error("Email validation failed - null or empty");
            return new AuthResponse(null, null, "Email is required");
        }
        if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
            logger.error("Password validation failed - null or empty");
            return new AuthResponse(null, null, "Password is required");
        }
        
        // Generate username if not provided
        String username = request.getVUsername();
        if (username == null || username.trim().isEmpty()) {
            try {
                username = request.getEmail().split("@")[0]; // Use email prefix as username
                logger.info("Generated username from email: {}", username);
            } catch (Exception e) {
                logger.error("Failed to generate username from email", e);
                username = "user_" + System.currentTimeMillis();
            }
        }
        
        // Generate name if not provided
        String name = request.getVName();
        if (name == null || name.trim().isEmpty()) {
            name = username; // Use username as name
            logger.info("Generated name from username: {}", name);
        }

        // Check if user already exists
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            logger.warn("Email already registered: {}", request.getEmail());
            return new AuthResponse(null, null, "Email already registered");
        }

        if (userRepository.findByVUsername(username).isPresent()) {
            logger.warn("Username already taken: {}", username);
            return new AuthResponse(null, null, "Username already taken");
        }

        // Create new user
        User user = new User();
        user.setVName(name);
        user.setVUsername(username);
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setBio(request.getBio() != null ? request.getBio().trim() : "");
        user.setProfilePicture(request.getProfilePicture() != null ? request.getProfilePicture().trim() : "");

        try {
            User savedUser = userRepository.save(user);
            logger.info("User saved successfully with ID: {}", savedUser.getVId());
            
            String token = jwtTokenProvider.generateToken(savedUser.getEmail());

            UserDTO userDTO = new UserDTO(
                    savedUser.getVId(),
                    savedUser.getVName(),
                    savedUser.getVUsername(),
                    savedUser.getEmail(),
                    savedUser.getBio(),
                    savedUser.getProfilePicture(),
                    0, 0, 0
            );

            logger.info("Registration successful for user: {}", savedUser.getEmail());
            return new AuthResponse(token, userDTO, "Registration successful");
        } catch (Exception e) {
            logger.error("Error during user registration", e);
            return new AuthResponse(null, null, "Registration failed: " + e.getMessage());
        }
    }

    public AuthResponse login(LoginRequest request) {
        User user = null;
        
        // Try login by email first, then by username
        if (request.getEmail() != null && !request.getEmail().isEmpty()) {
            user = userRepository.findByEmail(request.getEmail()).orElse(null);
        } else if (request.getVUsername() != null && !request.getVUsername().isEmpty()) {
            user = userRepository.findByVUsername(request.getVUsername()).orElse(null);
        }

        if (user == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return new AuthResponse(null, null, "Invalid email or password");
        }

        String token = jwtTokenProvider.generateToken(user.getEmail());

        UserDTO userDTO = new UserDTO(
                user.getVId(),
                user.getVName(),
                user.getVUsername(),
                user.getEmail(),
                user.getBio(),
                user.getProfilePicture(),
                0, 0, 0
        );

        return new AuthResponse(token, userDTO, "Login successful");
    }
}
