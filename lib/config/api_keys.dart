// Vinu Bhaisahab's API Keys Configuration 🔑
// Outstanding API keys for Bazar Se app

class ApiKeys {
  // Google Maps & Places API Key - For location services
  static const String googleMapsApiKey = 'AIzaSyDexYes91JK03iFpCtLIE65J0FoUEYlFRI';
  
  // Future API keys can be added here
  // static const String firebaseApiKey = 'your_firebase_key';
  // static const String razorpayApiKey = 'your_razorpay_key';
  
  // Environment check
  static bool get isProduction => false; // Set to true for production
  
  // Get API key based on environment
  static String get currentGoogleMapsKey {
    return isProduction ? googleMapsApiKey : googleMapsApiKey;
  }
}
