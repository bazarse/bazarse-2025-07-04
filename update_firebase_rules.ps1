# 🔥 FIREBASE RULES AUTO UPDATER - VINU BHAISAHAB EDITION 🔥
Write-Host "🔥 FIREBASE RULES AUTO UPDATER - VINU BHAISAHAB EDITION 🔥" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found! Please install Python first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if pip is available
try {
    $pipVersion = pip --version 2>&1
    Write-Host "✅ pip found: $pipVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ pip not found! Please install pip first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Install required packages
Write-Host "📦 Installing required Python packages..." -ForegroundColor Yellow
try {
    pip install -r requirements.txt
    Write-Host "✅ Python packages installed successfully!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to install Python packages!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if Firebase CLI is installed
try {
    $firebaseVersion = firebase --version 2>&1
    Write-Host "✅ Firebase CLI found: $firebaseVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Firebase CLI not found!" -ForegroundColor Red
    Write-Host "💡 Please install Firebase CLI with: npm install -g firebase-tools" -ForegroundColor Yellow
    Write-Host "💡 Then login with: firebase login" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if user is logged in to Firebase
try {
    $authList = firebase auth:list 2>&1
    if ($authList -match "No authenticated users") {
        Write-Host "❌ Not logged in to Firebase!" -ForegroundColor Red
        Write-Host "💡 Please login with: firebase login" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    } else {
        Write-Host "✅ Firebase CLI authenticated!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Could not check Firebase authentication status" -ForegroundColor Yellow
}

# Run the Firebase rules updater
Write-Host "🚀 Starting Firebase Rules Auto Updater..." -ForegroundColor Cyan
try {
    python firebase_rules_updater.py
    Write-Host "🎉 Firebase Rules Update Complete!" -ForegroundColor Green
} catch {
    Write-Host "❌ Error running Firebase Rules Updater!" -ForegroundColor Red
}

Read-Host "Press Enter to exit"
