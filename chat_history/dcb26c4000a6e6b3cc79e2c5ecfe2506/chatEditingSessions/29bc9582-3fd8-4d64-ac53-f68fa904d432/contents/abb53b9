package com.nirdist.controller;

import com.nirdist.dto.UserDTO;
import com.nirdist.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/{vId}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Integer vId) {
        UserDTO user = userService.getUserById(vId);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/username/{vUsername}")
    public ResponseEntity<UserDTO> getUserByUsername(@PathVariable String vUsername) {
        UserDTO user = userService.getUserByUsername(vUsername);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/search")
    public ResponseEntity<List<UserDTO>> searchUsers(@RequestParam String q) {
        List<UserDTO> users = userService.searchUsers(q);
        return ResponseEntity.ok(users);
    }
}
