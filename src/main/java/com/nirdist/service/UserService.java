package com.nirdist.service;

import com.nirdist.dto.UserDTO;
import com.nirdist.entity.User;
import com.nirdist.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public UserDTO getUserById(Integer vId) {
        Optional<User> user = userRepository.findByVId(vId);
        return user.map(this::convertToDTO).orElse(null);
    }

    public UserDTO getUserByUsername(String vUsername) {
        Optional<User> user = userRepository.findByVUsername(vUsername);
        return user.map(this::convertToDTO).orElse(null);
    }

    public List<UserDTO> searchUsers(String query) {
        return userRepository.searchUsers(query)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private UserDTO convertToDTO(User user) {
        return new UserDTO(
                user.getVId(),
                user.getVName(),
                user.getVUsername(),
                user.getEmail(),
                user.getBio(),
                user.getProfilePicture(),
                0, 0, 0
        );
    }
}
