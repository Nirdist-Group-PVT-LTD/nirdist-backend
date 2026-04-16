-- Drop existing tables if they exist
DROP TABLE IF EXISTS story CASCADE;
DROP TABLE IF EXISTS comment CASCADE;
DROP TABLE IF EXISTS post CASCADE;
DROP TABLE IF EXISTS variant CASCADE;

-- Create variant table (users)
CREATE TABLE variant (
    v_id SERIAL PRIMARY KEY,
    v_name VARCHAR(255) NOT NULL,
    v_username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    v_birth VARCHAR(255),
    bio TEXT,
    profile_picture VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Create post table
CREATE TABLE post (
    p_id SERIAL PRIMARY KEY,
    v_id INTEGER NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    discription TEXT,
    post_time TIMESTAMP,
    reach INTEGER DEFAULT 0,
    media TEXT,
    sound TEXT,
    statuse BOOLEAN DEFAULT true,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

-- Create comment table
CREATE TABLE comment (
    c_id SERIAL PRIMARY KEY,
    p_id INTEGER NOT NULL,
    v_id INTEGER NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    content TEXT,
    created_at TIMESTAMP,
    statuse BOOLEAN DEFAULT true,
    FOREIGN KEY (p_id) REFERENCES post(p_id) ON DELETE CASCADE,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

-- Create story table
CREATE TABLE story (
    s_id SERIAL PRIMARY KEY,
    v_id INTEGER NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    media VARCHAR(255),
    caption TEXT,
    created_at TIMESTAMP,
    expires_at TIMESTAMP,
    reach INTEGER DEFAULT 0,
    statuse BOOLEAN DEFAULT true,
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX idx_post_v_id ON post(v_id);
CREATE INDEX idx_comment_p_id ON comment(p_id);
CREATE INDEX idx_comment_v_id ON comment(v_id);
CREATE INDEX idx_story_v_id ON story(v_id);
