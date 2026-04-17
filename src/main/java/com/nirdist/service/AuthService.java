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

@Service
public class AuthService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public AuthResponse register(RegisterRequest request) {
        // Validate required fields
        if (request.getEmail() == null || request.getEmail().isEmpty()) {
            return new AuthResponse(null, null, "Email is required");
        }
        if (request.getPassword() == null || request.getPassword().isEmpty()) {
            return new AuthResponse(null, null, "Password is required");
        }
        
        // Generate username if not provided
        String username = request.getVUsername();
        if (username == null || username.isEmpty()) {
            username = request.getEmail().split("@")[0]; // Use email prefix as username
        }
        
        // Generate name if not provided
        String name = request.getVName();
        if (name == null || name.isEmpty()) {
            name = username; // Use username as name
        }

        // Check if user already exists
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            return new AuthResponse(null, null, "Email already registered");
        }

        if (userRepository.findByVUsername(username).isPresent()) {
            return new AuthResponse(null, null, "Username already taken");
        }

        // Create new user
        User user = new User();
        user.setVName(name);
        user.setVUsername(username);
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setBio(request.getBio() != null ? request.getBio() : "");
        user.setProfilePicture(request.getProfilePicture());

        User savedUser = userRepository.save(user);
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

        return new AuthResponse(token, userDTO, "Registration successful");
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
