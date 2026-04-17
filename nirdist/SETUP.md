# Nirdist Flutter App Setup

## Quick Start

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Add required pubspec.yaml dependencies:**
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     provider: ^6.0.0
     http: ^1.1.0
     image_picker: ^0.8.0
     video_player: ^2.0.0
   
   dev_dependencies:
     flutter_test:
       sdk: flutter
   ```

3. **Run `flutter pub get`:**
   ```bash
   flutter pub get
   ```

4. **Update backend API URL:**
   Edit `lib/services/api_client.dart` and update `baseUrl` to your backend server:
   ```dart
   static const String baseUrl = 'http://your-backend-url:3000/api';
   ```

5. **Run the app:**
   ```bash
   # Development
   flutter run

   # Release build
   flutter build apk  # Android
   flutter build ipa  # iOS
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── models.dart             # Data models
├── services/
│   ├── api_client.dart         # API communication
│   └── file_upload_service.dart # File uploads
├── providers/
│   └── app_providers.dart      # State management
├── screens/
│   ├── home_screen.dart
│   ├── discover_screen.dart
│   ├── create_screen.dart
│   ├── activity_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── post_card.dart          # Post display
    ├── story_carousel.dart     # Stories carousel
    └── note_bubble.dart        # Note display
```

## Features Implemented

### Home Screen
- Feed of posts with pagination
- Stories carousel (24-hour expiration)
- Post reactions (Like, Love, Haha, Wow, Sad, Angry)
- Comments display with nesting support
- Share and save options

### Discover Screen
- Search for users, sounds, and posts
- Tab-based browsing (Users, Sounds, Trending)
- User profile preview on tap

### Create Screen
- Create posts with image/video upload
- Create 24-hour stories
- Record and upload custom audio sounds
- Create status notes with visibility control (Public, Friends, Only Me)

### Activity Screen
- Notifications for post reactions and comments
- Follow notifications
- Activity tabs organization

### Profile Screen
- User profile display with stats
- Posts grid
- Created sounds list
- Saved posts/videos (Bookmarks & Watch Later)

## Key Models

- **User** - User profile with contact information
- **Post** - Posts with media, sounds, reactions, comments
- **Story** - 24-hour ephemeral content
- **Note** - Status updates with visibility control
- **Sound** - Audio tracks (library or user-created)
- **Comment** - Threaded comments with reactions

## API Client Examples

```dart
// Get feed
List<Post> posts = await ApiClient.getFeed(page: 1, limit: 10);

// Create post
await ApiClient.createPost(discription: "Hello", s_id: null);

// Follow user
await ApiClient.followUser(followeeId);

// Add reaction
await ApiClient.addPostReaction(postId, 'love');
```

## State Management (Provider)

- **PostProvider** - Manages feed and posts
- **UserProvider** - Manages user data and searching
- **StoryProvider** - Manages stories

## Customization

### Dark Mode
The app uses a dark theme by default. To customize colors, edit `main.dart`:
```dart
theme: ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.red,
  // Customize colors here
),
```

### API Configuration
Update the base URL in `api_client.dart` for your backend server.

### File Upload Limits
Update `server.js` in backend for larger file uploads:
```javascript
app.use(express.json({ limit: '50mb' }));
```

## Testing

Test the API locally with:
```bash
# Get health check
curl http://localhost:3000/api/health

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"v_username":"user1","password":"pass123"}'

# Get feed
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:3000/api/posts/feed
```

## Troubleshooting

- **Can't connect to backend:** Check API URL in `api_client.dart`
- **File upload fails:** Ensure backend has `/uploads` directory
- **Models not loading:** Run `flutter pub get`
- **UI not updating:** Ensure providers are properly wrapped

## Dependencies

- **provider** - State management
- **http** - HTTP client
- **image_picker** - Image/video selection
- **video_player** - Video playback
