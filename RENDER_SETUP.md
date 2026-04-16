# Render.com Docker Deployment - Complete Setup Guide

## Environment Variables to Add

When configuring Docker runtime on Render, go to **Environment** tab and add these:

### Database Variables
```
DB_HOST = your-database-host.render.com
DB_PORT = 3306
DB_NAME = nirdist
DB_USER = root
DB_PASSWORD = your-secure-password-here
```

### Application Variables
```
SERVER_PORT = 8080
SPRING_JPA_HIBERNATE_DDL_AUTO = update
SPRING_JPA_SHOW_SQL = false
SPRING_JPA_PROPERTIES_HIBERNATE_FORMAT_SQL = true
```

### Security Variables
```
JWT_SECRET = your-extremely-long-random-secret-key-change-this-in-production
JWT_EXPIRATION = 86400000
CORS_ORIGINS = https://your-app-domain.com,http://localhost:3000
```

### Logging
```
LOGGING_LEVEL_ROOT = INFO
LOGGING_LEVEL_COM_NIRDIST = DEBUG
SPRING_JPA_DATABASE_PLATFORM = org.hibernate.dialect.MySQL8Dialect
```

---

## Step-by-Step Setup on Render

### 1. **Create Web Service**
- Dashboard → **New +** → **Web Service**
- Connect GitHub repo (nirdist-backend)

### 2. **Configure Service**
| Field | Value |
|-------|-------|
| Name | nirdist-backend |
| Runtime | Docker |
| Branch | main |
| Build Command | (auto-detected) |
| Start Command | (auto-detected) |

### 3. **Add Environment Variables**
- Click **"Environment"** tab
- Click **"Add Environment Variable"**
- Add each variable from list above

**Example:**
```
Key: DB_HOST
Value: mysql.render.com

Key: JWT_SECRET  
Value: aB3xY9kL2mN4pQ7rS8tU1vW5xY0zAb3CdEfGhIjKlMnOpQrStUvWxYzAb3CdEfGhIjKlMnOpQr
```

### 4. **Connect Database**
- Click **"Database"** tab
- Click **"Connect Database"**
- Create new MySQL database OR connect existing
- Render auto-populates `DB_HOST`, `DB_USER`, `DB_PASSWORD`

### 5. **Deploy**
- Click **"Create Web Service"**
- Wait for build (5-10 minutes)

---

## Advanced Configuration

### Health Check (Optional but Recommended)
```
Health Check Path: /api/health
Health Check Protocol: HTTP
```

### Build Settings
```
Build Command:    (Leave blank - Dockerfile handles it)
Start Command:    (Leave blank - Dockerfile handles it)
Dockerfile Path:  ./Dockerfile (default)
```

### Regions
- **Choose closest to users:**
  - `us-east-1` - USA East
  - `us-west-1` - USA West  
  - `eu-west-1` - Europe
  - `ap-southeast-1` - Asia

### Plan
```
Free    - Good for testing (auto-sleep after 15 min inactivity)
Starter - $7/month (always on)
Standard - $25/month (better performance)
```

---

## Generate Strong JWT Secret

```bash
# On your terminal:
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
# Or:
openssl rand -hex 64
```

Copy the output and paste as `JWT_SECRET`

---

## Database Setup on Render

If creating NEW database:
1. **Render Dashboard** → **Databases**
2. **New +** → **MySQL**
3. Configuration:
   - **Name:** nirdist-db
   - **Database Name:** nirdist
   - **User:** root
   - **Region:** Same as web service
   - **Plan:** Free or Starter

4. **Create database** → Copy connection string
5. Parse connection string to get `DB_HOST`, `DB_USER`, `DB_PASSWORD`

Format: `mysql://user:password@host:port/database`

---

## Verify Deployment Success

Once deployed, test endpoints:

```bash
# Health check
curl https://nirdist-backend.onrender.com/api/health

# Login (should work if DB is connected)
curl -X POST https://nirdist-backend.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"v_username":"testuser","password":"testpass"}'
```

---

## Troubleshooting

### Build Fails
- Check **Logs** tab for errors
- Ensure `Dockerfile` exists in root
- Verify `pom.xml` is correct

### Database Connection Error
- Verify `DB_HOST`, `DB_USER`, `DB_PASSWORD` are correct
- Check database is created and running
- Ensure MySQL version is 8.0+

### Spring Boot Won't Start
- Check logs: Render Dashboard → Service → **Logs**
- Look for `JAVA_HOME` or memory issues
- Increase allocated RAM in Plan settings

### CORS Errors
- Update `CORS_ORIGINS` variable with your domain
- Or set to `*` temporarily (not production!)

---

## Production Checklist

- [ ] Change `JWT_SECRET` to 64+ character random string
- [ ] Disable `SPRING_JPA_SHOW_SQL` (set to false)
- [ ] Set `LOGGING_LEVEL_ROOT` to WARN
- [ ] Enable HTTPS only (no HTTP)
- [ ] Setup database backups
- [ ] Add rate limiting in controller
- [ ] Move to Starter or paid plan (free auto-sleeps)
- [ ] Monitor logs for errors
- [ ] Test all API endpoints
- [ ] Setup monitoring/alerts

---

## Connect Flutter App to Live Backend

Update `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'https://nirdist-backend.onrender.com/api';
```

Then rebuild and test! 🚀

---

## Reference Links

- Render Docs: https://render.com/docs
- Spring Boot on Render: https://render.com/docs/deploy-spring-boot
- MySQL on Render: https://render.com/docs/mysql
