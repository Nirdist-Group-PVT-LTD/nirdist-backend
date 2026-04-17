-- Baseline schema for Nirdist core entities

CREATE TABLE IF NOT EXISTS variant (
    v_id SERIAL PRIMARY KEY,
    v_name VARCHAR(255) NOT NULL,
    v_username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    v_birth VARCHAR(255),
    bio TEXT,
    profile_picture TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS post (
    p_id SERIAL PRIMARY KEY,
    v_id INTEGER NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    discription TEXT,
    post_time TIMESTAMP,
    reach INTEGER DEFAULT 0,
    media TEXT,
    sound TEXT,
    statuse BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS comment (
    c_id SERIAL PRIMARY KEY,
    p_id INTEGER NOT NULL,
    v_id INTEGER NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    content TEXT,
    created_at TIMESTAMP,
    statuse BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS story (
    s_id SERIAL PRIMARY KEY,
    v_id INTEGER NOT NULL,
    v_name VARCHAR(255),
    v_username VARCHAR(255),
    media TEXT,
    caption TEXT,
    created_at TIMESTAMP,
    expires_at TIMESTAMP,
    reach INTEGER DEFAULT 0,
    statuse BOOLEAN DEFAULT TRUE
);

-- Chat tables
CREATE TABLE IF NOT EXISTS chat_room (
    room_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    is_group BOOLEAN NOT NULL DEFAULT FALSE,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS chat_member (
    member_id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    joined_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS chat_message (
    message_id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL,
    sender_id INTEGER NOT NULL,
    content TEXT,
    message_type VARCHAR(50) DEFAULT 'TEXT',
    created_at TIMESTAMP
);

-- Call tables
CREATE TABLE IF NOT EXISTS call_session (
    session_id SERIAL PRIMARY KEY,
    room_id VARCHAR(255) NOT NULL UNIQUE,
    created_by INTEGER NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP,
    ended_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS call_participant (
    participant_id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    joined_at TIMESTAMP,
    left_at TIMESTAMP
);
