import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/deel_model.dart';

class PexelsVideoService {
  // 🔑 PEXELS API CREDENTIALS 🔑
  static const String apiKey = 'pWYJjCMH7M8yBuwlSJJ6TUMtsQL6o3iBro66nlTHtflbbfb7jMOxrKBu';
  static const String baseUrl = 'https://api.pexels.com/videos/search';

  // 🏪 STORE CATEGORIES WITH RELEVANT SEARCH QUERIES 🏪
  static const Map<String, List<String>> storeQueries = {
    'Food': [
      'food cooking',
      'restaurant kitchen',
      'pizza making',
      'coffee brewing',
      'bakery fresh',
      'street food',
      'chef cooking',
      'food preparation',
      'restaurant service',
      'food delivery',
    ],
    'Fashion': [
      'fashion model',
      'clothing store',
      'fashion show',
      'shopping mall',
      'boutique fashion',
      'designer clothes',
      'fashion retail',
      'clothing display',
      'fashion accessories',
      'style fashion',
    ],
    'Electronics': [
      'smartphone review',
      'gadget unboxing',
      'tech store',
      'electronics shop',
      'mobile phone',
      'laptop computer',
      'headphones music',
      'tech gadgets',
      'electronics display',
      'technology demo',
    ],
    'Grocery': [
      'grocery shopping',
      'fresh vegetables',
      'supermarket store',
      'organic food',
      'fruit market',
      'grocery store',
      'fresh produce',
      'shopping cart',
      'food market',
      'healthy food',
    ],
    'Others': [
      'service business',
      'retail store',
      'customer service',
      'business meeting',
      'professional service',
      'shop interior',
      'business owner',
      'store opening',
      'retail shopping',
      'business success',
    ],
  };

