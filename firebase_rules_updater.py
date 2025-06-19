#!/usr/bin/env python3
"""
🔥 FIREBASE RULES AUTO UPDATER - VINU BHAISAHAB KA AUTOMATIC RULES MANAGER 🔥
This script automatically updates Firebase Firestore and Storage rules
"""

import json
import requests
import subprocess
import os
import time
from datetime import datetime

class FirebaseRulesUpdater:
    def __init__(self):
        """Initialize Firebase Rules Updater"""
        self.project_id = "bazarse-8c768"
        
        print("🔥 Firebase Rules Auto Updater - Vinu Bhaisahab Edition 🔥")
        print("=" * 70)
        
    def check_firebase_cli(self):
        """Check if Firebase CLI is installed and user is logged in"""
        try:
            # Check if Firebase CLI is installed
            result = subprocess.run(['firebase', '--version'], 
                                  capture_output=True, text=True)
            
            if result.returncode != 0:
                print("❌ Firebase CLI not installed!")
                print("💡 Install with: npm install -g firebase-tools")
                return False
            
            print(f"✅ Firebase CLI version: {result.stdout.strip()}")
            
            # Check if user is logged in
            result = subprocess.run(['firebase', 'auth:list'], 
                                  capture_output=True, text=True)
            
            if "No authenticated users" in result.stdout or result.returncode != 0:
                print("❌ Not logged in to Firebase!")
                print("💡 Login with: firebase login")
                return False
            
            print("✅ Firebase CLI authenticated")
            return True
            
        except FileNotFoundError:
            print("❌ Firebase CLI not found!")
            print("💡 Install with: npm install -g firebase-tools")
            return False
        except Exception as e:
            print(f"❌ Error checking Firebase CLI: {e}")
            return False
    
    def create_firestore_rules(self):
        """Create Firestore security rules file"""
        firestore_rules = """rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 🔥 BAZARSE APP FIRESTORE RULES - VINU BHAISAHAB EDITION 🔥
    
    // Allow read/write access to all documents for development
    match /{document=**} {
      allow read, write: if true;
    }
    
    // 🏪 Vendors collection - full access
    match /vendors/{vendorId} {
      allow read, write, create, update, delete: if true;
      
      // Allow queries on vendors
      allow list: if true;
    }
    
    // 📂 Categories collection - full access  
    match /categories/{categoryId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 🎯 Offers collection - full access
    match /offers/{offerId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 👥 Users collection - full access
    match /users/{userId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 🎬 Deels collection - full access
    match /deels/{deelId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 📊 Analytics collection - full access
    match /analytics/{analyticsId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 🛒 Orders collection - full access
    match /orders/{orderId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 💬 Chats collection - full access
    match /chats/{chatId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 🔔 Notifications collection - full access
    match /notifications/{notificationId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 📍 Locations collection - full access
    match /locations/{locationId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 🏷️ Tags collection - full access
    match /tags/{tagId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 📝 Reviews collection - full access
    match /reviews/{reviewId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 🎁 Promotions collection - full access
    match /promotions/{promotionId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // 📱 App Settings collection - full access
    match /app_settings/{settingId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
  }
}"""
        
        with open('firestore.rules', 'w', encoding='utf-8') as f:
            f.write(firestore_rules)
        
        print("✅ Firestore rules file created: firestore.rules")
        return True
    
    def create_storage_rules(self):
        """Create Firebase Storage security rules file"""
        storage_rules = """rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // 🔥 BAZARSE APP STORAGE RULES - VINU BHAISAHAB EDITION 🔥
    
    // Allow read/write access to all files for development
    match /{allPaths=**} {
      allow read, write: if true;
    }
    
    // 🖼️ Images folder - full access
    match /images/{imageId} {
      allow read, write, create, update, delete: if true;
    }
    
    // 🎬 Videos folder - full access
    match /videos/{videoId} {
      allow read, write, create, update, delete: if true;
    }
    
    // 🏪 Store images - full access
    match /stores/{storeId}/{imageId} {
      allow read, write, create, update, delete: if true;
    }
    
    // 👤 User uploads - full access
    match /uploads/{userId}/{fileName} {
      allow read, write, create, update, delete: if true;
    }
    
    // 🎯 Deels videos - full access
    match /deels/{deelId}/{fileName} {
      allow read, write, create, update, delete: if true;
    }
    
    // 📂 Categories images - full access
    match /categories/{categoryId}/{fileName} {
      allow read, write, create, update, delete: if true;
    }
    
    // 🎁 Promotions media - full access
    match /promotions/{promotionId}/{fileName} {
      allow read, write, create, update, delete: if true;
    }
    
    // 📱 App assets - full access
    match /app_assets/{fileName} {
      allow read, write, create, update, delete: if true;
    }
    
    // 🔄 Temporary files - full access
    match /temp/{fileName} {
      allow read, write, create, update, delete: if true;
    }
  }
}"""
        
        with open('storage.rules', 'w', encoding='utf-8') as f:
            f.write(storage_rules)
        
        print("✅ Storage rules file created: storage.rules")
        return True
    
    def deploy_firestore_rules(self):
        """Deploy Firestore rules using Firebase CLI"""
        try:
            print("🚀 Deploying Firestore rules...")
            
            result = subprocess.run([
                'firebase', 'deploy', '--only', 'firestore:rules', 
                '--project', self.project_id
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print("✅ Firestore rules deployed successfully!")
                print(f"📝 Output: {result.stdout}")
                return True
            else:
                print(f"❌ Failed to deploy Firestore rules!")
                print(f"📝 Error: {result.stderr}")
                return False
                
        except Exception as e:
            print(f"❌ Error deploying Firestore rules: {e}")
            return False
    
    def deploy_storage_rules(self):
        """Deploy Storage rules using Firebase CLI"""
        try:
            print("🚀 Deploying Storage rules...")
            
            result = subprocess.run([
                'firebase', 'deploy', '--only', 'storage', 
                '--project', self.project_id
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print("✅ Storage rules deployed successfully!")
                print(f"📝 Output: {result.stdout}")
                return True
            else:
                print(f"❌ Failed to deploy Storage rules!")
                print(f"📝 Error: {result.stderr}")
                return False
                
        except Exception as e:
            print(f"❌ Error deploying Storage rules: {e}")
            return False
    
    def initialize_firebase_project(self):
        """Initialize Firebase project if not already initialized"""
        try:
            # Check if firebase.json exists
            if not os.path.exists('firebase.json'):
                print("🔧 Initializing Firebase project...")
                
                result = subprocess.run([
                    'firebase', 'init', '--project', self.project_id
                ], capture_output=True, text=True, input='y\ny\ny\ny\n')
                
                if result.returncode == 0:
                    print("✅ Firebase project initialized!")
                else:
                    print(f"❌ Failed to initialize Firebase project: {result.stderr}")
                    return False
            else:
                print("✅ Firebase project already initialized")
            
            return True
            
        except Exception as e:
            print(f"❌ Error initializing Firebase project: {e}")
            return False
    
    def update_all_rules(self):
        """Update all Firebase rules"""
        try:
            print("🔥 Starting complete Firebase rules update...")
            print("=" * 70)
            
            # Check prerequisites
            if not self.check_firebase_cli():
                return False
            
            # Initialize project if needed
            if not self.initialize_firebase_project():
                return False
            
            # Create rules files
            self.create_firestore_rules()
            self.create_storage_rules()
            
            # Deploy rules
            firestore_success = self.deploy_firestore_rules()
            storage_success = self.deploy_storage_rules()
            
            print("=" * 70)
            if firestore_success and storage_success:
                print("🎉 All Firebase rules updated successfully!")
                print("✅ Firestore rules: DEPLOYED")
                print("✅ Storage rules: DEPLOYED")
                print(f"🕒 Updated at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
            else:
                print("⚠️  Some rules failed to deploy!")
                print(f"{'✅' if firestore_success else '❌'} Firestore rules")
                print(f"{'✅' if storage_success else '❌'} Storage rules")
            
            return firestore_success and storage_success
            
        except Exception as e:
            print(f"❌ Error updating Firebase rules: {e}")
            return False
    
    def run_continuous_updates(self, interval_minutes=60):
        """Run continuous Firebase rules updates"""
        print(f"🔄 Starting continuous Firebase rules updates every {interval_minutes} minutes...")
        
        while True:
            try:
                print(f"\n⏰ {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - Running Firebase rules update...")
                
                self.update_all_rules()
                
                print(f"😴 Waiting {interval_minutes} minutes for next update...")
                time.sleep(interval_minutes * 60)
                
            except KeyboardInterrupt:
                print("\n🛑 Stopping continuous updates...")
                break
            except Exception as e:
                print(f"❌ Error in continuous updates: {e}")
                print("⏳ Waiting 5 minutes before retry...")
                time.sleep(300)

def main():
    """Main function"""
    updater = FirebaseRulesUpdater()
    
    print("🔥 Firebase Rules Auto Updater Menu 🔥")
    print("1. Update all Firebase rules (one-time)")
    print("2. Update Firestore rules only")
    print("3. Update Storage rules only")
    print("4. Run continuous updates (every hour)")
    print("5. Run continuous updates (custom interval)")
    print("6. Check Firebase CLI status")
    print("7. Exit")
    
    choice = input("\n👉 Enter your choice (1-7): ")
    
    if choice == "1":
        updater.update_all_rules()
    elif choice == "2":
        if updater.check_firebase_cli():
            updater.create_firestore_rules()
            updater.deploy_firestore_rules()
    elif choice == "3":
        if updater.check_firebase_cli():
            updater.create_storage_rules()
            updater.deploy_storage_rules()
    elif choice == "4":
        updater.run_continuous_updates(60)
    elif choice == "5":
        try:
            interval = int(input("Enter update interval in minutes: "))
            updater.run_continuous_updates(interval)
        except ValueError:
            print("❌ Invalid interval!")
    elif choice == "6":
        updater.check_firebase_cli()
    elif choice == "7":
        print("👋 Goodbye Vinu Bhaisahab!")
    else:
        print("❌ Invalid choice!")

if __name__ == "__main__":
    main()
