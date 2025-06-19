import 'dart:convert';
import 'dart:math';
import '../models/deel_model.dart';

class EnhancedDeelsApiService {
  // 🔥 REAL YOUTUBE VIDEOS & LIVE STREAMS 🔥
  static const List<Map<String, dynamic>> realVideoData = [
    // FOOD CATEGORY
    {
      'category': 'Food',
      'videoUrl': 'https://youtu.be/dQw4w9WgXcQ',
      'thumbnailUrl': 'https://picsum.photos/400/600?random=101',
      'liveUrl': 'https://youtu.be/jfKfPfyJRdk',
      'stores': [
        'Spice Garden',
        'Food Paradise',
        'Tasty Bites',
        'Royal Kitchen',
        'Street Food Hub',
      ],
      'offers': [
        'Buy 1 Pizza Get 1 Free - Limited Time!',
        'Flat 50% Off on All Biryani Orders',
        'Free Home Delivery on Orders Above ₹299',
        'Special Combo Meals Starting ₹99',
        'Fresh Sweets & Snacks - 30% Off',
      ],
    },
    // FASHION CATEGORY
    {
      'category': 'Fashion',
      'videoUrl': 'https://youtu.be/9bZkp7q19f0',
      'thumbnailUrl': 'https://picsum.photos/400/600?random=102',
      'liveUrl': 'https://youtu.be/5qap5aO4i9A',
      'stores': [
        'Fashion Hub',
        'Style Studio',
        'Trendy Wear',
        'Elite Fashion',
        'Urban Style',
      ],
      'offers': [
        'Flat 60% Off on Ethnic Wear Collection',
        'Buy 2 Get 1 Free on All T-Shirts',
        'Designer Sarees Starting ₹999',
        'Winter Collection - Up to 70% Off',
        'Branded Shoes Starting ₹499',
      ],
    },
    // ELECTRONICS CATEGORY
    {
      'category': 'Electronics',
      'videoUrl': 'https://youtu.be/kJQP7kiw5Fk',
      'thumbnailUrl': 'https://picsum.photos/400/600?random=103',
      'liveUrl': 'https://youtu.be/hFZFjoX2cGg',
      'stores': [
        'Mobile Mart',
        'Tech Zone',
        'Gadget World',
        'Digital Store',
        'Smart Electronics',
      ],
      'offers': [
        'iPhone 15 - Flat ₹10,000 Off + Exchange',
        'Samsung Galaxy - Buy Now Pay Later',
        'Laptop Sale - Up to 40% Off',
        'Smart Watch Starting ₹1,999',
        'Headphones & Earbuds - 50% Off',
      ],
    },
    // GROCERY CATEGORY
    {
      'category': 'Grocery',
      'videoUrl': 'https://youtu.be/ZZ5LpwO-An4',
      'thumbnailUrl': 'https://picsum.photos/400/600?random=104',
      'liveUrl': 'https://youtu.be/sTSA_sWGM44',
      'stores': [
        'Fresh Mart',
        'Grocery King',
        'Daily Needs',
        'Organic Store',
        'Super Market',
      ],
      'offers': [
        'Fresh Vegetables - Flat 25% Off',
        'Buy 5kg Rice Get 1kg Free',
        'Household Items - Bulk Discount',
        'Organic Products - 35% Off',
        'Monthly Grocery Pack - ₹1,499',
      ],
    },
    // OTHERS CATEGORY
    {
      'category': 'Others',
      'videoUrl': 'https://youtu.be/fJ9rUzIMcZQ',
      'thumbnailUrl': 'https://picsum.photos/400/600?random=105',
      'liveUrl': 'https://youtu.be/M7lc1UVf-VE',
      'stores': [
        'Service Pro',
        'Quick Fix',
        'Home Care',
        'Beauty Salon',
        'Fitness Center',
      ],
      'offers': [
        'Home Cleaning Service - 50% Off',
        'Bike Service & Repair - ₹299 Only',
        'Gym Membership - 3 Months Free',
        'Beauty Parlour - Special Packages',
        'AC Service - Flat ₹499',
      ],
    },
  ];

  // 🎯 LIVE STREAMING URLS 🎯
  static const List<String> liveStreamUrls = [
    'https://youtu.be/jfKfPfyJRdk', // lofi hip hop radio
    'https://youtu.be/5qap5aO4i9A', // relaxing music
    'https://youtu.be/hFZFjoX2cGg', // nature sounds
    'https://youtu.be/sTSA_sWGM44', // meditation music
    'https://youtu.be/M7lc1UVf-VE', // jazz music
  ];

