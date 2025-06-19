import 'dart:convert';
import 'dart:math';
import '../models/deel_model.dart';

class DeelsApiService {
  // 🔥 MOCK API - REPLACE WITH REAL API LATER 🔥
  static const String baseUrl = 'https://mocki.io/v1/1a149eeb-2a1c-45bb-97fd-3e0c39047492';
  
  // 🎥 SAMPLE VIDEO URLS 🎥
  static const List<String> sampleVideos = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
  ];

  // 🏪 SAMPLE STORES 🏪
  static const List<Map<String, dynamic>> sampleStores = [
    {
      'name': 'Mobile Mart',
      'category': 'Electronics',
      'address': 'Freeganj, Ujjain',
      'phone': '+91 98765 43210',
    },
    {
      'name': 'Fashion Hub',
      'category': 'Fashion',
      'address': 'Mahakal Road, Ujjain',
      'phone': '+91 98765 43211',
    },
    {
      'name': 'Food Paradise',
      'category': 'Food',
      'address': 'Tower Chowk, Ujjain',
      'phone': '+91 98765 43212',
    },
    {
      'name': 'Grocery King',
      'category': 'Grocery',
      'address': 'Nanakheda, Ujjain',
      'phone': '+91 98765 43213',
    },
    {
      'name': 'Tech Zone',
      'category': 'Electronics',
      'address': 'University Road, Ujjain',
      'phone': '+91 98765 43214',
    },
    {
      'name': 'Style Studio',
      'category': 'Fashion',
      'address': 'Dewas Gate, Ujjain',
      'phone': '+91 98765 43215',
    },
    {
      'name': 'Spice Garden',
      'category': 'Food',
      'address': 'Agar Road, Ujjain',
      'phone': '+91 98765 43216',
    },
    {
      'name': 'Fresh Mart',
      'category': 'Grocery',
      'address': 'Chimanganj, Ujjain',
      'phone': '+91 98765 43217',
    },
  ];

  // 🎯 SAMPLE OFFERS BY CATEGORY 🎯
  static const Map<String, List<String>> sampleOffers = {
    'Electronics': [
      'Flat ₹1000 Off on iPhones',
      '50% Off on Headphones',
      'Buy 1 Get 1 Free on Chargers',
      'Laptop Sale - Up to 30% Off',
      'Smart Watch Starting ₹999',
    ],
    'Fashion': [
      'Flat 60% Off on Ethnic Wear',
      'Buy 2 Get 1 Free on T-Shirts',
      'Shoes Starting ₹299',
      'Saree Collection - 40% Off',
      'Winter Jackets - 50% Off',
    ],
    'Food': [
      'Free Delivery on Orders Above ₹199',
      'Buy 1 Pizza Get 1 Free',
      'Combo Meals Starting ₹99',
      'Fresh Sweets - 25% Off',
      'Biryani Festival - Special Prices',
    ],
    'Grocery': [
      'Fresh Vegetables - 20% Off',
      'Buy 2kg Rice Get 1kg Free',
      'Household Items - Flat 15% Off',
      'Organic Products - 30% Off',
      'Monthly Grocery Pack - ₹999',
    ],
    'Others': [
      'Home Cleaning Service - 40% Off',
      'Bike Service - ₹199 Only',
      'Gym Membership - 3 Months Free',
      'Tuition Classes - 50% Off',
      'Beauty Parlour - Special Packages',
    ],
  };

  // 🔥 GET DEELS 🔥
  static Future<List<DeelModel>> getDeels({
    String? city,
    String? category,
    int limit = 20,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final random = Random();
    final List<DeelModel> deels = [];
    
    // Filter stores by category if specified
    List<Map<String, dynamic>> filteredStores = sampleStores;
    if (category != null && category != 'All') {
      filteredStores = sampleStores.where((store) => store['category'] == category).toList();
    }
    
    // Generate mock deels
    for (int i = 0; i < limit; i++) {
      final store = filteredStores[random.nextInt(filteredStores.length)];
      final storeCategory = store['category'];
      final offers = sampleOffers[storeCategory] ?? sampleOffers['Others']!;
      
      final originalPrice = 100 + random.nextInt(2000).toDouble();
      final discountPercent = 10 + random.nextInt(60);
      final discountedPrice = originalPrice * (100 - discountPercent) / 100;
      
      final deel = DeelModel(
        id: 'deel_${i + 1}_${DateTime.now().millisecondsSinceEpoch}',
        store: store['name'],
        offer: offers[random.nextInt(offers.length)],
        videoUrl: sampleVideos[random.nextInt(sampleVideos.length)],
        thumbnailUrl: 'https://picsum.photos/400/600?random=${i + 1}',
        likes: random.nextInt(500) + 10,
        comments: random.nextInt(100) + 5,
        shares: random.nextInt(50) + 2,
        isTrending: random.nextBool() && random.nextInt(10) < 3, // 30% chance
        category: storeCategory,
        expiry: DateTime.now().add(Duration(
          hours: random.nextInt(72) + 1, // 1-72 hours
          minutes: random.nextInt(60),
        )),
        city: city ?? 'Ujjain',
        originalPrice: originalPrice,
        discountedPrice: discountedPrice,
        description: _generateDescription(store['name'], offers[random.nextInt(offers.length)]),
        storeAddress: store['address'],
        storePhone: store['phone'],
        tags: _generateTags(storeCategory),
        isActive: random.nextInt(10) < 9, // 90% active
        stockLeft: random.nextInt(20) + 1,
        claimInstructions: _generateClaimInstructions(),
      );
      
      deels.add(deel);
    }
    
    // Sort by trending first, then by engagement
    deels.sort((a, b) {
      if (a.isTrending && !b.isTrending) return -1;
      if (!a.isTrending && b.isTrending) return 1;
      return b.engagementScore.compareTo(a.engagementScore);
    });
    
    return deels;
  }

  // 🏷️ GET CATEGORIES 🏷️
  static List<String> getCategories() {
    return ['All', 'Electronics', 'Fashion', 'Food', 'Grocery', 'Others'];
  }

  // 📍 GET CITIES 📍
  static List<String> getCities() {
    return ['Ujjain', 'Indore', 'Bhopal', 'Jabalpur', 'Gwalior', 'Dewas'];
  }

  // 📝 GENERATE DESCRIPTION 📝
  static String _generateDescription(String store, String offer) {
    final descriptions = [
      'Limited time offer at $store! $offer. Hurry up, stock is limited!',
      'Exclusive deal from $store. $offer. Don\'t miss this amazing opportunity!',
      'Special promotion at $store: $offer. Valid for limited time only!',
      'Hot deal alert! $store brings you $offer. Grab it before it\'s gone!',
      'Amazing offer from $store! $offer. Perfect time to save big!',
    ];
    return descriptions[Random().nextInt(descriptions.length)];
  }

  // 🏷️ GENERATE TAGS 🏷️
  static List<String> _generateTags(String category) {
    final tagMap = {
      'Electronics': ['tech', 'gadgets', 'mobile', 'laptop', 'accessories'],
      'Fashion': ['style', 'trendy', 'clothing', 'shoes', 'accessories'],
      'Food': ['delicious', 'fresh', 'tasty', 'homemade', 'spicy'],
      'Grocery': ['fresh', 'organic', 'daily needs', 'household', 'quality'],
      'Others': ['service', 'quality', 'professional', 'reliable', 'affordable'],
    };
    
    final tags = tagMap[category] ?? tagMap['Others']!;
    final selectedTags = <String>[];
    final random = Random();
    
    // Select 2-4 random tags
    final count = 2 + random.nextInt(3);
    for (int i = 0; i < count; i++) {
      final tag = tags[random.nextInt(tags.length)];
      if (!selectedTags.contains(tag)) {
        selectedTags.add(tag);
      }
    }
    
    return selectedTags;
  }

  // 📋 GENERATE CLAIM INSTRUCTIONS 📋
  static String _generateClaimInstructions() {
    final instructions = [
      'Show this offer at the store to claim your discount.',
      'Call the store and mention this deal to get the offer.',
      'Visit the store within the offer validity period.',
      'Screenshot this offer and show at billing counter.',
      'Mention offer code "BAZARSE" while placing order.',
    ];
    return instructions[Random().nextInt(instructions.length)];
  }

  // ❤️ LIKE DEEL ❤️
  static Future<bool> likeDeel(String deelId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual API call
    return true;
  }

  // 💬 ADD COMMENT 💬
  static Future<bool> addComment(String deelId, String comment) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: Implement actual API call
    return true;
  }

  // 🔁 SHARE DEEL 🔁
  static Future<bool> shareDeel(String deelId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Implement actual API call
    return true;
  }

  // ✅ CLAIM OFFER ✅
  static Future<Map<String, dynamic>> claimOffer(String deelId) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // TODO: Implement actual API call
    return {
      'success': true,
      'message': 'Offer claimed successfully!',
      'claimCode': 'BZ${Random().nextInt(999999).toString().padLeft(6, '0')}',
    };
  }
}
