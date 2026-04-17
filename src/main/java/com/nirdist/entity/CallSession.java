package com.nirdist.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "call_session")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CallSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "session_id")
    private Integer sessionId;

    @Column(name = "room_id", nullable = false, unique = true)
    private String roomId;

    @Column(name = "created_by", nullable = false)
    private Integer createdBy;

    @Column(name = "status", nullable = false)
    private String status = "ACTIVE";

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "ended_at")
    private LocalDateTime endedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (status == null || status.isBlank()) {
            status = "ACTIVE";
        }
    }
}