  // 🏪 ENHANCED STORE DATA 🏪
  static const List<Map<String, dynamic>> enhancedStores = [
    {
      'name': 'Spice Garden Restaurant',
      'category': 'Food',
      'address': 'Mahakal Road, Ujjain',
      'phone': '+91 98765 43210',
      'rating': 4.5,
      'verified': true,
    },
    {
      'name': 'Fashion Hub Boutique',
      'category': 'Fashion',
      'address': 'Freeganj Market, Ujjain',
      'phone': '+91 98765 43211',
      'rating': 4.3,
      'verified': true,
    },
    {
      'name': 'Mobile Mart Electronics',
      'category': 'Electronics',
      'address': 'Tower Chowk, Ujjain',
      'phone': '+91 98765 43212',
      'rating': 4.7,
      'verified': true,
    },
    {
      'name': 'Fresh Mart Grocery',
      'category': 'Grocery',
      'address': 'Nanakheda, Ujjain',
      'phone': '+91 98765 43213',
      'rating': 4.2,
      'verified': true,
    },
    {
      'name': 'Service Pro Solutions',
      'category': 'Others',
      'address': 'University Road, Ujjain',
      'phone': '+91 98765 43214',
      'rating': 4.4,
      'verified': true,
    },
  ];

  // 🔥 GET ENHANCED DEELS 🔥
  static Future<List<DeelModel>> getDeels({
    String? city,
    String? category,
    bool isLive = false,
    int limit = 20,
  }) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: isLive ? 800 : 1200));

    final random = Random();
    final List<DeelModel> deels = [];

    // Filter data by category
    List<Map<String, dynamic>> filteredData = realVideoData;
    if (category != null && category != 'All') {
      filteredData = realVideoData
          .where((data) => data['category'] == category)
          .toList();
    }

    // Generate enhanced deels
    for (int i = 0; i < limit; i++) {
      final dataIndex = random.nextInt(filteredData.length);
      final data = filteredData[dataIndex];

      final storeIndex = random.nextInt(data['stores'].length);
      final store = data['stores'][storeIndex];
      final offer = data['offers'][random.nextInt(data['offers'].length)];

      final originalPrice = 200 + random.nextInt(3000).toDouble();
      final discountPercent = 15 + random.nextInt(70);
      final discountedPrice = originalPrice * (100 - discountPercent) / 100;

      final deel = DeelModel(
        id: 'deel_${i + 1}_${DateTime.now().millisecondsSinceEpoch}',
        store: store,
        offer: offer,
        videoUrl: isLive ? data['liveUrl'] : data['videoUrl'],
        thumbnailUrl:
            'https://picsum.photos/400/600?random=${DateTime.now().millisecondsSinceEpoch + i}',
        likes: random.nextInt(2000) + 50,
        comments: random.nextInt(300) + 10,
        shares: random.nextInt(100) + 5,
        isTrending: random.nextBool() && random.nextInt(10) < 4, // 40% chance
        category: data['category'],
        expiry: DateTime.now().add(
          Duration(
            hours: random.nextInt(120) + 2, // 2-120 hours
            minutes: random.nextInt(60),
          ),
        ),
        city: city ?? 'Ujjain',
        originalPrice: originalPrice,
        discountedPrice: discountedPrice,
        description: _generateEnhancedDescription(
          store,
          offer,
          data['category'],
        ),
        storeAddress: _getStoreAddress(store),
        storePhone: _getStorePhone(store),
        tags: _generateEnhancedTags(data['category']),
        isActive: random.nextInt(10) < 9, // 90% active
        stockLeft: random.nextInt(50) + 1,
        claimInstructions: _generateEnhancedClaimInstructions(isLive),
      );

      deels.add(deel);
    }

    // Sort by trending first, then by engagement, then by time left
    deels.sort((a, b) {
      if (a.isTrending && !b.isTrending) return -1;
      if (!a.isTrending && b.isTrending) return 1;

      final engagementDiff = b.engagementScore.compareTo(a.engagementScore);
      if (engagementDiff != 0) return engagementDiff;

      return a.timeLeft.compareTo(b.timeLeft);
    });

    return deels;
  }

  // 📝 GENERATE ENHANCED DESCRIPTION 📝
  static String _generateEnhancedDescription(
    String store,
    String offer,
    String category,
  ) {
    final descriptions = {
      'Food': [
        '🍕 Exclusive offer at $store! $offer. Fresh ingredients, authentic taste!',
        '🍽️ Limited time deal from $store: $offer. Order now for best quality!',
        '🥘 Special promotion at $store! $offer. Made with love, served with care!',
        '🍜 Hot deal alert from $store! $offer. Don\'t miss this delicious opportunity!',
      ],
      'Fashion': [
        '👗 Trendy collection at $store! $offer. Latest fashion, best prices!',
        '👕 Style statement from $store: $offer. Upgrade your wardrobe today!',
        '👠 Fashion forward deals at $store! $offer. Look stunning, pay less!',
        '🛍️ Exclusive fashion offer from $store! $offer. Limited stock available!',
      ],
      'Electronics': [
        '📱 Tech deals at $store! $offer. Latest gadgets, unbeatable prices!',
        '💻 Digital revolution from $store: $offer. Upgrade your tech game!',
        '🎧 Electronic bonanza at $store! $offer. Quality guaranteed!',
        '📺 Smart deals from $store! $offer. Technology made affordable!',
      ],
      'Grocery': [
        '🛒 Fresh deals at $store! $offer. Quality products, daily essentials!',
        '🥬 Grocery savings from $store: $offer. Fresh, organic, affordable!',
        '🍎 Daily needs at $store! $offer. Everything under one roof!',
        '🥛 Fresh stock from $store! $offer. Quality you can trust!',
      ],
      'Others': [
        '🔧 Professional service at $store! $offer. Expert solutions, fair prices!',
        '💆 Premium service from $store: $offer. Quality service guaranteed!',
        '🏠 Reliable service at $store! $offer. Your satisfaction, our priority!',
        '⚡ Quick service from $store! $offer. Fast, efficient, affordable!',
      ],
    };

    final categoryDescriptions =
        descriptions[category] ?? descriptions['Others']!;
    return categoryDescriptions[Random().nextInt(categoryDescriptions.length)];
  }

  // 🏪 GET STORE ADDRESS 🏪
  static String _getStoreAddress(String storeName) {
    final addresses = [
      'Mahakal Road, Ujjain',
      'Freeganj Market, Ujjain',
      'Tower Chowk, Ujjain',
      'Nanakheda, Ujjain',
      'University Road, Ujjain',
      'Dewas Gate, Ujjain',
      'Agar Road, Ujjain',
      'Chimanganj, Ujjain',
    ];
    return addresses[Random().nextInt(addresses.length)];
  }

  // 📞 GET STORE PHONE 📞
  static String _getStorePhone(String storeName) {
    final baseNumber = 9876543210;
    final randomOffset = Random().nextInt(100);
    return '+91 ${baseNumber + randomOffset}';
  }

  // 🏷️ GENERATE ENHANCED TAGS 🏷️
  static List<String> _generateEnhancedTags(String category) {
    final tagMap = {
      'Food': [
        'delicious',
        'fresh',
        'homemade',
        'spicy',
        'healthy',
        'organic',
        'tasty',
        'authentic',
      ],
      'Fashion': [
        'trendy',
        'stylish',
        'designer',
        'branded',
        'comfortable',
        'elegant',
        'modern',
        'chic',
      ],
      'Electronics': [
        'latest',
        'smart',
        'wireless',
        'premium',
        'durable',
        'innovative',
        'high-tech',
        'efficient',
      ],
      'Grocery': [
        'fresh',
        'organic',
        'natural',
        'healthy',
        'pure',
        'quality',
        'daily-needs',
        'affordable',
      ],
      'Others': [
        'professional',
        'reliable',
        'quick',
        'expert',
        'certified',
        'trusted',
        'quality',
        'affordable',
      ],
    };

    final tags = tagMap[category] ?? tagMap['Others']!;
    final selectedTags = <String>[];
    final random = Random();

    // Select 3-5 random tags
    final count = 3 + random.nextInt(3);
    for (int i = 0; i < count; i++) {
      final tag = tags[random.nextInt(tags.length)];
      if (!selectedTags.contains(tag)) {
        selectedTags.add(tag);
      }
    }

    return selectedTags;
  }

  // 📋 GENERATE ENHANCED CLAIM INSTRUCTIONS 📋
  static String _generateEnhancedClaimInstructions(bool isLive) {
    if (isLive) {
      final liveInstructions = [
        '🔴 Join the live stream and comment "CLAIM" to get this offer!',
        '📱 Screenshot this live offer and show at the store within 2 hours.',
        '🎥 Watch the live demo and mention code "LIVE2024" while ordering.',
        '⚡ Live exclusive! Call the store now and mention this live offer.',
        '🔥 Limited time live offer! Visit store immediately with this screen.',
      ];
      return liveInstructions[Random().nextInt(liveInstructions.length)];
    } else {
      final instructions = [
        '📱 Show this video offer at the store to claim your discount.',
        '📞 Call the store and mention offer code "BAZARSE2024".',
        '🏪 Visit the store within offer validity period with this screen.',
        '📸 Screenshot this offer and show at billing counter.',
        '💬 WhatsApp the store with this offer screenshot to claim.',
      ];
      return instructions[Random().nextInt(instructions.length)];
    }
  }

  // 🎥 GET LIVE STREAMS 🎥
  static Future<List<String>> getLiveStreams() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return liveStreamUrls;
  }

  // 📊 GET TRENDING DEELS 📊
  static Future<List<DeelModel>> getTrendingDeels({String? city}) async {
    final allDeels = await getDeels(city: city, limit: 100);
    return allDeels.where((deel) => deel.isTrending).take(20).toList();
  }

  // 🔥 GET HOT DEALS 🔥
  static Future<List<DeelModel>> getHotDeals({String? city}) async {
    final allDeels = await getDeels(city: city, limit: 100);
    return allDeels.where((deel) => deel.isHotDeal).take(15).toList();
  }
}
