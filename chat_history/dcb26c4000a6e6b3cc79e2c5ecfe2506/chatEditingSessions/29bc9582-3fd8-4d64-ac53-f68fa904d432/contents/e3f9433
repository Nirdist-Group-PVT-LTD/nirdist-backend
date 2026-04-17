# Nirdist - Social Media App

**A modern, full-featured social media platform combining Instagram-like posts, TikTok-style audio, ephemeral stories, and real-time engagement.**

Built with:
- **Frontend:** Flutter (iOS, Android, Web)
- **Backend:** Node.js + Express
- **Database:** MySQL
- **Authentication:** JWT

## 🚀 Quick Start

### Backend Setup
```bash
cd nirdist-backend
npm install
cp .env.example .env
# Edit .env with your MySQL credentials
npm start
```

### Frontend Setup
```bash
cd nirdist
flutter pub get
flutter run
```

## 📋 Features

✅ User authentication & profiles
✅ Posts with multimedia (images/videos)
✅ 24-hour ephemeral stories
✅ Custom audio/sound creation
✅ Status notes with privacy controls
✅ Multi-reaction system (Like, Love, Haha, Wow, Sad, Angry)
✅ Threaded comments
✅ Follow/unfollow system
✅ Content discovery & search
✅ Post saving (Bookmarks, Watch Later)
✅ Post sharing

## 📁 Project Structure

```
nirdist/
├── nirdist-backend/          # Node.js server
│   ├── config/               # Database config
│   ├── controllers/          # API logic
│   ├── middleware/           # Authentication
│   ├── routes/               # API endpoints
│   ├── server.js
│   └── package.json
│
└── nirdist/                  # Flutter app
    ├── lib/
    │   ├── main.dart        # App entry
    │   ├── models/          # Data models
    │   ├── services/        # API client
    │   ├── providers/       # State management
    │   ├── screens/         # UI screens
    │   └── widgets/         # Reusable components
    └── pubspec.yaml
```

## 🔗 API Documentation

Base URL: `http://localhost:3000/api`

### Authentication
```
POST /auth/register       # Register new user
POST /auth/login          # User login
```

### Posts
```
GET  /posts/feed          # Get feed (paginated)
GET  /posts/:id           # Get post details
POST /posts               # Create post
DELETE /posts/:id         # Delete post
```

### Stories
```
GET  /stories             # Get active stories
POST /stories             # Create story
POST /stories/:id/reaction  # React to story
```

### Notes
```
GET  /notes               # Get notes
POST /notes               # Create note
POST /notes/:id/reaction  # React to note
```

### Engagement
```
POST   /reactions/:pId    # Add post reaction
GET    /comments/:pId     # Get comments
POST   /comments/:pId     # Add comment
DELETE /comments/:id      # Delete comment
```

### Social
```
POST   /follows/:id/follow     # Follow user
DELETE /follows/:id/unfollow   # Unfollow
GET    /follows/:id/followers  # Get followers
GET    /follows/:id/following  # Get following
```

### Users
```
GET  /users/:id           # Get user profile
GET  /users/search?q=     # Search users
PUT  /users/:id           # Update profile
```

## 🎯 Core Screens

### Home
- Posts feed with pagination
- Stories carousel (active 24h)
- Real-time reactions
- Nested comments

### Discover
- User search
- Sound library
- Trending content
- Tab-based browsing

### Create
- Post creation with media
- Story recording
- Audio/sound production
- Note composition

### Activity
- Reaction notifications
- Follow notifications
- Activity history

### Profile
- User information & stats
- Posts grid
- Created sounds
- Saved content

## 💾 Database

MySQL database with 20+ tables:
- `variant` - Users
- `post` - Posts
- `post_media` - Images/videos
- `story` - 24-hour stories
- `notes` - Status updates
- `sound` & `sound_produce` - Audio
- `follows` - Social graph
- `post_reaction` - Reactions
- `post_comment` - Comments
- And more...

## 🔐 Security

- JWT authentication
- Password hashing (bcryptjs)
- CORS protection
- SQL injection prevention
- Input validation

## 📦 Dependencies

### Backend
```json
{
  "express": "^4.18.2",
  "mysql2": "^3.6.0",
  "jsonwebtoken": "^9.0.0",
  "bcryptjs": "^2.4.3",
  "dotenv": "^16.0.3"
}
```

### Frontend
```yaml
provider: ^6.0.0
http: ^1.1.0
image_picker: ^0.8.0
video_player: ^2.0.0
```

## 🛠️ Development

### Running tests (Backend)
```bash
npm test
```

### Running Flutter app in debug
```bash
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

### Building for production
```bash
# Backend: Already production-ready
pm2 start server.js

# Frontend
flutter build apk      # Android
flutter build ipa      # iOS
flutter build web      # Web
```

## 📝 Configuration

### Backend (.env)
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=nirdist
JWT_SECRET=your_jwt_secret
PORT=3000
```

### Frontend (api_client.dart)
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

## 🎨 UI/UX

- **Dark theme** for media-heavy content
- **Material 3** design system
- **Responsive** layouts for all devices
- **Bottom tab navigation** for easy access
- **Infinite scroll** with pagination
- **Gesture-based** interactions

## 📈 Performance

- Database indexes for fast queries
- Pagination (10-20 items per request)
- Media caching on client
- Efficient cascading deletes
- Connection pooling

## 🔄 API Response Format

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { /* resource data */ }
}
```

Errors:
```json
{
  "success": false,
  "message": "Error description"
}
```

## 🚨 Troubleshooting

**Backend won't start?**
- Check MySQL is running: `mysql -u root -p enter_password`
- Verify .env credentials
- Check port 3000 is available

**Flutter can't connect to API?**
- Update API URL in `api_client.dart`
- Check backend is running
- Verify network/firewall

**Database errors?**
- Run setup script: `node -e "const setup = require('./config/setupDatabase'); setup()"`
- Check MySQL version compatibility
- Verify database exists

## 📚 Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Node.js Docs](https://nodejs.org/docs)
- [MySQL Docs](https://dev.mysql.com/doc/)
- [Express.js Docs](https://expressjs.com/)

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create feature branch
3. Make changes
4. Submit pull request

## 📄 License

MIT License - Feel free to use and modify

## 👨‍💻 Author

Created as a comprehensive social media platform demo

---

**Ready to launch your social media platform? Let's go! 🎉**
