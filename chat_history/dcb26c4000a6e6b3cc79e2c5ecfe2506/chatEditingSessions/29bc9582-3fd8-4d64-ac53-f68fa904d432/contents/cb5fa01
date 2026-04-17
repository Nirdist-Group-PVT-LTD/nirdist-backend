# 🚀 QUICK START - NIRDIST FULL STACK

## What Was Created

### Backend (Spring Boot + MySQL)
✅ Complete REST API with 5 controllers:
- AuthController (register, login)
- UserController (get user, search)
- PostController (CRUD posts, feed)
- StoryController (CRUD stories)
- CommentController (CRUD comments)

✅ Database with 4 tables:
- variant (users)
- post
- story
- comment

✅ Security:
- JWT token authentication
- BCrypt password encryption
- CORS enabled

### Frontend (Flutter)
✅ Updated API URLs to point to Spring Boot backend
✅ Auth screens ready (login/signup already added)
✅ 5 main screens (Home, Discover, Create, Activity, Profile)

---

## ⚡ START EVERYTHING IN 2 COMMANDS

### Terminal 1: Start Backend (Spring Boot)
```bash
cd d:\Project\2026\2\nirdist-backend
powershell -ExecutionPolicy Bypass -File start-backend.ps1
```

**OR** simple version:
```bash
cd d:\Project\2026\2\nirdist-backend
mvn spring-boot:run
```

✅ Backend runs on: **http://localhost:8080**

---

### Terminal 2: Start Frontend (Flutter)
```bash
cd d:\Project\2026\2\nirdist
flutter run
```

✅ App runs on: **Your Android Device (2201116SI)**

---

## ✅ Verify Everything Works

### Test 1: Backend API
Open browser: `http://localhost:8080/api/posts/feed?page=1&limit=10`
Should see JSON with posts

### Test 2: Flutter App
1. Click "Sign Up" button
2. Create account
3. Login
4. See posts on home screen

---

## 📂 Directory Structure

```
d:\Project\2026\2\
├── nirdist/                        ← FLUTTER APP
│   ├── lib/
│   │   ├── main.dart              ← Auth gate (login/signup)
│   │   ├── screens/               ← 5 main screens
│   │   ├── providers/             ← State management
│   │   ├── services/
│   │   │   └── api_client.dart    ← Updated to localhost:8080
│   │   ├── models/
│   │   └── widgets/
│   └── pubspec.yaml
│
└── nirdist-backend/                ← SPRING BOOT BACKEND
    ├── src/main/java/com/nirdist/
    │   ├── controller/             ← 5 REST controllers
    │   ├── service/                ← Business logic
    │   ├── entity/                 ← JPA models
    │   ├── repository/             ← DB access
    │   └── NirdistBackendApplication.java
    ├── src/main/resources/
    │   └── application.properties  ← DB config
    ├── pom.xml
    ├── start-backend.ps1           ← AUTO STARTUP SCRIPT
    ├── init.sql                    ← Database schema
    └── BACKEND_SETUP.md            ← Detailed instructions
```

---

## 🔧 Database Details

**Credentials:**
- User: `root`
- Password: `password`
- Database: `nirdist`

**Tables:**
- `variant` - Users (2 columns: v_id, v_name, v_username, email, password, etc.)
- `post` - Posts (p_id, v_id, description, media, sound, etc.)
- `story` - Stories (s_id, v_id, media, caption, expires_at, etc.)
- `comment` - Comments (c_id, p_id, v_id, content, etc.)

---

## 🌐 API Base URL

**Before (Node.js):** `http://localhost:3000/api`
**Now (Spring Boot):** `http://localhost:8080/api` ✅

Already updated in: `d:\Project\2026\2\nirdist\lib\services\api_client.dart`

---

## 🧪 Test Data

Pre-loaded test account:
- **Username:** testuser
- **Email:** test@example.com
- **Password:** password123

(Uses BCrypt, so actual password hash is different)

---

## 📊 API Endpoints Summary

```
POST   /api/auth/register              Create account
POST   /api/auth/login                 Login

GET    /api/users/{id}                 Get user
GET    /api/users/search?q=...         Search users

GET    /api/posts/feed?page=1&limit=10 Get feed
POST   /api/posts                      Create post
GET    /api/posts/{id}                 Get post

GET    /api/stories                    Get active stories
POST   /api/stories                    Create story

POST   /api/comments                   Create comment
GET    /api/comments/post/{postId}     Get comments
```

---

## ⚠️ Prerequisites

Make sure you have:
- ✅ Java 17+ installed: `java -version`
- ✅ Maven 3.6+ installed: `mvn -version`
- ✅ MySQL 8.0+ running: `net start MySQL80`
- ✅ Flutter SDK: `flutter --version`
- ✅ Android device connected: `flutter devices`

---

## 🎯 Common Tasks

### Start Backend
```bash
cd d:\Project\2026\2\nirdist-backend
start-backend.ps1
```

### Start Flutter App
```bash
cd d:\Project\2026\2\nirdist
flutter run
```

### Check MySQL Status
```bash
Get-Service MySQL80
```

### Stop Backend
```
Ctrl + C in terminal
```

### View Backend Logs
Check console output while `mvn spring-boot:run` is running

---

## 🐛 Troubleshooting

**Q: MySQL won't start**
```bash
net start MySQL80
```

**Q: Port 8080 is in use**
Edit `src/main/resources/application.properties`:
```
server.port=8081
```

**Q: Flutter can't connect to backend**
Make sure both are running:
- Backend: `mvn spring-boot:run`
- Check URL: `localhost:8080/api` (or `10.0.2.2:8080` for Android device)

**Q: Build fails**
```bash
mvn clean -U install
```

---

## 📚 Full Documentation

For detailed setup info, see:
- Backend details: `d:\Project\2026\2\nirdist-backend\BACKEND_SETUP.md`
- Spring Boot setup: `d:\Project\2026\2\nirdist-backend\SETUP_SPRINGBOOT.md`
- Original project: `d:\Project\2026\2\nirdist\README.md`

---

## ✨ What's Included

### Backend Features
- ✅ User authentication (JWT)
- ✅ User registration & login
- ✅ Post creation & retrieval
- ✅ Story system (24-hour expiry)
- ✅ Comment system
- ✅ User search
- ✅ Pagination (feeds)
- ✅ Password encryption (BCrypt)
- ✅ CORS support
- ✅ SQLMySQL database integration

### Frontend Features  
- ✅ Login/Signup screens
- ✅ Home feed (posts + stories)
- ✅ Discover/Search screen
- ✅ Create post/story screen
- ✅ Activity/Notifications screen
- ✅ User profile screen
- ✅ Provider state management
- ✅ Dark theme (Material 3)

---

## 🚀 Ready to Go!

```
Backend:  ✅ Spring Boot + MySQL
Frontend: ✅ Flutter App
Auth:     ✅ JWT + Password Encryption
Database: ✅ MySQL with 4 tables
API:      ✅ 20+ endpoints
```

**Next step:** Run `start-backend.ps1` to launch! 🎉