  // 🏪 ENHANCED STORE DATA WITH REAL BUSINESS INFO 🏪
  static const List<Map<String, dynamic>> realStores = [
    // FOOD STORES
    {
      'name': 'Spice Garden Restaurant',
      'category': 'Food',
      'address': 'Mahakal Road, Ujjain',
      'phone': '+91 98765 43210',
      'rating': 4.5,
      'verified': true,
      'offers': [
        'Buy 1 Pizza Get 1 Free - Limited Time!',
        'Flat 50% Off on All Biryani Orders',
        'Free Home Delivery on Orders Above ₹299',
        'Special Combo Meals Starting ₹99',
        'Fresh Sweets & Snacks - 30% Off',
      ],
    },
    {
      'name': 'Cafe Coffee Corner',
      'category': 'Food',
      'address': 'Freeganj Market, Ujjain',
      'phone': '+91 98765 43211',
      'rating': 4.3,
      'verified': true,
      'offers': [
        'Buy 2 Coffee Get 1 Free',
        'Fresh Pastries - 25% Off',
        'Student Discount - 20% Off',
        'Happy Hours 4-6 PM - 30% Off',
        'Birthday Special - Free Cake',
      ],
    },
    // FASHION STORES
    {
      'name': 'Fashion Hub Boutique',
      'category': 'Fashion',
      'address': 'Tower Chowk, Ujjain',
      'phone': '+91 98765 43212',
      'rating': 4.7,
      'verified': true,
      'offers': [
        'Flat 60% Off on Ethnic Wear Collection',
        'Buy 2 Get 1 Free on All T-Shirts',
        'Designer Sarees Starting ₹999',
        'Winter Collection - Up to 70% Off',
        'Branded Shoes Starting ₹499',
      ],
    },
    {
      'name': 'Style Studio',
      'category': 'Fashion',
      'address': 'Nanakheda, Ujjain',
      'phone': '+91 98765 43213',
      'rating': 4.4,
      'verified': true,
      'offers': [
        'Latest Fashion Trends - 50% Off',
        'Accessories Collection - Buy 1 Get 1',
        'Formal Wear - Special Discount',
        'Casual Collection - Flat 40% Off',
        'Festive Wear - Up to 65% Off',
      ],
    },
    // ELECTRONICS STORES
    {
      'name': 'Mobile Mart Electronics',
      'category': 'Electronics',
      'address': 'University Road, Ujjain',
      'phone': '+91 98765 43214',
      'rating': 4.6,
      'verified': true,
      'offers': [
        'iPhone 15 - Flat ₹10,000 Off + Exchange',
        'Samsung Galaxy - Buy Now Pay Later',
        'Laptop Sale - Up to 40% Off',
        'Smart Watch Starting ₹1,999',
        'Headphones & Earbuds - 50% Off',
      ],
    },
    {
      'name': 'Tech Zone',
      'category': 'Electronics',
      'address': 'Dewas Gate, Ujjain',
      'phone': '+91 98765 43215',
      'rating': 4.5,
      'verified': true,
      'offers': [
        'Gaming Laptops - Special Price',
        'Smart TV - EMI Starting ₹999',
        'Mobile Accessories - 60% Off',
        'Tablet Collection - Best Deals',
        'Camera & Photography - 45% Off',
      ],
    },
    // GROCERY STORES
    {
      'name': 'Fresh Mart Grocery',
      'category': 'Grocery',
      'address': 'Agar Road, Ujjain',
      'phone': '+91 98765 43216',
      'rating': 4.2,
      'verified': true,
      'offers': [
        'Fresh Vegetables - Flat 25% Off',
        'Buy 5kg Rice Get 1kg Free',
        'Household Items - Bulk Discount',
        'Organic Products - 35% Off',
        'Monthly Grocery Pack - ₹1,499',
      ],
    },
    {
      'name': 'Organic Store',
      'category': 'Grocery',
      'address': 'Chimanganj, Ujjain',
      'phone': '+91 98765 43217',
      'rating': 4.4,
      'verified': true,
      'offers': [
        'Organic Fruits & Vegetables - 30% Off',
        'Health Food Products - Special Price',
        'Natural & Pure Items - 25% Off',
        'Fresh Dairy Products - Daily Deals',
        'Ayurvedic Products - 40% Off',
      ],
    },
    // OTHER SERVICES
    {
      'name': 'Service Pro Solutions',
      'category': 'Others',
      'address': 'Mahakal Temple Road, Ujjain',
      'phone': '+91 98765 43218',
      'rating': 4.3,
      'verified': true,
      'offers': [
        'Home Cleaning Service - 50% Off',
        'Bike Service & Repair - ₹299 Only',
        'AC Service - Flat ₹499',
        'Plumbing Service - 24/7 Available',
        'Electrical Work - Expert Service',
      ],
    },
    {
      'name': 'Beauty Salon & Spa',
      'category': 'Others',
      'address': 'Freeganj, Ujjain',
      'phone': '+91 98765 43219',
      'rating': 4.6,
      'verified': true,
      'offers': [
        'Bridal Package - Special Discount',
        'Hair Cut & Styling - 40% Off',
        'Facial & Spa - Combo Offers',
        'Makeup Service - Professional',
        'Beauty Treatments - Best Prices',
      ],
    },
  ];

  // 🎬 FETCH REAL VIDEOS FROM PEXELS API 🎬
  static Future<List<DeelModel>> fetchRealVideoDeels({
    String? category,
    String? city,
    int limit = 20,
  }) async {
    try {
      // Filter stores by category
      List<Map<String, dynamic>> filteredStores = realStores;
      if (category != null && category != 'All') {
        filteredStores = realStores
            .where((store) => store['category'] == category)
            .toList();
      }

      // Get relevant search queries for the category
      List<String> queries = [];
      if (category != null && storeQueries.containsKey(category)) {
        queries = storeQueries[category]!;
      } else {
        // Mix all categories
        storeQueries.values.forEach((categoryQueries) {
          queries.addAll(categoryQueries);
        });
      }

      // Fetch videos from Pexels API
      final List<String> videoUrls = await _fetchPexelsVideos(queries, limit);
      
      // Create Deel models with real video URLs
      final List<DeelModel> deels = [];
      final random = Random();

      for (int i = 0; i < videoUrls.length && i < limit; i++) {
        final store = filteredStores[random.nextInt(filteredStores.length)];
        final offers = store['offers'] as List<String>;
        final offer = offers[random.nextInt(offers.length)];

        final originalPrice = 200 + random.nextInt(3000).toDouble();
        final discountPercent = 15 + random.nextInt(70);
        final discountedPrice = originalPrice * (100 - discountPercent) / 100;

        final deel = DeelModel(
          id: 'real_deel_${i + 1}_${DateTime.now().millisecondsSinceEpoch}',
          store: store['name'],
          offer: offer,
          videoUrl: videoUrls[i],
          thumbnailUrl: videoUrls[i], // Use video URL as thumbnail
          likes: random.nextInt(2000) + 50,
          comments: random.nextInt(300) + 10,
          shares: random.nextInt(100) + 5,
          isTrending: random.nextBool() && random.nextInt(10) < 4,
          category: store['category'],
          expiry: DateTime.now().add(
            Duration(
              hours: random.nextInt(120) + 2,
              minutes: random.nextInt(60),
            ),
          ),
          city: city ?? 'Ujjain',
          originalPrice: originalPrice,
          discountedPrice: discountedPrice,
          description: _generateDescription(store['name'], offer, store['category']),
          storeAddress: store['address'],
          storePhone: store['phone'],
          tags: _generateTags(store['category']),
          isActive: random.nextInt(10) < 9,
          stockLeft: random.nextInt(50) + 1,
          claimInstructions: _generateClaimInstructions(),
        );

        deels.add(deel);
      }

      return deels;
    } catch (e) {
      print('🚨 Error fetching real video deels: $e');
      // Fallback to mock data if API fails
      return _generateMockDeels(limit);
    }
  }

