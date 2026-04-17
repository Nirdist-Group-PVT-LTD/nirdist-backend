const { pool } = require('../config/database');

const createTablesSQL = `
-- Users (variant)
CREATE TABLE IF NOT EXISTS variant (
    v_id INT AUTO_INCREMENT PRIMARY KEY,
    v_name VARCHAR(100) NOT NULL,
    v_birth DATE,
    v_username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Multi‑value contacts
CREATE TABLE IF NOT EXISTS variant_username (
    vu_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    used_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS variant_email (
    ve_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS variant_number (
    vn_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    type ENUM('mobile', 'home', 'work') DEFAULT 'mobile',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

-- Follow system
CREATE TABLE IF NOT EXISTS follows (
    follow_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    follow_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_follow (follower_id, followee_id)
);

-- Sound & Artist
CREATE TABLE IF NOT EXISTS sound_artist (
    s_a_id INT AUTO_INCREMENT PRIMARY KEY,
    s_a_name VARCHAR(100) NOT NULL,
    s_a_date DATE
);

CREATE TABLE IF NOT EXISTS sound (
    s_id INT AUTO_INCREMENT PRIMARY KEY,
    lyrics TEXT,
    s_link VARCHAR(500) NOT NULL,
    s_a_id INT,
    s_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (s_a_id) REFERENCES sound_artist(s_a_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS sound_produce (
    sp_id INT AUTO_INCREMENT PRIMARY KEY,
    sp_name VARCHAR(100) NOT NULL,
    sp_discription TEXT NOT NULL,
    sp_link VARCHAR(500),
    sp_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    v_id INT NOT NULL,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

-- Posts
CREATE TABLE IF NOT EXISTS post (
    p_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    post_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statuse BOOLEAN DEFAULT TRUE,
    reach INT DEFAULT 0,
    a_id VARCHAR(50),
    discription TEXT NOT NULL,
    s_id INT NULL,
    p_update TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (s_id) REFERENCES sound(s_id) ON DELETE SET NULL,
    INDEX idx_post_time (post_time),
    INDEX idx_v_id (v_id)
);

CREATE TABLE IF NOT EXISTS post_media (
    p_m_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    p_m_link VARCHAR(500) NOT NULL,
    p_m_upload_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    p_m_display BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    INDEX idx_p_id (p_id)
);

CREATE TABLE IF NOT EXISTS post_reaction (
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

CREATE TABLE IF NOT EXISTS post_comment (
    post_comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    v_id INT NOT NULL,
    post_comment_text TEXT NOT NULL,
    post_comment_media VARCHAR(500),
    parent_comment_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES post_comment(post_comment_id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id)
);

CREATE TABLE IF NOT EXISTS post_comment_reaction (
    pcr_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL,
    v_id INT NOT NULL,
    reaction_type ENUM('like', 'love', 'haha', 'wow', 'sad', 'angry') NOT NULL,
    reaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comment_id) REFERENCES post_comment(post_comment_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_comment_reaction (comment_id, v_id)
);

CREATE TABLE IF NOT EXISTS post_share (
    p_s_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    v_id INT NOT NULL,
    p_s_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    p_s_to INT NULL,
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (p_s_to) REFERENCES variant(v_id) ON DELETE SET NULL,
    INDEX idx_share_time (p_s_time)
);

CREATE TABLE IF NOT EXISTS post_save (
    p_sa_id INT AUTO_INCREMENT PRIMARY KEY,
    p_id INT NOT NULL,
    v_id INT NOT NULL,
    p_sa_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    p_sa_type ENUM('bookmark', 'watch_later') DEFAULT 'bookmark',
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_save (p_id, v_id)
);

-- Stories
CREATE TABLE IF NOT EXISTS story (
    s_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    s_link VARCHAR(500) NOT NULL,
    s_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP GENERATED ALWAYS AS (s_time + INTERVAL 24 HOUR) STORED,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    INDEX idx_expires (expires_at)
);

CREATE TABLE IF NOT EXISTS story_reaction (
    sr_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    s_id INT NOT NULL,
    sr_type ENUM('like', 'love', 'haha', 'wow', 'sad') NOT NULL,
    sr_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    FOREIGN KEY (s_id) REFERENCES story(s_id) ON DELETE CASCADE,
    UNIQUE KEY unique_story_reaction (v_id, s_id)
);

-- Notes
CREATE TABLE IF NOT EXISTS notes (
    po_id INT AUTO_INCREMENT PRIMARY KEY,
    v_id INT NOT NULL,
    note_content TEXT NOT NULL,
    note_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visibility ENUM('public', 'friends', 'only_me') DEFAULT 'public',
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    INDEX idx_note_time (note_time)
);

CREATE TABLE IF NOT EXISTS notes_reaction (
    nr_id INT AUTO_INCREMENT PRIMARY KEY,
    note_id INT NOT NULL,
    v_id INT NOT NULL,
    reaction_type ENUM('like', 'love', 'haha', 'wow', 'sad') NOT NULL,
    reaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(po_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE,
    UNIQUE KEY unique_note_reaction (note_id, v_id)
);
`;

const initializeDatabase = async () => {
  const connection = await pool.getConnection();
  try {
    const statements = createTablesSQL.split(';').filter(s => s.trim());
    
    for (const statement of statements) {
      if (statement.trim()) {
        await connection.execute(statement);
        console.log('✓ Table/index created');
      }
    }
    
    console.log('✓ Database initialized successfully');
  } catch (error) {
    console.error('Error initializing database:', error);
    throw error;
  } finally {
    connection.release();
  }
};

module.exports = initializeDatabase;
