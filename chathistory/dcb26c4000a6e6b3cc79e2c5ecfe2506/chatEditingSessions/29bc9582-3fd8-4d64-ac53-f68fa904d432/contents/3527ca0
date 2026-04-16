# Cloud Deployment Guide

## Overview
This guide helps you deploy Nirdist Backend to Render.com with PostgreSQL database and custom domain api.nirdist.com.np via Cloudflare.

## Prerequisites
- GitHub account (free)
- Render.com account (free)
- Cloudflare account (free)
- Custom domain: api.nirdist.com.np

## Step 1: Push Backend Code to GitHub

1. Create a new repository on GitHub: **nirdist-backend**
2. In PowerShell, run:
```bash
cd d:\Project\2026\2\nirdist-backend
git remote add origin https://github.com/YOUR-USERNAME/nirdist-backend.git
git branch -M main
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username.

## Step 2: Create Render.com Account & Database

1. Go to **https://render.com** → Sign up (free)
2. After login, click **New +** button → **PostgreSQL**
3. Fill in:
   - **Name**: nirdist-postgres
   - **Database**: nirdist
   - **Region**: Choose closest to your users
   - **Plan**: Free
4. Click **Create Database**
5. Copy these values (you'll need them):
   - External Database URL
   - Host
   - Port (usually 5432)
   - Database
   - User
   - Password

## Step 3: Deploy Backend on Render

1. On Render dashboard, click **New +** → **Web Service**
2. Click **Deploy an existing repository** → Connect GitHub
3. Select **nirdist-backend** repository
4. Fill in:
   - **Name**: nirdist-backend
   - **Region**: Same as database
   - **Runtime**: Java
   - **Build Command**: `./mvnw clean install -DskipTests`
   - **Start Command**: `java -jar target/nirdist-backend-1.0.0.jar`
   - **Plan**: Free

5. Click **Create Web Service** → Wait for build (5-10 minutes)

## Step 4: Configure Environment Variables on Render

In the Web Service settings, go to **Environment** and add:

```
PORT=8080
DATABASE_URL=postgresql://[USER]:[PASSWORD]@[HOST]:[PORT]/nirdist
DATABASE_USER=[USER]
DATABASE_PASSWORD=[PASSWORD]
JWT_SECRET=your-very-long-random-secret-key-change-this-in-production
```

Get these values from PostgreSQL instance details.

Example:
```
DATABASE_URL=postgresql://user123:pass456@oregon-postgres.render.com:5432/nirdist
```

## Step 5: Configure Cloudflare DNS

1. Login to Cloudflare
2. Go to your domain **nirdist.com.np**
3. Click **DNS** tab
4. Add/Edit record:
   - **Type**: CNAME
   - **Name**: api
   - **Target**: [Your Render app URL].render.com
   - **Proxy status**: Proxied
   - **Save**

**Your Render app URL** looks like: `nirdist-backend.render.com`

## Step 6: Update Flutter App

Update `api_client.dart`:

```dart
static const String baseUrl = 'https://api.nirdist.com.np/api';
```

Rebuild and test!

## Step 7: Test Deployment

```bash
# Test registration endpoint
curl -X POST https://api.nirdist.com.np/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "v_name": "Test User",
    "v_username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

## Troubleshooting

### Build fails
- Check logs: `renderctl logs nirdist-backend`
- Verify Java 17+ compatibility
- Check pom.xml dependencies

### Database connection error
- Verify DATABASE_URL in environment variables
- Check database is running on Render
- Test connection string locally

### Domain not working
- Wait 2-5 minutes for DNS propagation
- Clear browser cache
- Test with: `nslookup api.nirdist.com.np`

### App sleeps (free tier)
- Render free tier puts app to sleep after 15 minutes inactivity
- Wake it up by accessing the URL
- Upgrade to paid plan to prevent sleep

## Upgrade Path (When Ready)

1. **Render**: Change Web Service plan from Free to Paid ($7/month)
2. **Database**: Render PostgreSQL free tier saves, paid tier for production
3. **Cloudflare**: Free plan sufficient for DNS

## Important Notes

✅ **Always push code changes** before Render will rebuild
✅ **Keep secrets in environment variables**, never in code
✅ **Test locally first** before deploying to cloud
✅ **Monitor logs** for errors: Render Dashboard → Logs

Good luck! 🚀
