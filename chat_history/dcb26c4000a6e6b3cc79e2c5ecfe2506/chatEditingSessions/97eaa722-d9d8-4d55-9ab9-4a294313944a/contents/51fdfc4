package com.nirdist.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "post")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "p_id")
    private Integer pId;

    @Column(name = "v_id", nullable = false)
    private Integer vId;

    @Column(name = "v_name")
    private String vName;

    @Column(name = "v_username")
    private String vUsername;

    @Column(name = "discription", columnDefinition = "TEXT")
    private String discription;

    @Column(name = "post_time", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime postTime;

    @Column(name = "reach")
    private Integer reach = 0;

    @Column(name = "media", columnDefinition = "JSON")
    private String media; // JSON array

    @Column(name = "sound", columnDefinition = "JSON")
    private String sound; // JSON object

    @Column(name = "statuse")
    private Boolean statuse = true;

    @PrePersist
    protected void onCreate() {
        postTime = LocalDateTime.now();
    }
}
