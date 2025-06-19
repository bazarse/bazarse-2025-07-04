import 'dart:convert';
import 'package:http/http.dart' as http;

// 🎨 PEXELS SERVICE FOR BANNER IMAGES - VINU BHAISAHAB KA IMAGE API 🎨
class PexelsService {
  static const String _apiKey = 'pWYJjCMH7M8yBuwlSJJ6TUMtsQL6o3iBro66nlTHtflbbfb7jMOxrKBu';
  static const String _baseUrl = 'https://api.pexels.com/v1';

  // 🎯 GET BANNER IMAGES 🎯
  static Future<List<String>> getBannerImages() async {
    try {
      final queries = [
        'shopping mall',
        'retail store',
        'marketplace',
        'shopping center',
        'commercial',
        'business',
        'sale offers',
        'discount shopping'
      ];

      List<String> bannerImages = [];

      for (String query in queries.take(4)) {
        final response = await http.get(
          Uri.parse('$_baseUrl/search?query=$query&per_page=2&orientation=landscape'),
          headers: {
            'Authorization': _apiKey,
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final photos = data['photos'] as List;
          
          for (var photo in photos) {
            bannerImages.add(photo['src']['large']);
          }
        }
      }

      // Fallback images if API fails
      if (bannerImages.isEmpty) {
        bannerImages = [
          'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=800',
          'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800',
          'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=800',
          'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=800',
        ];
      }

      return bannerImages;
    } catch (e) {
      print('❌ Error fetching banner images: $e');
      // Return fallback images
      return [
        'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=800',
        'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=800',
      ];
    }
  }

  // 🏪 GET CATEGORY IMAGES 🏪
  static Future<String> getCategoryImage(String category) async {
    try {
      String query = _getCategoryQuery(category);
      
      final response = await http.get(
        Uri.parse('$_baseUrl/search?query=$query&per_page=1&orientation=square'),
        headers: {
          'Authorization': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final photos = data['photos'] as List;
        
        if (photos.isNotEmpty) {
          return photos[0]['src']['medium'];
        }
      }

      return _getFallbackImage(category);
    } catch (e) {
      print('❌ Error fetching category image: $e');
      return _getFallbackImage(category);
    }
  }

  // 🏬 GET STORE IMAGES 🏬
  static Future<String> getStoreImage(String storeName, String category) async {
    try {
      String query = _getStoreQuery(storeName, category);
      
      final response = await http.get(
        Uri.parse('$_baseUrl/search?query=$query&per_page=1&orientation=landscape'),
        headers: {
          'Authorization': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final photos = data['photos'] as List;
        
        if (photos.isNotEmpty) {
          return photos[0]['src']['medium'];
        }
      }

      return _getFallbackStoreImage(category);
    } catch (e) {
      print('❌ Error fetching store image: $e');
      return _getFallbackStoreImage(category);
    }
  }

  // 🔍 GET CATEGORY QUERY 🔍
  static String _getCategoryQuery(String category) {
    Map<String, String> categoryQueries = {
      'Food & Dining': 'restaurant food',
      'Grocery & Daily': 'grocery store',
      'Fashion & Retail': 'fashion clothing',
      'Electronics & Tech': 'electronics technology',
      'Health & Medical': 'medical healthcare',
      'Beauty & Care': 'beauty salon',
      'Education & Training': 'education books',
      'Home & Living': 'home furniture',
      'Services & Repair': 'repair service',
      'Business & Professional': 'business office',
      'Events & Entertainment': 'event party',
      'Construction & Hardware': 'construction tools',
      'Transport & Logistics': 'transport vehicle',
      'Religious & Cultural': 'temple religious',
      'Gifts & Miscellaneous': 'gift shop',
    };

    return categoryQueries[category] ?? 'business store';
  }

  // 🏪 GET STORE QUERY 🏪
  static String _getStoreQuery(String storeName, String category) {
    if (storeName.toLowerCase().contains('restaurant') || 
        storeName.toLowerCase().contains('food')) {
      return 'restaurant interior';
    } else if (storeName.toLowerCase().contains('medical') || 
               storeName.toLowerCase().contains('hospital')) {
      return 'medical clinic';
    } else if (storeName.toLowerCase().contains('electronics') || 
               storeName.toLowerCase().contains('mobile')) {
      return 'electronics store';
    } else if (storeName.toLowerCase().contains('fashion') || 
               storeName.toLowerCase().contains('clothing')) {
      return 'clothing store';
    } else {
      return _getCategoryQuery(category);
    }
  }

  // 🎯 GET FALLBACK IMAGE 🎯
  static String _getFallbackImage(String category) {
    Map<String, String> fallbackImages = {
      'Food & Dining': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
      'Grocery & Daily': 'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=400',
      'Fashion & Retail': 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=400',
      'Electronics & Tech': 'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=400',
      'Health & Medical': 'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&w=400',
      'Beauty & Care': 'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg?auto=compress&cs=tinysrgb&w=400',
    };

    return fallbackImages[category] ?? 'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=400';
  }

  // 🏬 GET FALLBACK STORE IMAGE 🏬
  static String _getFallbackStoreImage(String category) {
    return _getFallbackImage(category);
  }

  // 🎨 GET OFFER CARD IMAGES 🎨
  static Future<List<String>> getOfferImages(String category) async {
    try {
      String query = _getCategoryQuery(category);
      
      final response = await http.get(
        Uri.parse('$_baseUrl/search?query=$query&per_page=10&orientation=landscape'),
        headers: {
          'Authorization': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final photos = data['photos'] as List;
        
        return photos.map<String>((photo) => photo['src']['medium'] as String).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error fetching offer images: $e');
      return [];
    }
  }
}