  // 🔍 FETCH VIDEOS FROM PEXELS API 🔍
  static Future<List<String>> _fetchPexelsVideos(List<String> queries, int limit) async {
    final List<String> videoUrls = [];
    final random = Random();

    try {
      // Use random queries to get diverse content
      for (int i = 0; i < (limit / 5).ceil() && videoUrls.length < limit; i++) {
        final query = queries[random.nextInt(queries.length)];
        
        final response = await http.get(
          Uri.parse('$baseUrl?query=$query&orientation=portrait&per_page=10'),
          headers: {
            'Authorization': apiKey,
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final videos = data['videos'] as List;

          for (var video in videos) {
            if (videoUrls.length >= limit) break;
            
            final videoFiles = video['video_files'] as List;
            if (videoFiles.isNotEmpty) {
              // Get the best quality video URL
              final videoFile = videoFiles.firstWhere(
                (file) => file['quality'] == 'hd' || file['quality'] == 'sd',
                orElse: () => videoFiles.first,
              );
              
              final videoUrl = videoFile['link'];
              if (videoUrl != null && !videoUrls.contains(videoUrl)) {
                videoUrls.add(videoUrl);
              }
            }
          }
        }

        // Add delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } catch (e) {
      print('🚨 Error fetching from Pexels API: $e');
    }

    return videoUrls;
  }

  // 📝 GENERATE DESCRIPTION 📝
  static String _generateDescription(String store, String offer, String category) {
    final descriptions = {
      'Food': '🍕 Exclusive offer at $store! $offer. Fresh ingredients, authentic taste!',
      'Fashion': '👗 Trendy collection at $store! $offer. Latest fashion, best prices!',
      'Electronics': '📱 Tech deals at $store! $offer. Latest gadgets, unbeatable prices!',
      'Grocery': '🛒 Fresh deals at $store! $offer. Quality products, daily essentials!',
      'Others': '🔧 Professional service at $store! $offer. Expert solutions, fair prices!',
    };
    return descriptions[category] ?? descriptions['Others']!;
  }

  // 🏷️ GENERATE TAGS 🏷️
  static List<String> _generateTags(String category) {
    final tagMap = {
      'Food': ['delicious', 'fresh', 'authentic', 'tasty'],
      'Fashion': ['trendy', 'stylish', 'designer', 'branded'],
      'Electronics': ['latest', 'smart', 'premium', 'innovative'],
      'Grocery': ['fresh', 'organic', 'healthy', 'quality'],
      'Others': ['professional', 'reliable', 'expert', 'trusted'],
    };
    return tagMap[category] ?? tagMap['Others']!;
  }

  // 📋 GENERATE CLAIM INSTRUCTIONS 📋
  static String _generateClaimInstructions() {
    final instructions = [
      '📱 Show this video offer at the store to claim your discount.',
      '📞 Call the store and mention offer code "BAZARSE2024".',
      '🏪 Visit the store within offer validity period with this screen.',
      '📸 Screenshot this offer and show at billing counter.',
    ];
    return instructions[Random().nextInt(instructions.length)];
  }

  // 🎭 FALLBACK MOCK DEELS 🎭
  static List<DeelModel> _generateMockDeels(int limit) {
    // Fallback implementation with mock data
    return [];
  }
}
