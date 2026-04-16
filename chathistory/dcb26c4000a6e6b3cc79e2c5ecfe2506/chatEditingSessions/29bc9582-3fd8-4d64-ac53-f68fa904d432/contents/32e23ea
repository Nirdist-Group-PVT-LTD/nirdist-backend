# Spring Boot Backend Setup & Startup Guide

## Quick Start (5 Minutes)

### Step 1: Start MySQL
```bash
# If MySQL is not running, start it:
# Windows (Command Prompt as Admin)
net start MySQL80

# Or start MySQL service from Services panel
```

### Step 2: Create Database
```bash
# Open MySQL command line or MySQL Workbench
mysql -u root -p

# Paste and run:
CREATE DATABASE IF NOT EXISTS nirdist CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nirdist;

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
);

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
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

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
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

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
    FOREIGN KEY (v_id) REFERENCES variant(v_id) ON DELETE CASCADE
);

CREATE INDEX idx_post_v_id ON post(v_id);
CREATE INDEX idx_post_time ON post(post_time);
CREATE INDEX idx_story_v_id ON story(v_id);
CREATE INDEX idx_comment_p_id ON comment(p_id);
CREATE INDEX idx_comment_v_id ON comment(v_id);
```

### Step 3: Configure Database Connection
Edit: `d:\Project\2026\2\nirdist-backend\src\main\resources\application.properties`

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/nirdist?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=your_mysql_password
```

### Step 4: Build & Run

Open PowerShell in `d:\Project\2026\2\nirdist-backend`:

```bash
# Install dependencies and build
mvn clean install

# Run the server
mvn spring-boot:run
```

Server will start at: `http://localhost:8080`

## Server Status Check

Once running, test with:
```bash
curl http://localhost:8080/api/health
```

Or visit: `http://localhost:8080` in browser

## Update Flutter App

Change the API URL in Flutter app:

File: `d:\Project\2026\2\nirdist\lib\services\api_client.dart`

```dart
class ApiClient {
  static const String baseUrl = 'http://localhost:8080/api';  // ← Change this for Android device use: 'http://10.0.2.2:8080/api'
```

## API Tests

### Register
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"vName":"Test User","vUsername":"testuser","email":"test@example.com","password":"password123"}'
```

### Login  
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Get Feed
```bash
curl http://localhost:8080/api/posts/feed?page=1&limit=10
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `Port 8080 already in use` | Edit `application.properties`: `server.port=8081` |
| `MySQL connection refused` | Check MySQL is running: `net start MySQL80` |
| `Build fails` | Run: `mvn clean -U install` |
| `"nirdist" database not found` | Run SQL CREATE DATABASE command above |

## Project Structure

```
nirdist-backend/
├── src/main/java/com/nirdist/
│   ├── controller/          # REST endpoints
│   ├── service/             # Business logic
│   ├── entity/              # JPA entities
│   ├── repository/          # Database access
│   ├── dto/                 # Request/response objects
│   ├── security/            # JWT utilities
│   ├── config/              # Configuration classes
│   └── NirdistBackendApplication.java
├── src/main/resources/
│   └── application.properties
└── pom.xml
```

## Next Steps

1. ✅ Backend running on http://localhost:8080
2. Update Flutter app API URL
3. Run Flutter app: `flutter run` in `d:\Project\2026\2\nirdist`
4. Test login/register from Flutter app
5. View API responses in backend console logs

## Support

For issues:
1. Check console logs for error messages
2. Verify MySQL is running
3. Confirm database tables exist
4. Check application.properties database credentials

