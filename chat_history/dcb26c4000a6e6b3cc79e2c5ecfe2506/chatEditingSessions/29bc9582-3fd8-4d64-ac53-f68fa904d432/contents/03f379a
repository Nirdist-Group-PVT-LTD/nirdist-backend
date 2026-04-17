-- Nirdist Database Initialization Script

-- Create database
CREATE DATABASE IF NOT EXISTS nirdist CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nirdist;

-- Drop existing tables (if any)
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS story;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS variant;

-- Users/Variant table
CREATE TABLE variant (
    v_id INT PRIMARY KEY AUTO_INCREMENT,
    v_name VARCHAR(255) NOT NULL,
    v_username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    v_birth DATE,
    bio TEXT,
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Posts table
CREATE TABLE post (
    p_id INT PRIMARY KEY AUTO_INCREMENT,
    v_id INT NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    discription LONGTEXT,
    post_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reach INT DEFAULT 0,
    media JSON,
    sound JSON,
    statuse BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    INDEX idx_post_v_id (v_id),
    INDEX idx_post_time (post_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Stories table
CREATE TABLE story (
    s_id INT PRIMARY KEY AUTO_INCREMENT,
    v_id INT NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    media VARCHAR(255),
    caption LONGTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    reach INT DEFAULT 0,
    statuse BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    INDEX idx_story_v_id (v_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Comments table
CREATE TABLE comment (
    c_id INT PRIMARY KEY AUTO_INCREMENT,
    p_id INT NOT NULL,
    v_id INT NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    content LONGTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statuse BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    INDEX idx_comment_p_id (p_id),
    INDEX idx_comment_v_id (v_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert test user
INSERT INTO variant (v_name, v_username, email, password, bio, profile_picture)
VALUES ('Test User', 'testuser', 'test@example.com', '$2a$10$slYQmyNdGzin7olVN3p5Be7DlH.PKZbv5H8KnzzVgXXbVxzy990qm', 'Welcome to Nirdist', '');

-- Insert test posts
INSERT INTO post (v_id, v_name, v_username, discription, media, sound, statuse)
VALUES 
(1, 'Test User', 'testuser', 'Check out this amazing post! 🎉', '[]', NULL, TRUE),
(1, 'Test User', 'testuser', 'Feeling great today! 😊', '[]', NULL, TRUE);

-- Insert test stories
INSERT INTO story (v_id, v_name, v_username, media, caption, expires_at, statuse)
VALUES 
(1, 'Test User', 'testuser', 'story1.jpg', 'My First Story', DATE_ADD(NOW(), INTERVAL 24 HOUR), TRUE);

-- Database privileges (optional for docker)
-- GRANT ALL PRIVILEGES ON nirdist.* TO 'nirdist_user'@'%' IDENTIFIED BY 'nirdist_password';
-- FLUSH PRIVILEGES;
