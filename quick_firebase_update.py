#!/usr/bin/env python3
"""
🔥 QUICK FIREBASE RULES UPDATE - VINU BHAISAHAB KA ONE-CLICK SOLUTION 🔥
Simple script to quickly update Firebase rules without menu
"""

import subprocess
import os
from datetime import datetime

def quick_update_firebase_rules():
    """Quick update of Firebase rules"""
    print("🔥 QUICK FIREBASE RULES UPDATE - VINU BHAISAHAB EDITION 🔥")
    print("=" * 60)
    
    project_id = "bazarse-8c768"
    
    # Create Firestore rules
    firestore_rules = """rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access to all documents
    match /{document=**} {
      allow read, write: if true;
    }
    
    // Vendors collection
    match /vendors/{vendorId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // Categories collection
    match /categories/{categoryId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // Offers collection
    match /offers/{offerId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // Users collection
    match /users/{userId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // Deels collection
    match /deels/{deelId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
    
    // Analytics collection
    match /analytics/{analyticsId} {
      allow read, write, create, update, delete: if true;
      allow list: if true;
    }
  }
}"""
    
    # Create Storage rules
    storage_rules = """rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow read/write access to all files
    match /{allPaths=**} {
      allow read, write: if true;
    }
    
    // Images folder
    match /images/{imageId} {
      allow read, write: if true;
    }
    
    // Videos folder
    match /videos/{videoId} {
      allow read, write: if true;
    }
    
    // Store images
    match /stores/{storeId}/{imageId} {
      allow read, write: if true;
    }
    
    // User uploads
    match /uploads/{userId}/{fileName} {
      allow read, write: if true;
    }
  }
}"""
    
    try:
        # Write rules files
        print("📝 Creating rules files...")
        
        with open('firestore.rules', 'w', encoding='utf-8') as f:
            f.write(firestore_rules)
        print("✅ firestore.rules created")
        
        with open('storage.rules', 'w', encoding='utf-8') as f:
            f.write(storage_rules)
        print("✅ storage.rules created")
        
        # Deploy Firestore rules
        print("🚀 Deploying Firestore rules...")
        result = subprocess.run([
            'firebase', 'deploy', '--only', 'firestore:rules', 
            '--project', project_id
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Firestore rules deployed successfully!")
        else:
            print(f"❌ Firestore rules deployment failed: {result.stderr}")
        
        # Deploy Storage rules
        print("🚀 Deploying Storage rules...")
        result = subprocess.run([
            'firebase', 'deploy', '--only', 'storage', 
            '--project', project_id
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Storage rules deployed successfully!")
        else:
            print(f"❌ Storage rules deployment failed: {result.stderr}")
        
        print("=" * 60)
        print("🎉 Firebase rules update completed!")
        print(f"🕒 Updated at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
    except Exception as e:
        print(f"❌ Error updating Firebase rules: {e}")

if __name__ == "__main__":
    quick_update_firebase_rules()
