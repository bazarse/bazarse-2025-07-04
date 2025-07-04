# 🔐 API Keys Setup Guide

This document contains instructions for setting up API keys for the Bazar Se application.

## 📋 Required API Keys

### 1. 🧠 GROQ AI (Main Brain for Mind-Reading)
- **File**: `lib/config/api_keys.dart`
- **Variable**: `groqApiKey`
- **Get Key**: [https://console.groq.com/](https://console.groq.com/)
- **Model**: `llama-3.1-70b-versatile`

### 2. 🗺️ Google Maps & Places API
- **File**: `lib/config/api_keys.dart`
- **Variables**: `googleMapsApiKey`, `googlePlacesApiKey`
- **Get Key**: [https://console.cloud.google.com/](https://console.cloud.google.com/)
- **Required APIs**: Maps SDK, Places API, Geocoding API

### 3. 🎨 Google Gemini AI
- **File**: `lib/config/api_keys.dart`
- **Variable**: `geminiApiKey`
- **Get Key**: [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey)
- **Models**: `gemini-pro`, `gemini-pro-vision`

### 4. 📸 Pexels API (High Quality Images)
- **File**: `lib/config/api_keys.dart`
- **Variable**: `pexelsApiKey`
- **Get Key**: [https://www.pexels.com/api/](https://www.pexels.com/api/)

### 5. 🗣️ Bhashini API (Voice Intelligence)
- **File**: `lib/config/api_keys.dart`
- **Variables**: `bhashiniUdyatKey`, `bhashiniInferenceKey`
- **Get Key**: [https://bhashini.gov.in/](https://bhashini.gov.in/)
- **Purpose**: Hindi/English voice processing

### 6. 🔥 Firebase Configuration
- **File**: `lib/config/api_keys.dart`
- **Variables**: `firebaseApiKey`, `firebaseSenderId`
- **Project ID**: `bazarse-16d2b`
- **Get Key**: [https://console.firebase.google.com/](https://console.firebase.google.com/)

## 🛠️ Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/bazarse/bazarse-2025-07-04.git
   cd bazarse-2025-07-04
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   - Open `lib/config/api_keys.dart`
   - Replace all placeholder values (`YOUR_*_API_KEY_HERE`) with your actual API keys
   - Save the file

4. **Run the application**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 🔒 Security Notes

- **Never commit API keys to version control**
- **Use environment variables in production**
- **Rotate keys regularly**
- **Monitor API usage and billing**

## 📱 Features Enabled by APIs

- **GROQ AI**: Smart intent detection, natural language processing
- **Google Maps**: Location services, nearby stores, navigation
- **Gemini AI**: Image analysis, visual search, content generation
- **Pexels**: High-quality product and store images
- **Bhashini**: Voice commands in Hindi/English, speech-to-text
- **Firebase**: Real-time data, user authentication, cloud storage

## 🚀 Quick Start

For development, you can use the following test keys (limited functionality):

```dart
// Development keys (replace with your own)
static const String groqApiKey = 'gsk_YOUR_GROQ_KEY';
static const String googleMapsApiKey = 'AIzaSy_YOUR_GOOGLE_KEY';
static const String geminiApiKey = 'AIzaSy_YOUR_GEMINI_KEY';
```

## 📞 Support

If you need help setting up API keys:
- Check the official documentation for each service
- Ensure billing is enabled for paid APIs
- Verify API quotas and limits
- Test with simple API calls first

---

**Created**: 2025-07-04  
**Repository**: [bazarse-2025-07-04](https://github.com/bazarse/bazarse-2025-07-04)  
**Project**: Bazar Se - AI-powered hyperlocal marketplace
