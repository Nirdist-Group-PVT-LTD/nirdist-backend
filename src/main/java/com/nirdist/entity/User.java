package com.nirdist.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "variant")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "v_id")
    private Integer vId;

    @Column(name = "v_name", nullable = false)
    private String vName;

    @Column(name = "v_username", nullable = false, unique = true)
    private String vUsername;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "v_birth")
    private String vBirth = "";

    @Column(name = "bio")
    private String bio = "";

    @Column(name = "profile_picture")
    private String profilePicture = "";

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Transient
    private Integer followerCount = 0;

    @Transient
    private Integer followingCount = 0;

    @Transient
    private Integer postCount = 0;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
