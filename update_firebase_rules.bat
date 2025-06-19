@echo off
echo 🔥 FIREBASE RULES AUTO UPDATER - VINU BHAISAHAB EDITION 🔥
echo ================================================================

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found! Please install Python first.
    pause
    exit /b 1
)

REM Check if pip is available
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pip not found! Please install pip first.
    pause
    exit /b 1
)

echo ✅ Python and pip found!

REM Install required packages
echo 📦 Installing required Python packages...
pip install -r requirements.txt

REM Check if Firebase CLI is installed
firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Firebase CLI not found!
    echo 💡 Please install Firebase CLI with: npm install -g firebase-tools
    echo 💡 Then login with: firebase login
    pause
    exit /b 1
)

echo ✅ Firebase CLI found!

REM Run the Firebase rules updater
echo 🚀 Starting Firebase Rules Auto Updater...
python firebase_rules_updater.py

echo 🎉 Firebase Rules Update Complete!
pause
