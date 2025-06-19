import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_service.dart';

// 🔐 FIREBASE AUTH SERVICE - VINU BHAISAHAB KA SECURE LOGIN 🔐
class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseService.auth;
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // 📱 SIGN IN WITH PHONE 📱
  static Future<bool> signInWithPhone({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      print('📱 Sending OTP to: $phoneNumber');
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('❌ Phone verification failed: ${e.message}');
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('✅ OTP sent successfully');
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏰ Auto-retrieval timeout');
        },
        timeout: const Duration(seconds: 60),
      );
      
      return true;
    } catch (e) {
      print('❌ Phone sign-in error: $e');
      onError(e.toString());
      return false;
    }
  }

  // ✅ VERIFY OTP ✅
  static Future<User?> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      print('🔐 Verifying OTP: $otp');
      
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      
      return await _signInWithCredential(credential);
    } catch (e) {
      print('❌ OTP verification error: $e');
      return null;
    }
  }

  // 🔑 SIGN IN WITH CREDENTIAL 🔑
  static Future<User?> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      
      if (user != null) {
        print('✅ User signed in: ${user.phoneNumber}');
        
        // Save user data to Firestore
        await _saveUserToFirestore(user);
        
        // Log analytics event
        await FirebaseService.logEvent('user_login', {
          'method': 'phone',
          'phone_number': user.phoneNumber ?? '',
        });
        
        return user;
      }
      
      return null;
    } catch (e) {
      print('❌ Credential sign-in error: $e');
      await FirebaseService.logError(e, StackTrace.current);
      return null;
    }
  }

  // 💾 SAVE USER TO FIRESTORE 💾
  static Future<void> _saveUserToFirestore(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'appVersion': '1.0.0',
        'platform': 'flutter',
      }, SetOptions(merge: true));
      
      print('✅ User data saved to Firestore');
    } catch (e) {
      print('❌ Firestore save error: $e');
    }
  }

  // 👤 GET USER PROFILE 👤
  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      
      return null;
    } catch (e) {
      print('❌ Get user profile error: $e');
      return null;
    }
  }

  // 📝 UPDATE USER PROFILE 📝
  static Future<bool> updateUserProfile({
    required String uid,
    String? name,
    String? email,
    String? address,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (address != null) updateData['address'] = address;
      if (additionalData != null) updateData.addAll(additionalData);
      
      await _firestore.collection('users').doc(uid).update(updateData);
      
      print('✅ User profile updated');
      return true;
    } catch (e) {
      print('❌ Update profile error: $e');
      return false;
    }
  }

  // 🚪 SIGN OUT 🚪
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('✅ User signed out');
      
      // Log analytics event
      await FirebaseService.logEvent('user_logout', {});
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }

  // 🗑️ DELETE ACCOUNT 🗑️
  static Future<bool> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        
        // Delete user account
        await user.delete();
        
        print('✅ Account deleted');
        return true;
      }
      
      return false;
    } catch (e) {
      print('❌ Delete account error: $e');
      return false;
    }
  }

  // 📊 GET USER STREAM 📊
  static Stream<User?> get userStream => _auth.authStateChanges();
}
