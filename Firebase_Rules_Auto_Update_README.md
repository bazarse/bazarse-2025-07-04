# 🔥 Firebase Rules Auto Updater - Vinu Bhaisahab Edition 🔥

**Automatic Firebase Firestore and Storage rules updater for Bazarse app**

## 📋 Prerequisites

### 1. Install Node.js and Firebase CLI
```bash
# Install Node.js from https://nodejs.org/
# Then install Firebase CLI
npm install -g firebase-tools
```

### 2. Install Python Dependencies
```bash
pip install -r requirements.txt
```

### 3. Login to Firebase
```bash
firebase login
```

## 🚀 Quick Start

### Option 1: One-Click Update (Recommended)
```bash
# Windows
update_firebase_rules.bat

# PowerShell
.\update_firebase_rules.ps1

# Python (Cross-platform)
python quick_firebase_update.py
```

### Option 2: Interactive Menu
```bash
python firebase_rules_updater.py
```

## 📁 Files Overview

| File | Description |
|------|-------------|
| `firebase_rules_updater.py` | Main interactive script with menu options |
| `quick_firebase_update.py` | One-click Firebase rules update |
| `update_firebase_rules.bat` | Windows batch file for easy execution |
| `update_firebase_rules.ps1` | PowerShell script for Windows |
| `requirements.txt` | Python dependencies |

## 🔧 Features

### ✅ Automatic Rules Creation
- **Firestore Rules**: Full read/write access for all collections
- **Storage Rules**: Full access for images, videos, and user uploads
- **Development-friendly**: No authentication required during development

### ✅ Supported Collections
- `vendors` - Store/business data
- `categories` - Product categories
- `offers` - Special offers and deals
- `users` - User profiles
- `deels` - Video deals (like Instagram Reels)
- `analytics` - App analytics data
- `orders` - Order management
- `chats` - Chat messages
- `notifications` - Push notifications
- `locations` - Location data
- `tags` - Content tags
- `reviews` - User reviews
- `promotions` - Marketing promotions
- `app_settings` - App configuration

### ✅ Storage Folders
- `images/` - General images
- `videos/` - Video content
- `stores/{storeId}/` - Store-specific media
- `uploads/{userId}/` - User uploads
- `deels/{deelId}/` - Deels video content
- `categories/{categoryId}/` - Category images
- `promotions/{promotionId}/` - Promotion media
- `app_assets/` - App assets
- `temp/` - Temporary files

## 🎯 Usage Examples

### Update All Rules (One-time)
```bash
python firebase_rules_updater.py
# Choose option 1
```

### Continuous Updates (Every Hour)
```bash
python firebase_rules_updater.py
# Choose option 4
```

### Quick Update (No Menu)
```bash
python quick_firebase_update.py
```

## 🔄 Continuous Updates

The script can run continuously and update Firebase rules at regular intervals:

```bash
# Update every hour
python firebase_rules_updater.py
# Choose option 4

# Custom interval
python firebase_rules_updater.py
# Choose option 5 and enter minutes
```

## 🛠️ Troubleshooting

### ❌ Firebase CLI Not Found
```bash
npm install -g firebase-tools
```

### ❌ Not Logged In
```bash
firebase login
```

### ❌ Python Dependencies Missing
```bash
pip install -r requirements.txt
```

### ❌ Permission Denied
```bash
# Make sure you have admin access to the Firebase project
firebase projects:list
```

## 📊 Project Configuration

The script is configured for:
- **Project ID**: `bazarse-8c768`
- **Development Mode**: Full access rules (no authentication required)
- **Auto-deployment**: Uses Firebase CLI for deployment

## 🔐 Security Notes

⚠️ **Important**: These rules provide full access for development purposes. 

For production, consider implementing proper authentication:

```javascript
// Example production rule
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

## 🎉 Success Indicators

When the script runs successfully, you'll see:
- ✅ Firebase CLI authenticated
- ✅ Firestore rules file created
- ✅ Storage rules file created  
- ✅ Firestore rules deployed successfully
- ✅ Storage rules deployed successfully

## 📞 Support

If you encounter any issues:
1. Check Firebase CLI installation: `firebase --version`
2. Verify login status: `firebase auth:list`
3. Check project access: `firebase projects:list`
4. Review error messages in the console

---

**Made with 🔥 for Vinu Bhaisahab's Bazarse App**
