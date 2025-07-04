#!/usr/bin/env python3
"""
🔥 BAZAR SE SCRAPER SETUP - ONE-CLICK INSTALLATION 🔥
Automated setup for Google Maps scraper
"""

import subprocess
import sys
import os
from pathlib import Path

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"🔧 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e}")
        print(f"Error output: {e.stderr}")
        return False

def check_python_version():
    """Check if Python version is compatible"""
    version = sys.version_info
    if version.major == 3 and version.minor >= 8:
        print(f"✅ Python {version.major}.{version.minor} is compatible")
        return True
    else:
        print(f"❌ Python {version.major}.{version.minor} is not compatible. Need Python 3.8+")
        return False

def setup_scraper():
    """Complete setup for Bazar Se scraper"""
    print("🔥 BAZAR SE GOOGLE MAPS SCRAPER SETUP 🔥")
    print("=" * 50)
    
    # Check Python version
    if not check_python_version():
        return False
    
    # Install requirements
    if not run_command("pip install -r scraper_requirements.txt", "Installing Python packages"):
        return False
    
    # Install Playwright browsers
    if not run_command("playwright install chromium", "Installing Playwright browser"):
        return False
    
    # Create directories
    os.makedirs("Ujjain_Business_Data", exist_ok=True)
    print("✅ Created data directory")
    
    # Create Firebase service account template
    create_firebase_template()
    
    print("\n🎉 SETUP COMPLETED SUCCESSFULLY!")
    print("\n📋 Next Steps:")
    print("1. Add your Firebase service account key as 'bazarse-service-account.json'")
    print("2. Run the scraper:")
    print("   python google_maps_scraper_bazarse.py --ujjain --firebase")
    print("\n🚀 Ready to scrape Ujjain business data!")
    
    return True

def create_firebase_template():
    """Create Firebase service account template"""
    template = {
        "type": "service_account",
        "project_id": "bazarse-16d2b",
        "private_key_id": "YOUR_PRIVATE_KEY_ID",
        "private_key": "YOUR_PRIVATE_KEY",
        "client_email": "YOUR_CLIENT_EMAIL",
        "client_id": "YOUR_CLIENT_ID",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "YOUR_CERT_URL"
    }
    
    if not os.path.exists("bazarse-service-account.json"):
        import json
        with open("bazarse-service-account-template.json", "w") as f:
            json.dump(template, f, indent=2)
        print("✅ Created Firebase service account template")

if __name__ == "__main__":
    setup_scraper()
