import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/deel_model.dart';
import 'firebase_service.dart';

// 🔥 FIREBASE DEELS SERVICE - VINU BHAISAHAB KA CLOUD DATABASE 🔥
class FirebaseDeelsService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // 📱 GET DEELS FROM FIREBASE 📱
  static Future<List<DeelModel>> getDeels({
    String? city,
    String? category,
    int limit = 20,
  }) async {
    try {
      print('🔍 Fetching deels from Firebase...');
      
      Query query = _firestore.collection('deels');
      
      // Filter by city
      if (city != null && city.isNotEmpty && city != 'All') {
        query = query.where('city', isEqualTo: city);
      }
      
      // Filter by category
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      
      // Order by created date and limit
      query = query.orderBy('createdAt', descending: true).limit(limit);
      
      QuerySnapshot snapshot = await query.get();
      
      List<DeelModel> deels = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID
        return DeelModel.fromFirestore(data);
      }).toList();
      
      print('✅ Fetched ${deels.length} deels from Firebase');
      return deels;
    } catch (e) {
      print('❌ Error fetching deels: $e');
      await FirebaseService.logError(e, StackTrace.current);
      return [];
    }
  }

  // 💾 SAVE DEEL TO FIREBASE 💾
  static Future<String?> saveDeel(DeelModel deel) async {
    try {
      print('💾 Saving deel to Firebase...');
      
      DocumentReference docRef = await _firestore.collection('deels').add({
        'store': deel.store,
        'offer': deel.offer,
        'originalPrice': deel.originalPrice,
        'discountedPrice': deel.discountedPrice,
        'discountPercentage': deel.discountPercentage,
        'category': deel.category,
        'city': deel.city,
        'address': deel.address,
        'phone': deel.phone,
        'videoUrl': deel.videoUrl,
        'imageUrl': deel.imageUrl,
        'likes': deel.likes,
        'views': deel.views,
        'shares': deel.shares,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      print('✅ Deel saved with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error saving deel: $e');
      await FirebaseService.logError(e, StackTrace.current);
      return null;
    }
  }

  // 📝 UPDATE DEEL 📝
  static Future<bool> updateDeel(String deelId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('deels').doc(deelId).update(updates);
      
      print('✅ Deel updated: $deelId');
      return true;
    } catch (e) {
      print('❌ Error updating deel: $e');
      return false;
    }
  }

  // ❤️ LIKE DEEL ❤️
  static Future<bool> likeDeel(String deelId) async {
    try {
      await _firestore.collection('deels').doc(deelId).update({
        'likes': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Log analytics event
      await FirebaseService.logEvent('deel_liked', {
        'deel_id': deelId,
      });
      
      return true;
    } catch (e) {
      print('❌ Error liking deel: $e');
      return false;
    }
  }

  // 👁️ INCREMENT VIEWS 👁️
  static Future<bool> incrementViews(String deelId) async {
    try {
      await _firestore.collection('deels').doc(deelId).update({
        'views': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      print('❌ Error incrementing views: $e');
      return false;
    }
  }

  // 🔁 SHARE DEEL 🔁
  static Future<bool> shareDeel(String deelId) async {
    try {
      await _firestore.collection('deels').doc(deelId).update({
        'shares': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Log analytics event
      await FirebaseService.logEvent('deel_shared', {
        'deel_id': deelId,
      });
      
      return true;
    } catch (e) {
      print('❌ Error sharing deel: $e');
      return false;
    }
  }

  // 🗑️ DELETE DEEL 🗑️
  static Future<bool> deleteDeel(String deelId) async {
    try {
      await _firestore.collection('deels').doc(deelId).delete();
      
      print('✅ Deel deleted: $deelId');
      return true;
    } catch (e) {
      print('❌ Error deleting deel: $e');
      return false;
    }
  }

  // 📊 GET DEEL ANALYTICS 📊
  static Future<Map<String, dynamic>?> getDeelAnalytics(String deelId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('deels').doc(deelId).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'likes': data['likes'] ?? 0,
          'views': data['views'] ?? 0,
          'shares': data['shares'] ?? 0,
          'createdAt': data['createdAt'],
          'updatedAt': data['updatedAt'],
        };
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting deel analytics: $e');
      return null;
    }
  }

  // 🔍 SEARCH DEELS 🔍
  static Future<List<DeelModel>> searchDeels(String query) async {
    try {
      print('🔍 Searching deels: $query');
      
      // Search in store names and offers
      QuerySnapshot storeSnapshot = await _firestore
          .collection('deels')
          .where('store', isGreaterThanOrEqualTo: query)
          .where('store', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();
      
      QuerySnapshot offerSnapshot = await _firestore
          .collection('deels')
          .where('offer', isGreaterThanOrEqualTo: query)
          .where('offer', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();
      
      Set<String> seenIds = {};
      List<DeelModel> results = [];
      
      // Add store results
      for (var doc in storeSnapshot.docs) {
        if (!seenIds.contains(doc.id)) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          results.add(DeelModel.fromFirestore(data));
          seenIds.add(doc.id);
        }
      }
      
      // Add offer results
      for (var doc in offerSnapshot.docs) {
        if (!seenIds.contains(doc.id)) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          results.add(DeelModel.fromFirestore(data));
          seenIds.add(doc.id);
        }
      }
      
      print('✅ Found ${results.length} search results');
      return results;
    } catch (e) {
      print('❌ Error searching deels: $e');
      return [];
    }
  }

  // 📊 GET DEELS STREAM 📊
  static Stream<List<DeelModel>> getDeelsStream({
    String? city,
    String? category,
    int limit = 20,
  }) {
    Query query = _firestore.collection('deels');
    
    // Filter by city
    if (city != null && city.isNotEmpty && city != 'All') {
      query = query.where('city', isEqualTo: city);
    }
    
    // Filter by category
    if (category != null && category.isNotEmpty && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    
    // Order by created date and limit
    query = query.orderBy('createdAt', descending: true).limit(limit);
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return DeelModel.fromFirestore(data);
      }).toList();
    });
  }
}
