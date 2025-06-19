import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

// 🔥 FIREBASE SERVICE - VINU BHAISAHAB KA POWERFUL BACKEND 🔥
class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;
  static FirebaseMessaging get messaging => FirebaseMessaging.instance;
  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  // 🚀 INITIALIZE FIREBASE 🚀
  static Future<void> initialize() async {
    try {
      print('🔥 Initializing Firebase...');

      await Firebase.initializeApp(options: _getFirebaseOptions());

      // Setup Crashlytics
      if (!kDebugMode) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      // Setup FCM
      await _setupFCM();

      print('✅ Firebase initialized successfully!');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
      rethrow;
    }
  }

  // 🔧 GET FIREBASE OPTIONS 🔧
  static FirebaseOptions _getFirebaseOptions() {
    if (kIsWeb) {
      // Web configuration
      return const FirebaseOptions(
        apiKey: 'AIzaSyAijk63zfJP7Js9QOn4tpp3dXMnXkZUOD0',
        appId: '1:1089855615062:web:05f0b670545d6700a8cbf7',
        messagingSenderId: '1089855615062',
        projectId: 'bazarse-8c768',
        storageBucket: 'bazarse-8c768.firebasestorage.app',
        authDomain: 'bazarse-8c768.firebaseapp.com',
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyAijk63zfJP7Js9QOn4tpp3dXMnXkZUOD0',
        appId: '1:1089855615062:android:05f0b670545d6700a8cbf7',
        messagingSenderId: '1089855615062',
        projectId: 'bazarse-8c768',
        storageBucket: 'bazarse-8c768.firebasestorage.app',
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDakMRkxhzj6fm0tVf93AqfvAA0FkDyyKY',
        appId: '1:1089855615062:ios:9a050cbcee24a6a7a8cbf7',
        messagingSenderId: '1089855615062',
        projectId: 'bazarse-8c768',
        storageBucket: 'bazarse-8c768.firebasestorage.app',
        iosBundleId: 'bazarseuserapple',
      );
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  // 📱 SETUP FCM 📱
  static Future<void> _setupFCM() async {
    try {
      // Request permission for notifications
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ FCM permission granted');

        // Get FCM token
        String? token = await messaging.getToken();
        print('📱 FCM Token: $token');

        // Listen to token refresh
        messaging.onTokenRefresh.listen((newToken) {
          print('🔄 FCM Token refreshed: $newToken');
          // TODO: Send token to server
        });
      } else {
        print('❌ FCM permission denied');
      }
    } catch (e) {
      print('❌ FCM setup failed: $e');
    }
  }

  // 👤 CURRENT USER 👤
  static User? get currentUser => auth.currentUser;
  static bool get isLoggedIn => currentUser != null;

  // 📊 LOG EVENT 📊
  static Future<void> logEvent(
    String name,
    Map<String, Object>? parameters,
  ) async {
    try {
      await analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('❌ Analytics event failed: $e');
    }
  }

  // 🚨 LOG ERROR 🚨
  static Future<void> logError(dynamic error, StackTrace? stackTrace) async {
    try {
      await crashlytics.recordError(error, stackTrace);
    } catch (e) {
      print('❌ Crashlytics error failed: $e');
    }
  }
}
