package com.nirdist.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "story")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Story {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "s_id")
    private Integer sId;

    @Column(name = "v_id", nullable = false)
    private Integer vId;

    @Column(name = "v_name")
    private String vName;

    @Column(name = "v_username")
    private String vUsername;

    @Column(name = "media")
    private String media;

    @Column(name = "caption", columnDefinition = "LONGTEXT")
    private String caption;

    @Column(name = "created_at", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime createdAt;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "reach")
    private Integer reach = 0;

    @Column(name = "statuse")
    private Boolean statuse = true;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (expiresAt == null) {
            expiresAt = LocalDateTime.now().plusHours(24);
        }
    }
}
