import 'dart:convert';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  // Google Maps API Key from your provided key
  static const String _apiKey = 'AIzaSyDexYes91JK03iFpCtLIE65J0FoUEYlFRI';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  // 🔍 SEARCH BUSINESSES USING GOOGLE PLACES API 🔍
  static Future<List<Map<String, dynamic>>> searchBusinesses({
    required String query,
    required String city,
    double? latitude,
    double? longitude,
  }) async {
    try {
      print('🔍 Searching Google Places for: $query in $city');

      // Construct search query
      String searchQuery = '$query $city';
      
      // Use Text Search API for better business results
      final url = Uri.parse(
        '$_baseUrl/textsearch/json?query=$searchQuery&type=establishment&key=$_apiKey'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          List<dynamic> results = data['results'] ?? [];
          
          // Convert to our business format
          List<Map<String, dynamic>> businesses = [];
          
          for (var place in results.take(10)) { // Limit to 10 results
            final business = await _convertPlaceToBusinessFormat(place);
            if (business != null) {
              businesses.add(business);
            }
          }
          
          print('✅ Found ${businesses.length} businesses from Google Places');
          return businesses;
        } else {
          print('❌ Google Places API error: ${data['status']}');
          return _getFallbackResults(query, city);
        }
      } else {
        print('❌ HTTP error: ${response.statusCode}');
        return _getFallbackResults(query, city);
      }
    } catch (e) {
      print('❌ Error searching Google Places: $e');
      return _getFallbackResults(query, city);
    }
  }

  // 🏢 CONVERT GOOGLE PLACE TO BUSINESS FORMAT 🏢
  static Future<Map<String, dynamic>?> _convertPlaceToBusinessFormat(
    Map<String, dynamic> place,
  ) async {
    try {
      // Get place details for more information
      final placeId = place['place_id'];
      final details = await _getPlaceDetails(placeId);
      
      // Determine if business is already claimed (random for demo)
      final isClaimed = _isBusinessClaimed(place['name'] ?? '');
      
      return {
        'place_id': placeId,
        'name': place['name'] ?? 'Unknown Business',
        'category': _extractCategory(place['types'] ?? []),
        'address': place['formatted_address'] ?? 'Address not available',
        'rating': (place['rating'] ?? 0.0).toDouble(),
        'verified': place['business_status'] == 'OPERATIONAL',
        'phone': details['formatted_phone_number'] ?? 'Phone not available',
        'email': _generateBusinessEmail(place['name'] ?? ''),
        'website': details['website'],
        'photos': _extractPhotos(place['photos'] ?? []),
        'opening_hours': details['opening_hours'],
        'price_level': place['price_level'],
        'user_ratings_total': place['user_ratings_total'] ?? 0,
        'geometry': place['geometry'],
        'is_claimed': isClaimed,
        'claimed_by': isClaimed ? _getClaimedByInfo() : null,
        'google_maps_url': details['url'],
      };
    } catch (e) {
      print('Error converting place: $e');
      return null;
    }
  }

  // 📋 GET PLACE DETAILS 📋
  static Future<Map<String, dynamic>> _getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/details/json?place_id=$placeId&fields=formatted_phone_number,website,opening_hours,url&key=$_apiKey'
      );

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['result'] ?? {};
        }
      }
      
      return {};
    } catch (e) {
      print('Error getting place details: $e');
      return {};
    }
  }

  // 🏷️ EXTRACT CATEGORY FROM GOOGLE TYPES 🏷️
  static String _extractCategory(List<dynamic> types) {
    // Map Google Place types to user-friendly categories
    final typeMap = {
      'electronics_store': 'Electronics Store',
      'store': 'Retail Store',
      'restaurant': 'Restaurant',
      'food': 'Food & Dining',
      'clothing_store': 'Clothing Store',
      'grocery_or_supermarket': 'Grocery Store',
      'pharmacy': 'Pharmacy',
      'gas_station': 'Gas Station',
      'bank': 'Bank',
      'atm': 'ATM',
      'hospital': 'Hospital',
      'doctor': 'Medical Services',
      'school': 'Education',
      'gym': 'Fitness & Gym',
      'beauty_salon': 'Beauty Salon',
      'car_repair': 'Auto Services',
      'real_estate_agency': 'Real Estate',
      'lawyer': 'Legal Services',
      'accounting': 'Financial Services',
      'plumber': 'Home Services',
      'electrician': 'Home Services',
    };

    for (String type in types) {
      if (typeMap.containsKey(type)) {
        return typeMap[type]!;
      }
    }

    // Default category based on common types
    if (types.contains('establishment')) {
      return 'Business';
    }
    
    return 'General Business';
  }

  // 📸 EXTRACT PHOTOS 📸
  static List<String> _extractPhotos(List<dynamic> photos) {
    List<String> photoUrls = [];
    
    for (var photo in photos.take(3)) { // Limit to 3 photos
      final photoReference = photo['photo_reference'];
      if (photoReference != null) {
        final photoUrl = '$_baseUrl/photo?maxwidth=400&photo_reference=$photoReference&key=$_apiKey';
        photoUrls.add(photoUrl);
      }
    }
    
    return photoUrls;
  }

  // ✅ CHECK IF BUSINESS IS CLAIMED (DEMO LOGIC) ✅
  static bool _isBusinessClaimed(String businessName) {
    // Demo: Some businesses are randomly marked as claimed
    final claimedBusinesses = [
      'McDonald\'s',
      'Starbucks',
      'Domino\'s Pizza',
      'KFC',
      'Pizza Hut',
      'Subway',
      'Reliance Digital',
      'Big Bazaar',
    ];
    
    return claimedBusinesses.any((claimed) => 
      businessName.toLowerCase().contains(claimed.toLowerCase())
    );
  }

  // 👤 GET CLAIMED BY INFO 👤
  static Map<String, dynamic> _getClaimedByInfo() {
    return {
      'owner_name': 'Business Owner',
      'claimed_date': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
      'verification_status': 'Verified',
    };
  }

  // 📧 GENERATE BUSINESS EMAIL 📧
  static String _generateBusinessEmail(String businessName) {
    final cleanName = businessName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .substring(0, businessName.length > 10 ? 10 : businessName.length);
    
    return '${cleanName}@business.com';
  }

  // 🔄 FALLBACK RESULTS WHEN API FAILS 🔄
  static List<Map<String, dynamic>> _getFallbackResults(String query, String city) {
    return [
      {
        'place_id': 'fallback_1',
        'name': 'Devi Mobile',
        'category': 'Mobile & Electronics',
        'address': 'Freeganj, $city, MP',
        'rating': 4.2,
        'verified': false,
        'phone': '+91 98765 43210',
        'email': 'devi.mobile@gmail.com',
        'is_claimed': false,
        'claimed_by': null,
      },
      {
        'place_id': 'fallback_2',
        'name': 'Sharma Electronics',
        'category': 'Electronics Store',
        'address': 'Main Market, $city, MP',
        'rating': 4.5,
        'verified': true,
        'phone': '+91 98765 43211',
        'email': 'sharma.electronics@gmail.com',
        'is_claimed': true,
        'claimed_by': {
          'owner_name': 'Rajesh Sharma',
          'claimed_date': '2024-01-15T10:30:00Z',
          'verification_status': 'Verified',
        },
      },
      {
        'place_id': 'fallback_3',
        'name': 'Mobile Zone',
        'category': 'Mobile Shop',
        'address': 'Tower Chowk, $city, MP',
        'rating': 4.0,
        'verified': false,
        'phone': '+91 98765 43212',
        'email': 'mobilezone@gmail.com',
        'is_claimed': false,
        'claimed_by': null,
      },
    ];
  }

  // 🌍 NEARBY SEARCH 🌍
  static Future<List<Map<String, dynamic>>> searchNearbyBusinesses({
    required double latitude,
    required double longitude,
    required String type,
    int radius = 5000, // 5km radius
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$type&key=$_apiKey'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          List<dynamic> results = data['results'] ?? [];
          
          List<Map<String, dynamic>> businesses = [];
          
          for (var place in results.take(20)) {
            final business = await _convertPlaceToBusinessFormat(place);
            if (business != null) {
              businesses.add(business);
            }
          }
          
          return businesses;
        }
      }
      
      return [];
    } catch (e) {
      print('Error searching nearby businesses: $e');
      return [];
    }
  }
}
