@echo off
REM Nirdist Backend - Auto Startup Script
REM This script starts MySQL and the Spring Boot backend

echo ========================================
echo   NIRDIST BACKEND - AUTO STARTUP
echo ========================================
echo.

REM Check if MySQL is running
echo [*] Checking MySQL service...
sc query MySQL80 >nul 2>&1
if errorlevel 1 (
    echo [!] MySQL service not found. Starting MySQL80...
    net start MySQL80 >nul 2>&1
    if errorlevel 1 (
        echo [!] Could not start MySQL. Please start it manually.
        echo [*] Running 'net start MySQL80' or check Services.msc
        pause
        exit /b
    )
    echo [+] MySQL started successfully
) else (
    echo [+] MySQL is already running
)

echo.
echo [*] Waiting 3 seconds for MySQL to stabilize...
timeout /t 3 /nobreak

echo.
echo [*] Building Spring Boot application...
cd /d "%~dp0"

if not exist "pom.xml" (
    echo [!] Error: pom.xml not found. Run from nirdist-backend directory.
    pause
    exit /b
)

echo.
echo [*] Running Maven build...
call mvn clean install -q
if errorlevel 1 (
    echo [!] Build failed. Check errors above.
    pause
    exit /b
)

echo [+] Build successful
echo.
echo ========================================
echo [+] Starting Spring Boot Server...
echo ========================================
echo [*] Server will run on: http://localhost:8080
echo [*] Press Ctrl+C to stop
echo.

call mvn spring-boot:run

pause
