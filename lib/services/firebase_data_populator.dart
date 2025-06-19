import 'package:cloud_firestore/cloud_firestore.dart';

// 🔥 FIREBASE DATA POPULATOR - VINU BHAISAHAB KA DATABASE CREATOR 🔥
class FirebaseDataPopulator {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🏪 POPULATE VENDORS DATA 🏪
  static Future<void> populateVendorsData() async {
    try {
      print('🔥 Starting Firebase data population...');

      // Add sample stores with new structure (no clearing for now)
      await _addSampleStores();

      print('✅ Firebase data population completed successfully!');
    } catch (e) {
      print('❌ Error populating Firebase data: $e');
      rethrow;
    }
  }

  // 🗑️ CLEAR EXISTING DATA 🗑️
  static Future<void> _clearExistingData() async {
    print('🧹 Clearing existing vendor data...');
    QuerySnapshot snapshot = await _firestore
        .collection('marketplaces')
        .doc('ujjain')
        .collection('places')
        .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
    print('✅ Existing data cleared');
  }

  // 🏪 ADD SAMPLE STORES WITH NEW STRUCTURE 🏪
  static Future<void> _addSampleStores() async {
    List<Map<String, dynamic>> sampleStores = [
      // Beauty & Personal Care Store
      {
        'store_name': 'Shreemakeovers',
        'address':
            'C-44/29, near Income Tax Colony, Rishi Nagar Extension, Rishi Nagar, Ujjain, Madhya Pradesh 456010',
        'allCategories': ['V. Beauty & Personal Care'],
        'business_status': 'OPERATIONAL',
        'category': 'Beauty & Personal Care',
        'category_type': 'store',
        'city': 'Ujjain',
        'claimed': false,
        'clean_category': true,
        'cleaned_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
        'duplicate_count': 1,
        'google_place_id': 'ChIJp1hhsId1YzkRrzIF7pq2ZQw',
        'is_cleaned': true,
        'is_validated': true,
        'location': {'lat': 23.1637615, 'lng': 75.7921504},
        'location_based': true,
        'major_category': '💇 BEAUTY & PERSONAL CARE',
        'neighborhood_removed': true,
        'phone': '+91 9876543210',
        'photo_reference':
            'AXQCQNScIQCULgVJgtSq6B-xrPZliEhFDXKk4YAy1lrtQF6pNW87lOtPmKe-Kspy917cIKjp2DSV48BInL-LTHvzleI3Lb30OzP1Vxc3BbQGcKkydJs85BM9kj4eOcHtaWnKf2ZGl6axaLpSto7NwSkB3Ue4KVJusF41C_s3mDR_8XiUlFZ9N8m6f9USUiF5CfVdrnLKvc67X-ELJqO1_NM0MNDVBcjwyPAlYTdXO1bm_ooD4j-UCnMSF_UjWPPxZak3C-nJl9ZNMff3xDnkcMLpWgXRX-PTFiRcLY9QCia47LZaGK7pjPc',
        'price_level': null,
        'rating': 4.9,
        'simplified_at': FieldValue.serverTimestamp(),
        'source': 'google_deep',
        'state': 'Madhya Pradesh',
        'subcategory': 'Makeup Artists / Bridal Services',
        'total_reviews': 11,
        'types': ['point_of_interest', 'establishment'],
        'updated_at': FieldValue.serverTimestamp(),
        'uses_coordinates': true,
        'website': '',
      },

      // Food & Dining Store
      {
        'store_name': 'Mahakal Sweets & Restaurant',
        'address': 'Near Mahakaleshwar Temple, Ujjain, MP 456001',
        'allCategories': ['Food & Dining'],
        'business_status': 'OPERATIONAL',
        'category': 'Food & Dining',
        'category_type': 'restaurant',
        'city': 'Ujjain',
        'claimed': true,
        'clean_category': true,
        'cleaned_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
        'duplicate_count': 0,
        'google_place_id': 'ChIJMahakalTempleUjjain123',
        'is_cleaned': true,
        'is_validated': true,
        'location': {'lat': 23.1765, 'lng': 75.7885},
        'location_based': true,
        'major_category': '🍕 FOOD & DINING',
        'neighborhood_removed': true,
        'phone': '+91 9876543211',
        'photo_reference': 'AXQCQNFoodRestaurantMahakalSweets123456789',
        'price_level': 2,
        'rating': 4.5,
        'simplified_at': FieldValue.serverTimestamp(),
        'source': 'google_deep',
        'state': 'Madhya Pradesh',
        'subcategory': 'Traditional Sweets / Restaurant',
        'total_reviews': 156,
        'types': ['restaurant', 'food', 'point_of_interest', 'establishment'],
        'updated_at': FieldValue.serverTimestamp(),
        'uses_coordinates': true,
        'website': '',
      },

      // Electronics Store
      {
        'store_name': 'Digital World Ujjain',
        'address': 'Tower Chowk, Ujjain, MP 456001',
        'allCategories': ['Electronics & Tech'],
        'business_status': 'OPERATIONAL',
        'category': 'Electronics & Tech',
        'category_type': 'electronics_store',
        'city': 'Ujjain',
        'claimed': false,
        'clean_category': true,
        'cleaned_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
        'duplicate_count': 0,
        'google_place_id': 'ChIJDigitalWorldUjjain456',
        'is_cleaned': true,
        'is_validated': true,
        'location': {'lat': 23.1828, 'lng': 75.7772},
        'location_based': true,
        'major_category': '📱 ELECTRONICS & TECH',
        'neighborhood_removed': true,
        'phone': '+91 9876543212',
        'photo_reference': 'AXQCQNElectronicsDigitalWorld789',
        'price_level': 3,
        'rating': 4.2,
        'simplified_at': FieldValue.serverTimestamp(),
        'source': 'google_deep',
        'state': 'Madhya Pradesh',
        'subcategory': 'Mobile Phones / Electronics',
        'total_reviews': 89,
        'types': ['electronics_store', 'point_of_interest', 'establishment'],
        'updated_at': FieldValue.serverTimestamp(),
        'uses_coordinates': true,
        'website': 'www.digitalworldujjain.com',
      },

      // Fashion Store
      {
        'store_name': 'Fashion Point Ujjain',
        'address': 'Freeganj Market, Ujjain, MP 456001',
        'allCategories': ['Fashion & Clothing'],
        'business_status': 'OPERATIONAL',
        'category': 'Fashion & Clothing',
        'category_type': 'clothing_store',
        'city': 'Ujjain',
        'claimed': true,
        'clean_category': true,
        'cleaned_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
        'duplicate_count': 0,
        'google_place_id': 'ChIJFashionPointUjjain789',
        'is_cleaned': true,
        'is_validated': true,
        'location': {'lat': 23.1795, 'lng': 75.7845},
        'location_based': true,
        'major_category': '👗 FASHION & CLOTHING',
        'neighborhood_removed': true,
        'phone': '+91 9876543213',
        'photo_reference': 'AXQCQNFashionClothingStore456',
        'price_level': 2,
        'rating': 4.3,
        'simplified_at': FieldValue.serverTimestamp(),
        'source': 'google_deep',
        'state': 'Madhya Pradesh',
        'subcategory': 'Men & Women Clothing',
        'total_reviews': 67,
        'types': ['clothing_store', 'point_of_interest', 'establishment'],
        'updated_at': FieldValue.serverTimestamp(),
        'uses_coordinates': true,
        'website': '',
      },

      // Grocery Store
      {
        'store_name': 'Ujjain Super Market',
        'address': 'Dewas Gate, Ujjain, MP 456001',
        'allCategories': ['Grocery & Daily'],
        'business_status': 'OPERATIONAL',
        'category': 'Grocery & Daily',
        'category_type': 'supermarket',
        'city': 'Ujjain',
        'claimed': false,
        'clean_category': true,
        'cleaned_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
        'duplicate_count': 0,
        'google_place_id': 'ChIJSuperMarketUjjain123',
        'is_cleaned': true,
        'is_validated': true,
        'location': {'lat': 23.1712, 'lng': 75.7901},
        'location_based': true,
        'major_category': '🛒 GROCERY & DAILY',
        'neighborhood_removed': true,
        'phone': '+91 9876543214',
        'photo_reference': 'AXQCQNGrocerySupermarket789',
        'price_level': 2,
        'rating': 4.1,
        'simplified_at': FieldValue.serverTimestamp(),
        'source': 'google_deep',
        'state': 'Madhya Pradesh',
        'subcategory': 'Grocery / Daily Essentials',
        'total_reviews': 234,
        'types': [
          'supermarket',
          'grocery_or_supermarket',
          'point_of_interest',
          'establishment',
        ],
        'updated_at': FieldValue.serverTimestamp(),
        'uses_coordinates': true,
        'website': '',
      },

      // Health & Medical Store
      {
        'store_name': 'Mahakal Medical Store',
        'address': 'Mahakal Road, Ujjain, MP 456001',
        'allCategories': ['Health & Medical'],
        'business_status': 'OPERATIONAL',
        'category': 'Health & Medical',
        'category_type': 'pharmacy',
        'city': 'Ujjain',
        'claimed': true,
        'clean_category': true,
        'cleaned_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
        'duplicate_count': 0,
        'google_place_id': 'ChIJMedicalStoreUjjain456',
        'is_cleaned': true,
        'is_validated': true,
        'location': {'lat': 23.1756, 'lng': 75.7889},
        'location_based': true,
        'major_category': '🏥 HEALTH & MEDICAL',
        'neighborhood_removed': true,
        'phone': '+91 9876543215',
        'photo_reference': 'AXQCQNMedicalPharmacy123',
        'price_level': 1,
        'rating': 4.6,
        'simplified_at': FieldValue.serverTimestamp(),
        'source': 'google_deep',
        'state': 'Madhya Pradesh',
        'subcategory': 'Pharmacy / Medical Store',
        'total_reviews': 78,
        'types': ['pharmacy', 'health', 'point_of_interest', 'establishment'],
        'updated_at': FieldValue.serverTimestamp(),
        'uses_coordinates': true,
        'website': '',
      },
    ];

    for (var store in sampleStores) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(store);
    }
    print('✅ Added ${sampleStores.length} sample stores with new structure');
  }

  // 🍽️ FOOD & DINING VENDORS 🍽️
  static Future<void> _addFoodDiningVendors() async {
    List<Map<String, dynamic>> foodVendors = [
      {
        'name': 'Mahakal Sweets & Restaurant',
        'category': 'Food & Dining',
        'subcategory': 'Food & Beverages',
        'city': 'Ujjain',
        'locality': 'Mahakaleshwar Temple Road',
        'address': 'Near Mahakaleshwar Temple, Ujjain, MP 456001',
        'phone': '+91 9876543210',
        'email': 'mahakalsweets@gmail.com',
        'rating': 4.5,
        'credibilityScore': 92,
        'isVerified': true,
        'isAIStore': true,
        'openingHours': '6:00 AM - 11:00 PM',
        'offers': ['30% OFF on all sweets', 'Free home delivery above ₹500'],
        'specialties': ['Ujjaini Sweets', 'Traditional Thali', 'Prasad Items'],
        'priceRange': '₹100-500',
        'imageUrl':
            'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Shipra Restaurant',
        'category': 'Food & Dining',
        'subcategory': 'Food & Beverages',
        'city': 'Ujjain',
        'locality': 'Freeganj',
        'address': 'Freeganj Market, Ujjain, MP 456001',
        'phone': '+91 9876543211',
        'email': 'shiprarestaurant@gmail.com',
        'rating': 4.2,
        'credibilityScore': 88,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '11:00 AM - 11:00 PM',
        'offers': ['Buy 2 Get 1 Free on beverages', '20% OFF on family meals'],
        'specialties': ['North Indian', 'Chinese', 'South Indian'],
        'priceRange': '₹150-600',
        'imageUrl':
            'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Kanha Dhaba',
        'category': 'Food & Dining',
        'subcategory': 'Food & Beverages',
        'city': 'Ujjain',
        'locality': 'Dewas Gate',
        'address': 'Dewas Gate, Ujjain, MP 456001',
        'phone': '+91 9876543212',
        'email': 'kanhadhaba@gmail.com',
        'rating': 4.0,
        'credibilityScore': 85,
        'isVerified': false,
        'isAIStore': true,
        'openingHours': '7:00 AM - 12:00 AM',
        'offers': ['Unlimited thali for ₹199', 'Free lassi with meals'],
        'specialties': ['Punjabi Dhaba Style', 'Butter Chicken', 'Dal Makhani'],
        'priceRange': '₹120-400',
        'imageUrl':
            'https://images.pexels.com/photos/1199957/pexels-photo-1199957.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Ujjain Fast Food Corner',
        'category': 'Food & Dining',
        'subcategory': 'Food & Beverages',
        'city': 'Ujjain',
        'locality': 'Tower Chowk',
        'address': 'Tower Chowk, Ujjain, MP 456001',
        'phone': '+91 9876543213',
        'email': 'ujjainfastfood@gmail.com',
        'rating': 3.8,
        'credibilityScore': 78,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '10:00 AM - 11:00 PM',
        'offers': ['Combo meals starting ₹99', 'Free delivery in 30 mins'],
        'specialties': ['Burgers', 'Pizza', 'Sandwiches', 'Momos'],
        'priceRange': '₹50-300',
        'imageUrl':
            'https://images.pexels.com/photos/1633578/pexels-photo-1633578.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Simhasth Cafe',
        'category': 'Food & Dining',
        'subcategory': 'Food & Beverages',
        'city': 'Ujjain',
        'locality': 'Kal Bhairav Road',
        'address': 'Kal Bhairav Road, Ujjain, MP 456001',
        'phone': '+91 9876543214',
        'email': 'simhashthcafe@gmail.com',
        'rating': 4.3,
        'credibilityScore': 90,
        'isVerified': true,
        'isAIStore': true,
        'openingHours': '8:00 AM - 10:00 PM',
        'offers': ['Coffee + Snacks combo ₹149', '25% OFF on cakes'],
        'specialties': ['Coffee', 'Pastries', 'Continental', 'Breakfast'],
        'priceRange': '₹80-350',
        'imageUrl':
            'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in foodVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${foodVendors.length} Food & Dining vendors');
  }

  // 🛒 GROCERY & DAILY VENDORS 🛒
  static Future<void> _addGroceryDailyVendors() async {
    List<Map<String, dynamic>> groceryVendors = [
      {
        'name': 'Ujjain Super Market',
        'category': 'Grocery & Daily',
        'subcategory': 'Daily Essentials & Grocery',
        'city': 'Ujjain',
        'locality': 'Freeganj',
        'address': 'Freeganj Market, Ujjain, MP 456001',
        'phone': '+91 9876543220',
        'email': 'ujjainsupermarket@gmail.com',
        'rating': 4.1,
        'credibilityScore': 87,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '7:00 AM - 10:00 PM',
        'offers': ['10% OFF on groceries above ₹1000', 'Free home delivery'],
        'specialties': [
          'Fresh Vegetables',
          'Dairy Products',
          'Household Items',
        ],
        'priceRange': '₹50-2000',
        'imageUrl':
            'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Mahakal Provision Store',
        'category': 'Grocery & Daily',
        'subcategory': 'Daily Essentials & Grocery',
        'city': 'Ujjain',
        'locality': 'Mahakaleshwar Temple Road',
        'address': 'Near Mahakaleshwar Temple, Ujjain, MP 456001',
        'phone': '+91 9876543221',
        'email': 'mahakalprovision@gmail.com',
        'rating': 4.4,
        'credibilityScore': 91,
        'isVerified': true,
        'isAIStore': true,
        'openingHours': '6:00 AM - 11:00 PM',
        'offers': [
          'Special rates for bulk orders',
          'Credit facility available',
        ],
        'specialties': ['Pooja Items', 'Organic Products', 'Local Specialties'],
        'priceRange': '₹20-1500',
        'imageUrl':
            'https://images.pexels.com/photos/4199098/pexels-photo-4199098.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Fresh Mart Ujjain',
        'category': 'Grocery & Daily',
        'subcategory': 'Daily Essentials & Grocery',
        'city': 'Ujjain',
        'locality': 'Dewas Gate',
        'address': 'Dewas Gate, Ujjain, MP 456001',
        'phone': '+91 9876543222',
        'email': 'freshmart@gmail.com',
        'rating': 3.9,
        'credibilityScore': 82,
        'isVerified': false,
        'isAIStore': false,
        'openingHours': '8:00 AM - 9:00 PM',
        'offers': ['Fresh vegetables daily', '5% discount on cash payment'],
        'specialties': ['Fresh Fruits', 'Vegetables', 'Dairy', 'Bakery Items'],
        'priceRange': '₹30-800',
        'imageUrl':
            'https://images.pexels.com/photos/1435904/pexels-photo-1435904.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in groceryVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${groceryVendors.length} Grocery & Daily vendors');
  }

  // 👗 FASHION & RETAIL VENDORS 👗
  static Future<void> _addFashionRetailVendors() async {
    List<Map<String, dynamic>> fashionVendors = [
      {
        'name': 'Fashion Point Ujjain',
        'category': 'Fashion & Retail',
        'subcategory': 'Fashion & Apparel',
        'city': 'Ujjain',
        'locality': 'Dewas Gate',
        'address': 'Dewas Gate Market, Ujjain, MP 456001',
        'phone': '+91 9876543230',
        'email': 'fashionpoint@gmail.com',
        'rating': 4.3,
        'credibilityScore': 85,
        'isVerified': false,
        'isAIStore': true,
        'openingHours': '10:00 AM - 8:00 PM',
        'offers': ['Buy 2 Get 1 FREE', 'Flat 40% OFF on ethnic wear'],
        'specialties': ['Ethnic Wear', 'Western Wear', 'Accessories'],
        'priceRange': '₹200-3000',
        'imageUrl':
            'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Ujjain Cloth House',
        'category': 'Fashion & Retail',
        'subcategory': 'Fashion & Apparel',
        'city': 'Ujjain',
        'locality': 'Freeganj',
        'address': 'Freeganj Market, Ujjain, MP 456001',
        'phone': '+91 9876543231',
        'email': 'ujjaincloth@gmail.com',
        'rating': 4.0,
        'credibilityScore': 88,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '9:00 AM - 9:00 PM',
        'offers': [
          'Traditional sarees collection',
          '25% OFF on wedding collection',
        ],
        'specialties': ['Sarees', 'Lehengas', 'Suits', 'Fabrics'],
        'priceRange': '₹500-10000',
        'imageUrl':
            'https://images.pexels.com/photos/1488463/pexels-photo-1488463.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in fashionVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${fashionVendors.length} Fashion & Retail vendors');
  }

  // 📱 ELECTRONICS & TECH VENDORS 📱
  static Future<void> _addElectronicsTechVendors() async {
    List<Map<String, dynamic>> electronicsVendors = [
      {
        'name': 'Ujjain Electronics Hub',
        'category': 'Electronics & Tech',
        'subcategory': 'Electronics & Appliances',
        'city': 'Ujjain',
        'locality': 'Freeganj',
        'address': 'Freeganj Market, Ujjain, MP 456001',
        'phone': '+91 9876543240',
        'email': 'ujjainelectronics@gmail.com',
        'rating': 4.2,
        'credibilityScore': 88,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '10:00 AM - 9:00 PM',
        'offers': ['Flat ₹500 OFF on mobiles', 'EMI available on all products'],
        'specialties': ['Mobile Phones', 'Laptops', 'Home Appliances'],
        'priceRange': '₹1000-50000',
        'imageUrl':
            'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Digital World Ujjain',
        'category': 'Electronics & Tech',
        'subcategory': 'Electronics & Appliances',
        'city': 'Ujjain',
        'locality': 'Tower Chowk',
        'address': 'Tower Chowk, Ujjain, MP 456001',
        'phone': '+91 9876543241',
        'email': 'digitalworld@gmail.com',
        'rating': 4.5,
        'credibilityScore': 92,
        'isVerified': true,
        'isAIStore': true,
        'openingHours': '10:00 AM - 8:00 PM',
        'offers': ['Latest smartphone deals', 'Free accessories with purchase'],
        'specialties': ['Smartphones', 'Accessories', 'Repair Services'],
        'priceRange': '₹500-30000',
        'imageUrl':
            'https://images.pexels.com/photos/1334597/pexels-photo-1334597.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in electronicsVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${electronicsVendors.length} Electronics & Tech vendors');
  }

  // 🏥 HEALTH & MEDICAL VENDORS 🏥
  static Future<void> _addHealthMedicalVendors() async {
    List<Map<String, dynamic>> healthVendors = [
      {
        'name': 'Mahakal Medical Store',
        'category': 'Health & Medical',
        'subcategory': 'Health & Wellness',
        'city': 'Ujjain',
        'locality': 'Mahakaleshwar Temple Road',
        'address': 'Near Mahakaleshwar Temple, Ujjain, MP 456001',
        'phone': '+91 9876543250',
        'email': 'mahakalmedical@gmail.com',
        'rating': 4.6,
        'credibilityScore': 95,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '24 Hours',
        'offers': ['10% discount on medicines', 'Free home delivery'],
        'specialties': ['Medicines', 'Health Supplements', 'Medical Equipment'],
        'priceRange': '₹50-2000',
        'imageUrl':
            'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Ujjain Clinic & Pharmacy',
        'category': 'Health & Medical',
        'subcategory': 'Health & Wellness',
        'city': 'Ujjain',
        'locality': 'Freeganj',
        'address': 'Freeganj, Ujjain, MP 456001',
        'phone': '+91 9876543251',
        'email': 'ujjainclinic@gmail.com',
        'rating': 4.3,
        'credibilityScore': 89,
        'isVerified': true,
        'isAIStore': true,
        'openingHours': '8:00 AM - 10:00 PM',
        'offers': [
          'Free consultation with medicine purchase',
          'Health checkup packages',
        ],
        'specialties': ['General Medicine', 'Pharmacy', 'Health Checkups'],
        'priceRange': '₹100-1500',
        'imageUrl':
            'https://images.pexels.com/photos/263402/pexels-photo-263402.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in healthVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${healthVendors.length} Health & Medical vendors');
  }

  // 💇 BEAUTY & CARE VENDORS 💇
  static Future<void> _addBeautyCareVendors() async {
    List<Map<String, dynamic>> beautyVendors = [
      {
        'name': 'Ujjain Beauty Parlour',
        'category': 'Beauty & Care',
        'subcategory': 'Beauty & Personal Care',
        'city': 'Ujjain',
        'locality': 'Freeganj',
        'address': 'Freeganj Market, Ujjain, MP 456001',
        'phone': '+91 9876543260',
        'email': 'ujjainbeauty@gmail.com',
        'rating': 4.4,
        'credibilityScore': 87,
        'isVerified': true,
        'isAIStore': true,
        'openingHours': '10:00 AM - 8:00 PM',
        'offers': ['Bridal package discount', 'Free consultation'],
        'specialties': ['Bridal Makeup', 'Hair Styling', 'Facial Treatments'],
        'priceRange': '₹300-5000',
        'imageUrl':
            'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in beautyVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${beautyVendors.length} Beauty & Care vendors');
  }

  // 📚 EDUCATION & TRAINING VENDORS 📚
  static Future<void> _addEducationTrainingVendors() async {
    List<Map<String, dynamic>> educationVendors = [
      {
        'name': 'Ujjain Coaching Center',
        'category': 'Education & Training',
        'subcategory': 'Education & Training',
        'city': 'Ujjain',
        'locality': 'Tower Chowk',
        'address': 'Tower Chowk, Ujjain, MP 456001',
        'phone': '+91 9876543270',
        'email': 'ujjaincoaching@gmail.com',
        'rating': 4.1,
        'credibilityScore': 83,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '6:00 AM - 10:00 PM',
        'offers': ['Free demo classes', 'Scholarship for meritorious students'],
        'specialties': [
          'JEE/NEET Coaching',
          'Board Exam Preparation',
          'Competitive Exams',
        ],
        'priceRange': '₹2000-15000',
        'imageUrl':
            'https://images.pexels.com/photos/159844/books-book-pages-read-literature-159844.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in educationVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${educationVendors.length} Education & Training vendors');
  }

  // 🏠 HOME & LIVING VENDORS 🏠
  static Future<void> _addHomeLivingVendors() async {
    List<Map<String, dynamic>> homeVendors = [
      {
        'name': 'Ujjain Furniture House',
        'category': 'Home & Living',
        'subcategory': 'Home & Living',
        'city': 'Ujjain',
        'locality': 'Dewas Gate',
        'address': 'Dewas Gate, Ujjain, MP 456001',
        'phone': '+91 9876543280',
        'email': 'ujjainfurniture@gmail.com',
        'rating': 4.0,
        'credibilityScore': 85,
        'isVerified': false,
        'isAIStore': false,
        'openingHours': '9:00 AM - 7:00 PM',
        'offers': ['EMI available', '20% OFF on bedroom sets'],
        'specialties': ['Bedroom Sets', 'Dining Tables', 'Sofas', 'Home Decor'],
        'priceRange': '₹5000-50000',
        'imageUrl':
            'https://images.pexels.com/photos/1350789/pexels-photo-1350789.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in homeVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${homeVendors.length} Home & Living vendors');
  }

  // 🔧 SERVICES & REPAIR VENDORS 🔧
  static Future<void> _addServicesRepairVendors() async {
    List<Map<String, dynamic>> serviceVendors = [
      {
        'name': 'Ujjain Mobile Repair',
        'category': 'Services & Repair',
        'subcategory': 'Services & Repair',
        'city': 'Ujjain',
        'locality': 'Freeganj',
        'address': 'Freeganj Market, Ujjain, MP 456001',
        'phone': '+91 9876543290',
        'email': 'ujjainrepair@gmail.com',
        'rating': 4.2,
        'credibilityScore': 88,
        'isVerified': true,
        'isAIStore': true,
        'openingHours': '10:00 AM - 8:00 PM',
        'offers': ['Free diagnosis', 'Warranty on repairs'],
        'specialties': ['Mobile Repair', 'Laptop Repair', 'Data Recovery'],
        'priceRange': '₹200-3000',
        'imageUrl':
            'https://images.pexels.com/photos/298863/pexels-photo-298863.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in serviceVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${serviceVendors.length} Services & Repair vendors');
  }

  // 💼 BUSINESS & PROFESSIONAL VENDORS 💼
  static Future<void> _addBusinessProfessionalVendors() async {
    List<Map<String, dynamic>> businessVendors = [
      {
        'name': 'Ujjain CA Office',
        'category': 'Business & Professional',
        'subcategory': 'Business & Professional',
        'city': 'Ujjain',
        'locality': 'Tower Chowk',
        'address': 'Tower Chowk, Ujjain, MP 456001',
        'phone': '+91 9876543300',
        'email': 'ujjainca@gmail.com',
        'rating': 4.5,
        'credibilityScore': 92,
        'isVerified': true,
        'isAIStore': false,
        'openingHours': '10:00 AM - 6:00 PM',
        'offers': ['Free consultation for new clients', 'GST filing services'],
        'specialties': ['Tax Filing', 'GST Services', 'Business Registration'],
        'priceRange': '₹500-10000',
        'imageUrl':
            'https://images.pexels.com/photos/590016/pexels-photo-590016.jpeg?auto=compress&cs=tinysrgb&w=400',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var vendor in businessVendors) {
      await _firestore
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .add(vendor);
    }
    print('✅ Added ${businessVendors.length} Business & Professional vendors');
  }
}
