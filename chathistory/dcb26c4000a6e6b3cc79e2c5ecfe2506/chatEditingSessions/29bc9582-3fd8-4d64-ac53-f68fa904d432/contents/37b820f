# Nirdist Backend Setup

## Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Setup environment variables:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your MySQL database credentials:
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_password
   DB_NAME=nirdist
   DB_PORT=3306
   JWT_SECRET=your_secret_key
   PORT=3000
   ```

3. **Create MySQL database:**
   ```sql
   CREATE DATABASE nirdist;
   ```

4. **Initialize database tables:**
   ```bash
   node -e "const setup = require('./config/setupDatabase'); setup().then(() => process.exit(0));"
   ```

5. **Start the server:**
   ```bash
   # Development
   npm run dev

   # Production
   npm start
   ```

Server runs at: `http://localhost:3000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Users
- `GET /api/users/:v_id` - Get user profile
- `GET /api/users/search?q=query` - Search users
- `PUT /api/users/:v_id` - Update profile

### Posts
- `GET /api/posts/feed` - Get feed
- `GET /api/posts/:p_id` - Get post details
- `POST /api/posts` - Create post
- `DELETE /api/posts/:p_id` - Delete post

### Stories
- `GET /api/stories` - Get stories
- `POST /api/stories` - Create story
- `POST /api/stories/:s_id/reaction` - React to story

### Notes
- `GET /api/notes` - Get notes
- `POST /api/notes` - Create note
- `POST /api/notes/:po_id/reaction` - React to note

### Sounds
- `GET /api/sounds` - Get sounds
- `GET /api/sounds/user/:v_id` - Get user sounds
- `POST /api/sounds` - Create sound

### Comments
- `GET /api/comments/:p_id` - Get post comments
- `POST /api/comments/:p_id` - Add comment
- `DELETE /api/comments/:comment_id` - Delete comment

### Reactions
- `GET /api/reactions/:p_id` - Get post reactions
- `POST /api/reactions/:p_id` - Add reaction

### Follows
- `GET /api/follows/:v_id/followers` - Get followers
- `GET /api/follows/:v_id/following` - Get following
- `POST /api/follows/:followee_id/follow` - Follow user
- `DELETE /api/follows/:followee_id/unfollow` - Unfollow user

## Project Structure

```
nirdist-backend/
├── config/
│   ├── database.js          # Database connection
│   └── setupDatabase.js     # DB initialization
├── controllers/             # Route handlers
│   ├── authController.js
│   ├── userController.js
│   ├── postController.js
│   └── ...
├── middleware/
│   └── auth.js             # JWT authentication
├── routes/                 # API routes
│   ├── auth.js
│   ├── posts.js
│   └── ...
├── server.js               # Entry point
├── package.json
└── .env                    # Environment variables
```

## Database Schema

The MySQL database includes the following main tables:
- `variant` - Users
- `post` - Posts
- `story` - 24-hour stories
- `notes` - Short text updates
- `sound` - Audio tracks
- `follows` - Follow system
- `post_reaction` - Post reactions
- `post_comment` - Post comments
- And more...

See `data.sql` in the project root for full schema.

## Technologies

- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** MySQL with mysql2
- **Authentication:** JWT
- **Password hashing:** bcryptjs
