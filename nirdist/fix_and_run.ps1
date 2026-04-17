#!/usr/bin/env powershell
# Nirdist Flutter App - Fix Dependencies Script
# Run this script in the nirdist directory

Write-Host "🔧 Fixing Nirdist Flutter App Dependencies..." -ForegroundColor Green
Write-Host ""

# Step 1: Get dependencies
Write-Host "📦 Installing Flutter packages..." -ForegroundColor Cyan
flutter pub get

# Step 2: Clean build
Write-Host ""
Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Cyan
flutter clean

# Step 3: Run app
Write-Host ""
Write-Host "🚀 Launching Nirdist app..." -ForegroundColor Cyan
flutter run

Write-Host ""
Write-Host "✅ Done! The app should now run successfully." -ForegroundColor Green
