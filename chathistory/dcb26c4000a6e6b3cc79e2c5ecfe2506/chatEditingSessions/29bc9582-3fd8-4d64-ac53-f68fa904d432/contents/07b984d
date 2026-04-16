# ☁️ Cloud Deployment Checklist

## Quick Start (15 minutes)

### 1️⃣ GitHub Setup
```bash
cd d:\Project\2026\2\nirdist-backend

# Create repo on github.com first, then:
git remote add origin https://github.com/YOUR-USERNAME/nirdist-backend.git
git branch -M main
git push -u origin main
```

### 2️⃣ Render.com Setup (Free Tier)

#### A. Create Database
1. Go to https://render.com → Sign up
2. New → PostgreSQL
3. Name: `nirdist-postgres`
4. Database: `nirdist`
5. Plan: **Free**
6. Create → **COPY connection details**

#### B. Deploy Backend
1. New → Web Service
2. Connect your GitHub account
3. Select `nirdist-backend` repo
4. Name: `nirdist-backend`
5. Runtime: **Java**
6. Build Command: `./mvnw clean install -DskipTests`
7. Start Command: `java -jar target/nirdist-backend-1.0.0.jar`
8. Plan: **Free**
9. Create → **Wait 5-10 minutes**

#### C. Add Environment Variables
In Web Service → Environment → Add:
```
PORT=8080
DATABASE_URL=postgresql://USER:PASS@HOST:5432/nirdist
DATABASE_USER=USER
DATABASE_PASSWORD=PASS
JWT_SECRET=your-random-secret-key-here
```

### 3️⃣ Cloudflare DNS
1. Go to Cloudflare → Your Domain (nirdist.com.np)
2. DNS tab
3. Add CNAME record:
   - Type: CNAME
   - Name: api
   - Target: nirdist-backend.render.com
   - Save

### 4️⃣ Test
```bash
curl https://api.nirdist.com.np/api/auth/register
```

### 5️⃣ Update Flutter App
Change in `lib/services/api_client.dart`:
```dart
static const String baseUrl = 'https://api.nirdist.com.np/api';
```

## 🆘 Issues & Solutions

| Issue | Solution |
|-------|----------|
| Build fails | Check Java version, run `git push` again |
| Can't reach api.nirdist.com.np | Wait for DNS propagation (2-5 min), clear cache |
| Database error | Verify DATABASE_URL format, check database is online |
| App sleeps (free tier) | Wake by accessing URL, upgrade to paid later |

## 📊 Free Tier Limits

- **Render Backend**: 0.5 GB RAM, sleeps after 15 min inactivity
- **Render DB**: 1 GB storage, PostgreSQL
- **Cloudflare**: Unlimited DNS, 100k requests/day

## 💰 Cost After Free Trial

- Render Backend: $7/month (no sleep)
- Render DB: $15/month (production)
- Cloudflare: Free for hobby use

## 🚀 Ready to Deploy?

1. Ensure all files are committed: `git status`
2. Push to GitHub: `git push`
3. Go to Render and create Web Service
4. Follow steps above
5. Share api.nirdist.com.np with users!

Questions? Check CLOUD_DEPLOYMENT.md for detailed guide.
