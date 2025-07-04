// 🚀 REVOLUTIONARY AI BAZAR - COMPLETE API CONFIGURATION 🧠
// Mind-Reading AI Assistant with ALL APIs Ready!

class ApiKeys {
  // 🧠 GROQ AI - Main Brain for Mind-Reading
  static const String groqApiKey = 'YOUR_GROQ_API_KEY_HERE';
  static const String groqModel = 'llama-3.1-70b-versatile';
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';

  // 🗺️ GOOGLE MAPS & PLACES - Location Intelligence
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  static const String googlePlacesApiKey = 'YOUR_GOOGLE_PLACES_API_KEY_HERE';

  // 🎨 GOOGLE GEMINI - Image Generation & Visual AI
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  static const String geminiModel = 'gemini-pro';
  static const String geminiVisionModel = 'gemini-pro-vision';

  // 📸 PEXELS - High Quality Images
  static const String pexelsApiKey = 'YOUR_PEXELS_API_KEY_HERE';
  static const String pexelsBaseUrl = 'https://api.pexels.com/v1';

  // 🗣️ BHASHINI - Voice Intelligence (Hindi/English)
  static const String bhashiniUdyatKey = 'YOUR_BHASHINI_UDYAT_KEY_HERE';
  static const String bhashiniInferenceKey = 'YOUR_BHASHINI_INFERENCE_KEY_HERE';
  static const String bhashiniBaseUrl = 'https://meity-auth.ulcacontrib.org';

  // 🔥 FIREBASE - Real-time Database & Auth
  static const String firebaseProjectId = 'bazarse-16d2b';
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY_HERE';
  static const String firebaseSenderId = 'YOUR_FIREBASE_SENDER_ID_HERE';

  // 🌤️ WEATHER - Context Awareness
  static const String weatherApiKey = googleMapsApiKey; // Using Google Maps for weather

  // Environment check
  static bool get isProduction => false;

  // 🎯 Smart API Getters
  static String get currentGoogleMapsKey => googleMapsApiKey;
  static String get currentGroqKey => groqApiKey;
  static String get currentGeminiKey => geminiApiKey;
  static String get currentPexelsKey => pexelsApiKey;
}
