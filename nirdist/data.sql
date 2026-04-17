-- ------------------------------------------------------------
-- 1. USERS (variant)
-- ------------------------------------------------------------
CREATE TABLE variant (
    v_id INT AUTO_INCREMENT PRIMARY KEY,
    v_name VARCHAR(100) NOT NULL,
    v_birth DATE,
    v_username VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Multi‑value contacts (allow multiple per user)
CREATE TABLE variant_username (
    vu_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    used_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

CREATE TABLE variant_email (
    ve_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

CREATE TABLE variant_number (
    vn_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    type ENUM('mobile', 'home', 'work') DEFAULT 'mobile',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

-- Follow system (social requirement)
CREATE TABLE follows (
    follow_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    follow_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_follow (follower_id, followee_id)
);

-- ------------------------------------------------------------
-- 2. SOUND & ARTIST (music/sound features)
-- ------------------------------------------------------------
CREATE TABLE sound_artist (
    s_a_id INT AUTO_INCREMENT PRIMARY KEY,
    s_a_name VARCHAR(100) NOT NULL,
    s_a_date DATE
);

CREATE TABLE sound (
    s_id INT AUTO_INCREMENT PRIMARY KEY,
    lyrics TEXT,                          -- .lrc or plain text
    s_link VARCHAR(500) NOT NULL,
    s_a_id INT,                           -- artist FK
    s_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (s_a_id) REFERENCES sound_artist(s_a_id) ON DELETE SET NULL
);

-- User‑produced sounds (original audio)
CREATE TABLE sound_produce (
    sp_id INT AUTO_INCREMENT PRIMARY KEY,
    sp_name VARCHAR(100) NOT NULL,
    sp_discription TEXT NOT NULL,
    sp_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    v_id INT NOT NULL,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 3. POSTS (core content)
-- ------------------------------------------------------------
CREATE TABLE post (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    post_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statuse BOOLEAN DEFAULT TRUE,          -- published/hidden
    reach INT DEFAULT 0,
    a_id VARCHAR(50),                      -- algorithm ID (optional)
    discription TEXT NOT NULL,
    s_id INT NULL,                         -- optional attached sound
    p_update TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (s_id) REFERENCES sound(s_id) ON DELETE SET NULL,
    INDEX idx_post_time (post_time),
    INDEX idx_v_id (v_id)
);

-- Post media (multiple images/videos per post)
CREATE TABLE post_media (
    p_m_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    p_m_link VARCHAR(500) NOT NULL,
    p_m_upload_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    p_m_display BOOLEAN DEFAULT TRUE,      -- currently in use
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    INDEX idx_p_id (p_id)
);

-- Reactions on posts (like, love, etc.)
CREATE TABLE post_reaction (
    pr_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    v_id INT NOT NULL,
    pr_type ENUM('like', 'love', 'haha', 'wow', 'sad', 'angry') NOT NULL,
    pr_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_post_reaction (p_id, v_id),
    INDEX idx_pr_type (pr_type)
);

-- Comments on posts
CREATE TABLE post_comment (
    post_comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    v_id INT NOT NULL,
    post_comment_text TEXT NOT NULL,
    post_comment_media VARCHAR(500),       -- optional image/video in comment
    parent_comment_id INT NULL,            -- for nested replies
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES post_comment(post_comment_id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id)
);

-- Reactions on comments
CREATE TABLE post_comment_reaction (
    pcr_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL,
    v_id INT NOT NULL,
    reaction_type ENUM('like', 'love', 'haha', 'wow', 'sad', 'angry') NOT NULL,
    reaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comment_id) REFERENCES post_comment(post_comment_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_comment_reaction (comment_id, v_id)
);

-- Shares
CREATE TABLE post_share (
    p_s_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    v_id INT NOT NULL,
    p_s_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    p_s_to INT NULL,                       -- NULL = public, else user ID (variant)
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (p_s_to) REFERENCES variant(v_id) ON DELETE SET NULL,
    INDEX idx_share_time (p_s_time)
);

-- Saves (bookmarks)
CREATE TABLE post_save (
    p_sa_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    v_id INT NOT NULL,
    p_sa_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    p_sa_type ENUM('bookmark', 'watch_later') DEFAULT 'bookmark',
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_save (p_id, v_id)
);

-- ------------------------------------------------------------
-- 4. STORIES (ephemeral content)
-- ------------------------------------------------------------
CREATE TABLE story (
    s_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    s_link VARCHAR(500) NOT NULL,          -- media URL
    s_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP GENERATED ALWAYS AS (s_time + INTERVAL 24 HOUR) STORED,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    INDEX idx_expires (expires_at)
);

-- Story reactions (with type)
CREATE TABLE story_reaction (
    sr_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    s_id INT NOT NULL,
    sr_type ENUM('like', 'love', 'haha', 'wow', 'sad') NOT NULL,
    sr_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (s_id) REFERENCES story(s_id) ON DELETE CASCADE,
    UNIQUE KEY unique_story_reaction (v_id, s_id)
);

-- ------------------------------------------------------------
-- 5. NOTES (user short notes / status)
-- ------------------------------------------------------------
CREATE TABLE notes (
    po_id INT AUTO_INCREMENT PRIMARY KEY,   -- matches original 'po_id'
    v_id INT NOT NULL,
    note_content TEXT NOT NULL,
    note_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visibility ENUM('public', 'friends', 'only_me') DEFAULT 'public',
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    INDEX idx_note_time (note_time)
);

-- Reactions on notes
CREATE TABLE notes_reaction (
    nr_id INT AUTO_INCREMENT PRIMARY KEY,
    note_id INT NOT NULL,
    v_id INT NOT NULL,
    reaction_type ENUM('like', 'love', 'haha', 'wow', 'sad') NOT NULL,
    reaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(po_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_note_reaction (note_id, v_id)
);