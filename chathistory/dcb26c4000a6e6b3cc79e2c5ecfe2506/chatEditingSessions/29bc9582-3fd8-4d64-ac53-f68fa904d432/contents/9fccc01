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
        // Check if user already exists
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            return new AuthResponse(null, null, "Email already registered");
        }

        if (userRepository.findByVUsername(request.getVUsername()).isPresent()) {
            return new AuthResponse(null, null, "Username already taken");
        }

        // Create new user
        User user = new User();
        user.setVName(request.getVName());
        user.setVUsername(request.getVUsername());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setBio(request.getBio());
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
        User user = userRepository.findByEmail(request.getEmail())
                .orElse(null);

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
