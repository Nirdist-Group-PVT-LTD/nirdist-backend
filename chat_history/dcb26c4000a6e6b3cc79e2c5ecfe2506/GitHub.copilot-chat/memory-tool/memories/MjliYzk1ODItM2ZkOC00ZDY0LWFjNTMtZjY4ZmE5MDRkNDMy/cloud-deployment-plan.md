# Cloud Deployment Plan - Nirdist Backend

## ✅ Setup Complete

### Files Added for Cloud Deployment
- `Procfile` - Tells Render how to start the backend
- `system.properties` - Java version specification
- `.gitignore` - Excludes build artifacts from Git
- `CLOUD_DEPLOYMENT.md` - Detailed deployment guide
- `DEPLOY_CHECKLIST.md` - Quick reference checklist
- Updated `pom.xml` - Added PostgreSQL driver
- Updated `application.properties` - Environment variable support

### Database Changed
- From: H2 in-memory (local testing only)
- To: PostgreSQL (cloud hosted on Render)

### API Endpoints Ready
- Registration: `https://api.nirdist.com.np/api/auth/register`
- Login: `https://api.nirdist.com.np/api/auth/login`
- All CRUD operations

## 📋 Next Steps

### Step 1: Push to GitHub
```bash
cd d:\Project\2026\2\nirdist-backend
git remote add origin https://github.com/YOUR-USERNAME/nirdist-backend.git
git branch -M main
git push -u origin main
```

### Step 2: Deploy on Render.com (Free)
1. Create account: render.com
2. Create PostgreSQL database (free tier)
3. Create Web Service from GitHub repo
4. Add environment variables (DATABASE_URL, JWT_SECRET)

### Step 3: Point Domain with Cloudflare
1. Add CNAME record: `api` → `nirdist-backend.render.com`
2. Wait 2-5 minutes for DNS propagation

### Step 4: Update Flutter App
Change `api_client.dart`:
```dart
static const String baseUrl = 'https://api.nirdist.com.np/api';
```

## 🕐 Time Estimates
- GitHub setup: 2 minutes
- Render database: 3 minutes
- Render backend deploy: 7-10 minutes (build time)
- Cloudflare DNS: 2 minutes
- Total: ~15-20 minutes

## 📊 Free Tier Included
✅ Backend: Render.com (0.5 GB RAM, free sleep after 15 min)
✅ Database: PostgreSQL 1GB on Render
✅ DNS: Cloudflare (unlimited)
✅ Domain: api.nirdist.com.np (already registered)

## 💾 Cost
- Free tier includes everything during development
- Upgrade when needed: ~$7/month backend + $15/month database = $22/month
