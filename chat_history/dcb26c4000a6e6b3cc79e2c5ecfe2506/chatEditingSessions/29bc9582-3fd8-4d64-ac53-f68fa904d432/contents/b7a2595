# COMPLETE BACKEND & DATABASE SETUP GUIDE

## 🚀 FASTEST WAY TO GET STARTED (10 minutes)

### Option A: Automated PowerShell Script (RECOMMENDED)

1. **Open PowerShell as Administrator**
   - Right-click PowerShell, select "Run as Administrator"

2. **Navigate to backend directory:**
   ```powershell
   cd "d:\Project\2026\2\nirdist-backend"
   ```

3. **Run the startup script:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File start-backend.ps1
   ```

The script will:
- ✅ Start MySQL service
- ✅ Build the Spring Boot application
- ✅ Start the server on http://localhost:8080

**Done!** Server is running.

---

### Option B: Manual Setup (If Option A fails)

#### Step 1: Start MySQL
```bash
# Open Command Prompt as Administrator
net start MySQL80
```

#### Step 2: Create Database
```bash
# Open MySQL Command Line
mysql -u root -p

# Then run these SQL commands:
CREATE DATABASE IF NOT EXISTS nirdist CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nirdist;

# Run contents of init.sql file (or copy-paste the schema)
# See init.sql in this directory
```

#### Step 3: Configure Application
Edit `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/nirdist?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=your_mysql_password
```

#### Step 4: Build & Run
```bash
# In PowerShell at d:\Project\2026\2\nirdist-backend
mvn clean install
mvn spring-boot:run
```

**Server runs at: http://localhost:8080** ✅

---

## 🐳 Docker Option (If you have Docker installed)

```bash
cd d:\Project\2026\2\nirdist-backend
docker-compose up
```

This starts:
- MySQL on localhost:3306
- Spring Boot on localhost:8080

---

## ✅ Verify Backend is Running

### Method 1: Browser
- Open: http://localhost:8080/api/posts/feed?page=1&limit=10
- Should see JSON response with posts array

### Method 2: PowerShell
```powershell
curl http://localhost:8080/api/posts/feed?page=1&limit=10
```

### Method 3: From Flutter App
- Update `lib/services/api_client.dart` baseUrl to `http://localhost:8080/api`
- Run: `flutter run`
- Login/Register should work

---

## 📁 Backend Project Structure

```
nirdist-backend/
├── src/main/java/com/nirdist/
│   ├── controller/
│   │   ├── AuthController.java
│   │   ├── UserController.java
│   │   ├── PostController.java
│   │   ├── StoryController.java
│   │   └── CommentController.java
│   ├── service/
│   │   ├── AuthService.java
│   │   ├── UserService.java
│   │   ├── PostService.java
│   │   ├── StoryService.java
│   │   └── CommentService.java
│   ├── entity/
│   │   ├── User.java
│   │   ├── Post.java
│   │   ├── Story.java
│   │   └── Comment.java
│   ├── repository/
│   │   ├── UserRepository.java
│   │   ├── PostRepository.java
│   │   ├── StoryRepository.java
│   │   └── CommentRepository.java
│   ├── dto/
│   │   ├── LoginRequest.java
│   │   ├── RegisterRequest.java
│   │   ├── AuthResponse.java
│   │   └── UserDTO.java
│   ├── security/
│   │   └── JwtTokenProvider.java
│   ├── config/
│   │   └── PasswordEncoderConfig.java
│   └── NirdistBackendApplication.java
├── src/main/resources/
│   └── application.properties
├── pom.xml
├── start-backend.ps1         ← RUN THIS SCRIPT
├── start-backend.bat
├── docker-compose.yml
├── init.sql
└── README.md
```

---

## 🔌 API Endpoints

### Auth
```bash
POST   /api/auth/register      # Create new account
POST   /api/auth/login         # Login
```

### Users
```bash
GET    /api/users/{id}                # Get user by ID
GET    /api/users/username/{username} # Get user by username
GET    /api/users/search?q=query      # Search users
```

### Posts
```bash
GET    /api/posts/feed?page=1&limit=10  # Get feed
POST   /api/posts                        # Create post
GET    /api/posts/{id}                   # Get post
GET    /api/posts/user/{userId}         # Get user's posts
DELETE /api/posts/{id}                   # Delete post
```

