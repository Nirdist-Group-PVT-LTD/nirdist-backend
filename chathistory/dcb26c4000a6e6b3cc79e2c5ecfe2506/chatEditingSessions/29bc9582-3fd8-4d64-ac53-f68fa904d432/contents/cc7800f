# Nirdist Backend - Auto Startup Script (PowerShell)
# Run: powershell -ExecutionPolicy Bypass -File start-backend.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  NIRDIST BACKEND - AUTO STARTUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if MySQL is running
Write-Host "[*] Checking MySQL service..." -ForegroundColor Yellow
$mysqlService = Get-Service -Name "MySQL80" -ErrorAction SilentlyContinue

if ($null -eq $mysqlService) {
    Write-Host "[!] MySQL80 service found, checking status..." -ForegroundColor Yellow
    if ($mysqlService.Status -ne "Running") {
        Write-Host "[*] Starting MySQL80..." -ForegroundColor Yellow
        Start-Service -Name "MySQL80" -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "[+] MySQL started" -ForegroundColor Green
    } else {
        Write-Host "[+] MySQL is already running" -ForegroundColor Green
    }
} else {
    Write-Host "[+] MySQL appears to be running" -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Waiting 3 seconds for MySQL to stabilize..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Check for pom.xml
$pomPath = Join-Path $PSScriptRoot "pom.xml"
if (-not (Test-Path $pomPath)) {
    Write-Host "[!] Error: pom.xml not found" -ForegroundColor Red
    Write-Host "[*] Make sure to run this script from the nirdist-backend directory" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

# Change to backend directory
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "[*] Building Spring Boot application..." -ForegroundColor Yellow
Write-Host ""

# Build with Maven
& mvn clean install -q

if ($LASTEXITCODE -ne 0) {
    Write-Host "[!] Build failed!" -ForegroundColor Red
    Write-Host "[*] Run 'mvn clean install' for detailed errors" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "[+] Build successful" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[+] Starting Spring Boot Server..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[*] Server running on: http://localhost:8080" -ForegroundColor Cyan
Write-Host "[*] Press Ctrl+C to stop" -ForegroundColor Cyan
Write-Host ""

# Run the application
& mvn spring-boot:run

Write-Host ""
Write-Host "[*] Server stopped" -ForegroundColor Yellow
Read-Host "Press Enter to exit"
