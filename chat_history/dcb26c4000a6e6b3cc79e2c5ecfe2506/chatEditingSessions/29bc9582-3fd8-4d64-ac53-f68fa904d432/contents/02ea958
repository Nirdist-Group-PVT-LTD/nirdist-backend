# 🔧 Deployment Troubleshooting

## Current Status
- ✅ Code cleaned (Node.js files removed)
- ✅ Maven Wrapper configured
- ✅ Procfile ready
- ✅ Java 17 specified in system.properties
- ❌ Build failing on Render

## Quick Fix: Check Render Settings

### Step 1: Verify Environment Variables ⚙️

On **Render Dashboard** → **nirdist-backend** → **Environment**:

These MUST be set:
```
DATABASE_URL=postgresql://nirdist_postgres_user:d1MdCC7dwToHz1N1WefYja8DuEdptRHv@dpg-d7gevadckfvc73b5v420-a:5432/nirdist_postgres
DATABASE_USER=nirdist_postgres_user
DATABASE_PASSWORD=d1MdCC7dwToHz1N1WefYja8DuEdptRHv
JWT_SECRET=your-secret-key-here
PORT=8080
```

If ANY are missing → **Add them now**

### Step 2: Check Logs 📋

1. On Render Dashboard → **nirdist-backend**
2. Click **Logs** tab
3. Look for error message like:
   - "Connection refused"
   - "Cannot resolve hostname"
   - "Unknown host"
   - Compilation errors

### Step 3: Redeploy 🚀

1. Click **Manual Deploy**
2. Select latest commit: `f6c032f`
3. Click **Deploy**
4. Watch logs → Should see:
   ```
   ==> Running build command './mvnw clean install'
   [INFO] BUILD SUCCESS
   ```

## Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `PostgreSQL connection refused` | Wrong DATABASE_URL | Copy exact URL from nirdist_postgres details |
| `Cannot find mvnw` | Line ending issue | Already fixed (removed render.yaml) |
| `BUILD FAILURE` | Missing dependencies | Check internet connection on Render |
| `Port already in use` | Environment PORT conflicts | Ensure PORT=8080 is set |

## If Still Failing

1. Check **full logs** on Render (click "Download logs")
2. Look for **first error message**
3. Share the error with me
4. Alternative: Use GitHub Actions to build JAR first, then deploy

## Backup Plan: Deploy Pre-Built JAR

If Render keeps failing with Maven, we can:
1. Build JAR locally: `mvn clean install`
2. Push JAR to GitHub
3. Deploy just the JAR (no build needed)

Let me know if you need this!