### Stories
```bash
GET    /api/stories              # Get active stories
POST   /api/stories              # Create story
GET    /api/stories/{id}         # Get story
GET    /api/stories/user/{userId} # Get user stories
DELETE /api/stories/{id}         # Delete story
```

### Comments
```bash
GET    /api/comments/{id}            # Get comment
POST   /api/comments                 # Create comment
GET    /api/comments/post/{postId}   # Get post comments
DELETE /api/comments/{id}            # Delete comment
```

---

## 🧪 Test API Calls

### Register User
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "vName": "John Doe",
    "vUsername": "johndoe",
    "email": "john@example.com",
    "password": "password123",
    "bio": "Developer",
    "profilePicture": ""
  }'
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "user": {
    "vId": 2,
    "vName": "John Doe",
    "vUsername": "johndoe",
    "email": "john@example.com",
    "bio": "Developer",
    "profilePicture": "",
    "followerCount": 0,
    "followingCount": 0,
    "postCount": 0
  },
  "message": "Registration successful"
}
```

### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Create Post
```bash
curl -X POST http://localhost:8080/api/posts \
  -H "Content-Type: application/json" \
  -d '{
    "vId": 1,
    "vName": "John Doe",
    "vUsername": "johndoe",
    "discription": "Amazing post! 🎉",
    "media": "[]"
  }'
```

---

## ⚙️ Troubleshooting

| Issue | Solution |
|-------|----------|
| **Port 8080 in use** | Change in `application.properties`: `server.port=8081` |
| **MySQL not found** | Ensure MySQL 8.0+ is installed. Start: `net start MySQL80` |
| **"nirdist" DB doesn't exist** | Run SQL commands from `init.sql` |
| **Connection refused** | Check MySQL is running: `Get-Service MySQL80` |
| **Build fails** | Run: `mvn clean -U install` |
| **JWT errors** | Check `jwt.secret` in `application.properties` |

---

## 📱 Connect Flutter App

1. **Update API URL** in `lib/services/api_client.dart`:
   ```dart
   // For localhost development
   static const String baseUrl = 'http://localhost:8080/api';
   
   // For Android device/emulator
   static const String baseUrl = 'http://10.0.2.2:8080/api';
   ```

2. **Run Flutter**:
   ```bash
   cd d:\Project\2026\2\nirdist
   flutter run
   ```

3. **Test**:
   - Try Register
   - Try Login
   - View Feed
   - Create Post

---

## 🔑 Database Security Notes

**IMPORTANT FOR PRODUCTION:**
- Change MySQL password from `password` to something strong
- Change `jwt.secret` in `application.properties` to a long random string
- Use environment variables for sensitive data
- Enable HTTPS
- Implement rate limiting
- Add API authentication tokens

---

## 📊 Testing Workflow

1. ✅ Start MySQL
2. ✅ Start Spring Boot backend
3. ✅ Test API with curl commands above
4. ✅ Update Flutter app API URL
5. ✅ Run `flutter run`
6. ✅ Test Register/Login from app
7. ✅ Create posts/stories
8. ✅ View feed

---

## 💾 Database Backup

```bash
# Backup database
mysqldump -u root -p nirdist > nirdist_backup.sql

# Restore database  
mysql -u root -p nirdist < nirdist_backup.sql
```

---

## 🎯 Next Steps

After backend is running:

1. **Frontend Testing**
   - Run Flutter app
   - Test all screens
   - Verify API calls work

2. **Production Deployment**
   - Build Spring Boot JAR
   - Set up cloud database (AWS RDS, Google Cloud SQL)
   - Deploy to cloud server (Heroku, AWS, DigitalOcean)

3. **Monitoring**
   - Add logging
   - Set up error tracking
   - Monitor database performance

---

## 📞 Support

Need help? Check:
1. Logs in console (error messages)
2. MySQL is running
3. Database `nirdist` exists with tables
4. application.properties is configured correctly
5. Java 17+ is installed: `java -version`
6. Maven 3.6+ is installed: `mvn -version`

---

**Status**: ✅ Backend ready for deployment!
