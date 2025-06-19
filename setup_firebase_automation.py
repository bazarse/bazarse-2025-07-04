#!/usr/bin/env python3
"""
🚀 FIREBASE AUTOMATION SETUP - VINU BHAISAHAB KA INSTALLER 🚀
One-click setup for Firebase Auto-Updater system
"""

import os
import sys
import json
import subprocess
import requests
from pathlib import Path

class FirebaseAutomationSetup:
    def __init__(self):
        self.project_root = Path.cwd()
        self.service_account_path = self.project_root / "bazarse-service-account.json"
        
    def print_banner(self):
        """Print setup banner"""
        print("=" * 60)
        print("🔥 FIREBASE AUTO-UPDATER SETUP 🔥")
        print("Vinu Bhaisahab ka Automation System")
        print("=" * 60)
        print()
        
    def check_python_version(self):
        """Check if Python version is compatible"""
        print("🐍 Checking Python version...")
        if sys.version_info < (3, 8):
            print("❌ Python 3.8+ required. Current version:", sys.version)
            return False
        print("✅ Python version compatible:", sys.version.split()[0])
        return True
        
    def install_dependencies(self):
        """Install required Python packages"""
        print("\n📦 Installing dependencies...")
        try:
            subprocess.check_call([
                sys.executable, "-m", "pip", "install", "-r", "requirements.txt"
            ])
            print("✅ Dependencies installed successfully!")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to install dependencies: {e}")
            return False
            
    def create_service_account_template(self):
        """Create service account template"""
        print("\n🔑 Creating service account template...")
        
        template = {
            "type": "service_account",
            "project_id": "bazarse-8c768",
            "private_key_id": "YOUR_PRIVATE_KEY_ID",
            "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY\n-----END PRIVATE KEY-----\n",
            "client_email": "firebase-adminsdk-xxxxx@bazarse-8c768.iam.gserviceaccount.com",
            "client_id": "YOUR_CLIENT_ID",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xxxxx%40bazarse-8c768.iam.gserviceaccount.com"
        }
        
        with open("bazarse-service-account-template.json", "w") as f:
            json.dump(template, f, indent=2)
            
        print("✅ Service account template created!")
        print("📝 Please download your actual service account key from:")
        print("   https://console.firebase.google.com/project/bazarse-8c768/settings/serviceaccounts/adminsdk")
        print("   And save it as 'bazarse-service-account.json'")
        
    def create_env_file(self):
        """Create environment file"""
        print("\n🔧 Creating environment configuration...")
        
        env_content = """# 🔥 FIREBASE AUTO-UPDATER ENVIRONMENT 🔥
FIREBASE_PROJECT_ID=bazarse-8c768
FIREBASE_STORAGE_BUCKET=bazarse-8c768.firebasestorage.app
FIREBASE_SENDER_ID=1089855615062

# 📱 APP SETTINGS
APP_NAME=Bazarse
APP_VERSION=1.0.0
ENVIRONMENT=production

# 🕐 UPDATE INTERVALS (in minutes)
DEELS_UPDATE_INTERVAL=30
STORES_UPDATE_INTERVAL=60
ANALYTICS_UPDATE_INTERVAL=120
NOTIFICATIONS_UPDATE_INTERVAL=240

# 🔔 NOTIFICATION SETTINGS
ENABLE_NOTIFICATIONS=true
MAX_NOTIFICATIONS_PER_DAY=10

# 📊 ANALYTICS SETTINGS
ENABLE_ANALYTICS=true
ANALYTICS_RETENTION_DAYS=90

# 🧹 CLEANUP SETTINGS
ENABLE_AUTO_CLEANUP=true
CLEANUP_EXPIRED_DEELS=true
CLEANUP_OLD_ANALYTICS=true
"""
        
        with open(".env", "w") as f:
            f.write(env_content)
            
        print("✅ Environment file created!")
        
    def create_startup_script(self):
        """Create startup script"""
        print("\n🚀 Creating startup scripts...")
        
        # Windows batch file
        windows_script = """@echo off
echo 🔥 Starting Firebase Auto-Updater...
echo Vinu Bhaisahab ka Automation System
echo.

REM Check if service account exists
if not exist "bazarse-service-account.json" (
    echo ❌ Service account file not found!
    echo Please download it from Firebase Console
    pause
    exit /b 1
)

echo ✅ Starting automation...
python firebase_auto_updater.py
pause
"""
        
        with open("start_automation.bat", "w") as f:
            f.write(windows_script)
            
        # Linux/Mac shell script
        unix_script = """#!/bin/bash
echo "🔥 Starting Firebase Auto-Updater..."
echo "Vinu Bhaisahab ka Automation System"
echo

# Check if service account exists
if [ ! -f "bazarse-service-account.json" ]; then
    echo "❌ Service account file not found!"
    echo "Please download it from Firebase Console"
    exit 1
fi

echo "✅ Starting automation..."
python3 firebase_auto_updater.py
"""
        
        with open("start_automation.sh", "w") as f:
            f.write(unix_script)
            
        # Make shell script executable
        os.chmod("start_automation.sh", 0o755)
        
        print("✅ Startup scripts created!")
        print("   - Windows: start_automation.bat")
        print("   - Linux/Mac: start_automation.sh")
        
    def create_systemd_service(self):
        """Create systemd service for Linux"""
        print("\n🔧 Creating systemd service...")
        
        service_content = f"""[Unit]
Description=Firebase Auto-Updater for Bazarse
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory={self.project_root}
ExecStart=/usr/bin/python3 {self.project_root}/firebase_auto_updater.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
"""
        
        with open("firebase-auto-updater.service", "w") as f:
            f.write(service_content)
            
        print("✅ Systemd service created!")
        print("📝 To install as system service:")
        print("   sudo cp firebase-auto-updater.service /etc/systemd/system/")
        print("   sudo systemctl enable firebase-auto-updater")
        print("   sudo systemctl start firebase-auto-updater")
        
    def create_docker_setup(self):
        """Create Docker setup"""
        print("\n🐳 Creating Docker setup...")
        
        dockerfile = """FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Create logs directory
RUN mkdir -p logs

# Run the application
CMD ["python", "firebase_auto_updater.py"]
"""
        
        with open("Dockerfile", "w") as f:
            f.write(dockerfile)
            
        docker_compose = """version: '3.8'

services:
  firebase-auto-updater:
    build: .
    container_name: bazarse-firebase-updater
    restart: unless-stopped
    volumes:
      - ./logs:/app/logs
      - ./bazarse-service-account.json:/app/bazarse-service-account.json:ro
    environment:
      - PYTHONUNBUFFERED=1
    networks:
      - bazarse-network

networks:
  bazarse-network:
    driver: bridge
"""
        
        with open("docker-compose.yml", "w") as f:
            f.write(docker_compose)
            
        print("✅ Docker setup created!")
        print("📝 To run with Docker:")
        print("   docker-compose up -d")
        
    def create_monitoring_script(self):
        """Create monitoring script"""
        print("\n📊 Creating monitoring script...")
        
        monitoring_script = """#!/usr/bin/env python3
import requests
import json
import time
from datetime import datetime

def check_firebase_status():
    \"\"\"Check Firebase Auto-Updater status\"\"\"
    try:
        # Check if log file exists and is recent
        import os
        log_file = "firebase_auto_updater.log"
        
        if os.path.exists(log_file):
            # Check last modification time
            last_modified = os.path.getmtime(log_file)
            current_time = time.time()
            
            if current_time - last_modified < 3600:  # 1 hour
                print("✅ Firebase Auto-Updater is running")
                return True
            else:
                print("⚠️ Firebase Auto-Updater may be stuck")
                return False
        else:
            print("❌ Firebase Auto-Updater log not found")
            return False
            
    except Exception as e:
        print(f"❌ Error checking status: {e}")
        return False

def send_status_notification(status):
    \"\"\"Send status notification\"\"\"
    # You can integrate with Slack, Discord, or email here
    print(f"📱 Status: {status}")

if __name__ == "__main__":
    status = check_firebase_status()
    send_status_notification("Running" if status else "Not Running")
"""
        
        with open("monitor_automation.py", "w") as f:
            f.write(monitoring_script)
            
        print("✅ Monitoring script created!")
        
    def print_instructions(self):
        """Print final setup instructions"""
        print("\n" + "=" * 60)
        print("🎉 SETUP COMPLETE! 🎉")
        print("=" * 60)
        print()
        print("📋 NEXT STEPS:")
        print("1. Download service account key from Firebase Console:")
        print("   https://console.firebase.google.com/project/bazarse-8c768/settings/serviceaccounts/adminsdk")
        print("   Save as: bazarse-service-account.json")
        print()
        print("2. Start the automation:")
        print("   Windows: start_automation.bat")
        print("   Linux/Mac: ./start_automation.sh")
        print()
        print("3. Monitor logs:")
        print("   tail -f firebase_auto_updater.log")
        print()
        print("🔥 Features enabled:")
        print("   ✅ Auto-generate deels every 30 minutes")
        print("   ✅ Update stores every hour")
        print("   ✅ Generate analytics every 2 hours") 
        print("   ✅ Send notifications every 4 hours")
        print("   ✅ Daily cleanup at 2:00 AM")
        print()
        print("🚀 Your Firebase will now auto-update continuously!")
        print("💪 Zomato, Swiggy ko takkar dene ke liye ready!")
        
    def run_setup(self):
        """Run complete setup"""
        self.print_banner()
        
        if not self.check_python_version():
            return False
            
        if not self.install_dependencies():
            return False
            
        self.create_service_account_template()
        self.create_env_file()
        self.create_startup_script()
        self.create_systemd_service()
        self.create_docker_setup()
        self.create_monitoring_script()
        self.print_instructions()
        
        return True

if __name__ == "__main__":
    setup = FirebaseAutomationSetup()
    setup.run_setup()
