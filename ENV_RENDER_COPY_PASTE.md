# COPY-PASTE These Environment Variables into Render

## Format: Copy each line as NAME=value

```
DATABASE_URL=jdbc:postgresql://dpg-d7gevqdckfvc73b5v420-a.onrender.com:5432/nirdist_postgres
DATABASE_USER=nirdist_postgres_user
DATABASE_PASSWORD=diMdCC7dwToHzlN1WeIYja8DuEdptRHv
JWT_SECRET=aB3xY9kL2mN4pQ7rS8tU1vW5xY0zAb3CdEfGhIjKlMnOpQrStUvWxYzAb3CdEfGhIjKlMnOpQr
PORT=8080
SPRING_JPA_HIBERNATE_DDL_AUTO=update
LOGGING_LEVEL_ROOT=INFO
```

---

## Step-by-Step in Render:

### 1. For each variable above:
   - Click **"Add Environment Variable"**
   - **NAME_OF_VARIABLE** = `DATABASE_URL`
   - **value** = `jdbc:postgresql://dpg-d7gevqdckfvc73b5v420-a.onrender.com:5432/nirdist_postgres`
   - Click **Add**

### 2. Repeat for:
   - `DATABASE_USER` = `nirdist_postgres_user`
   - `DATABASE_PASSWORD` = `diMdCC7dwToHzlN1WeIYja8DuEdptRHv`
   - `JWT_SECRET` = `aB3xY9kL2mN4pQ7rS8tU1vW5xY0zAb3CdEfGhIjKlMnOpQrStUvWxYzAb3CdEfGhIjKlMnOpQr`
   - `PORT` = `8080`
   - `SPRING_JPA_HIBERNATE_DDL_AUTO` = `update`
   - `LOGGING_LEVEL_ROOT` = `INFO`

### 3. Then Click:
   - **"Create Web Service"**
   - **Wait 5-10 minutes** for deployment

---

## Or Upload .env File

Create file named `.env.render` with:
```
DATABASE_URL=jdbc:postgresql://dpg-d7gevqdckfvc73b5v420-a.onrender.com:5432/nirdist_postgres
DATABASE_USER=nirdist_postgres_user
DATABASE_PASSWORD=diMdCC7dwToHzlN1WeIYja8DuEdptRHv
JWT_SECRET=aB3xY9kL2mN4pQ7rS8tU1vW5xY0zAb3CdEfGhIjKlMnOpQrStUvWxYzAb3CdEfGhIjKlMnOpQr
PORT=8080
SPRING_JPA_HIBERNATE_DDL_AUTO=update
LOGGING_LEVEL_ROOT=INFO
```

Then in Render click **"Add from .env"** and upload this file.

---

## Done! Your backend will:
✅ Build with Maven & Docker
✅ Connect to PostgreSQL database
✅ Start on port 8080
✅ Be live at: `https://nirdist-backend.onrender.com`
