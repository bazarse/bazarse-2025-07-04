import 'dart:math';

class AICategoryService {
  // 🤖 LOCAL AI CATEGORY FILTERING 🤖
  
  // Predefined categories with keywords for AI matching
  static const Map<String, List<String>> _categoryKeywords = {
    'Mobile & Electronics': [
      'mobile', 'phone', 'smartphone', 'electronics', 'gadget', 'device',
      'tablet', 'laptop', 'computer', 'headphone', 'charger', 'accessory',
      'samsung', 'apple', 'xiaomi', 'oppo', 'vivo', 'oneplus', 'realme'
    ],
    'Restaurant & Food': [
      'restaurant', 'food', 'cafe', 'hotel', 'dhaba', 'kitchen', 'dining',
      'pizza', 'burger', 'chinese', 'indian', 'fast food', 'bakery',
      'sweet', 'snack', 'meal', 'lunch', 'dinner', 'breakfast'
    ],
    'Grocery & Supermarket': [
      'grocery', 'supermarket', 'kirana', 'general store', 'mart', 'bazaar',
      'vegetables', 'fruits', 'daily needs', 'provisions', 'supplies',
      'food items', 'household', 'essentials'
    ],
    'Clothing & Fashion': [
      'clothing', 'fashion', 'dress', 'shirt', 'pant', 'saree', 'kurti',
      'boutique', 'tailor', 'garment', 'textile', 'fabric', 'readymade',
      'men wear', 'women wear', 'kids wear', 'footwear', 'shoes'
    ],
    'Medical & Pharmacy': [
      'medical', 'pharmacy', 'chemist', 'medicine', 'drug', 'hospital',
      'clinic', 'doctor', 'health', 'care', 'treatment', 'diagnostic',
      'lab', 'pathology', 'dental', 'eye care'
    ],
    'Beauty & Salon': [
      'beauty', 'salon', 'parlour', 'spa', 'hair', 'makeup', 'facial',
      'massage', 'cosmetic', 'skincare', 'nail', 'grooming', 'styling',
      'barber', 'unisex', 'ladies', 'gents'
    ],
    'Auto & Services': [
      'auto', 'car', 'bike', 'motorcycle', 'scooter', 'repair', 'service',
      'garage', 'mechanic', 'spare parts', 'accessories', 'washing',
      'fuel', 'petrol', 'diesel', 'tyre', 'battery'
    ],
    'Education & Training': [
      'education', 'school', 'college', 'institute', 'coaching', 'tuition',
      'training', 'class', 'academy', 'learning', 'course', 'study',
      'computer', 'english', 'math', 'science', 'skill'
    ],
    'Home & Services': [
      'home', 'house', 'plumber', 'electrician', 'carpenter', 'painter',
      'cleaning', 'repair', 'maintenance', 'construction', 'interior',
      'furniture', 'appliance', 'ac', 'refrigerator'
    ],
    'Financial Services': [
      'bank', 'atm', 'finance', 'loan', 'insurance', 'investment',
      'money', 'transfer', 'payment', 'credit', 'debit', 'account',
      'mutual fund', 'tax', 'accounting', 'chartered accountant'
    ],
  };

  // 🎯 SMART CATEGORY DETECTION 🎯
  static String detectCategory(String businessName, String description) {
    businessName = businessName.toLowerCase();
    description = description.toLowerCase();
    
    Map<String, int> categoryScores = {};
    
    // Initialize scores
    for (String category in _categoryKeywords.keys) {
      categoryScores[category] = 0;
    }
    
    // Score based on business name
    for (String category in _categoryKeywords.keys) {
      for (String keyword in _categoryKeywords[category]!) {
        if (businessName.contains(keyword)) {
          categoryScores[category] = categoryScores[category]! + 3; // Higher weight for name
        }
        if (description.contains(keyword)) {
          categoryScores[category] = categoryScores[category]! + 1;
        }
      }
    }
    
    // Find category with highest score
    String bestCategory = 'General Business';
    int maxScore = 0;
    
    categoryScores.forEach((category, score) {
      if (score > maxScore) {
        maxScore = score;
        bestCategory = category;
      }
    });
    
    return maxScore > 0 ? bestCategory : 'General Business';
  }

  // 🔍 FILTER BUSINESSES BY CATEGORY 🔍
  static List<Map<String, dynamic>> filterByCategory(
    List<Map<String, dynamic>> businesses,
    String? selectedCategory,
  ) {
    if (selectedCategory == null || selectedCategory == 'All Categories') {
      return businesses;
    }
    
    return businesses.where((business) {
      String businessCategory = business['category'] ?? '';
      return businessCategory.toLowerCase().contains(selectedCategory.toLowerCase()) ||
             selectedCategory.toLowerCase().contains(businessCategory.toLowerCase());
    }).toList();
  }

  // 📊 GET CATEGORY SUGGESTIONS 📊
  static List<String> getCategorySuggestions(String query) {
    query = query.toLowerCase();
    List<String> suggestions = [];
    
    // Add exact matches first
    for (String category in _categoryKeywords.keys) {
      if (category.toLowerCase().contains(query)) {
        suggestions.add(category);
      }
    }
    
    // Add keyword matches
    for (String category in _categoryKeywords.keys) {
      if (!suggestions.contains(category)) {
        for (String keyword in _categoryKeywords[category]!) {
          if (keyword.contains(query) && query.length >= 3) {
            suggestions.add(category);
            break;
          }
        }
      }
    }
    
    return suggestions.take(5).toList();
  }

  // 🏷️ GET ALL CATEGORIES 🏷️
  static List<String> getAllCategories() {
    return ['All Categories'] + _categoryKeywords.keys.toList();
  }

  // 🎲 SMART BUSINESS RANKING 🎲
  static List<Map<String, dynamic>> rankBusinesses(
    List<Map<String, dynamic>> businesses,
    String query,
  ) {
    query = query.toLowerCase();
    
    // Calculate relevance score for each business
    for (var business in businesses) {
      int score = 0;
      String name = (business['name'] ?? '').toLowerCase();
      String category = (business['category'] ?? '').toLowerCase();
      String address = (business['address'] ?? '').toLowerCase();
      
      // Name match (highest priority)
      if (name.contains(query)) {
        score += 100;
        if (name.startsWith(query)) {
          score += 50; // Bonus for starting with query
        }
      }
      
      // Category match
      if (category.contains(query)) {
        score += 30;
      }
      
      // Address match
      if (address.contains(query)) {
        score += 10;
      }
      
      // Rating bonus
      double rating = (business['rating'] ?? 0.0).toDouble();
      score += (rating * 5).round();
      
      // Verification bonus
      if (business['verified'] == true) {
        score += 20;
      }
      
      // Claimed business penalty (lower priority)
      if (business['is_claimed'] == true) {
        score -= 10;
      }
      
      business['relevance_score'] = score;
    }
    
    // Sort by relevance score
    businesses.sort((a, b) {
      int scoreA = a['relevance_score'] ?? 0;
      int scoreB = b['relevance_score'] ?? 0;
      return scoreB.compareTo(scoreA); // Descending order
    });
    
    return businesses;
  }

  // 🔮 PREDICT BUSINESS TYPE 🔮
  static Map<String, dynamic> predictBusinessInfo(String businessName) {
    String category = detectCategory(businessName, '');
    
    // Generate predicted info based on category
    Map<String, dynamic> prediction = {
      'predicted_category': category,
      'confidence': _calculateConfidence(businessName, category),
      'suggested_keywords': _getSuggestedKeywords(category),
      'typical_services': _getTypicalServices(category),
    };
    
    return prediction;
  }

  // 📈 CALCULATE CONFIDENCE SCORE 📈
  static double _calculateConfidence(String businessName, String category) {
    businessName = businessName.toLowerCase();
    
    if (!_categoryKeywords.containsKey(category)) {
      return 0.3; // Low confidence for unknown category
    }
    
    int matches = 0;
    List<String> keywords = _categoryKeywords[category]!;
    
    for (String keyword in keywords) {
      if (businessName.contains(keyword)) {
        matches++;
      }
    }
    
    double confidence = (matches / keywords.length) * 100;
    return confidence.clamp(0.0, 95.0); // Cap at 95%
  }

  // 🏷️ GET SUGGESTED KEYWORDS 🏷️
  static List<String> _getSuggestedKeywords(String category) {
    if (_categoryKeywords.containsKey(category)) {
      return _categoryKeywords[category]!.take(5).toList();
    }
    return ['business', 'service', 'shop', 'store', 'center'];
  }

  // 🛠️ GET TYPICAL SERVICES 🛠️
  static List<String> _getTypicalServices(String category) {
    const Map<String, List<String>> services = {
      'Mobile & Electronics': ['Mobile Repair', 'Accessories', 'New Phones', 'Screen Replacement'],
      'Restaurant & Food': ['Dine-in', 'Takeaway', 'Home Delivery', 'Catering'],
      'Grocery & Supermarket': ['Fresh Vegetables', 'Daily Essentials', 'Home Delivery', 'Bulk Orders'],
      'Clothing & Fashion': ['Readymade Garments', 'Custom Tailoring', 'Alterations', 'Designer Wear'],
      'Medical & Pharmacy': ['Prescription Medicines', 'Health Checkup', 'Consultation', 'Emergency Care'],
      'Beauty & Salon': ['Hair Cut', 'Facial', 'Makeup', 'Spa Services'],
      'Auto & Services': ['Vehicle Repair', 'Spare Parts', 'Maintenance', 'Washing'],
      'Education & Training': ['Coaching Classes', 'Skill Development', 'Certification', 'Online Classes'],
      'Home & Services': ['Repair Services', 'Installation', 'Maintenance', 'Emergency Support'],
      'Financial Services': ['Banking', 'Loans', 'Insurance', 'Investment Advice'],
    };
    
    return services[category] ?? ['General Services', 'Customer Support', 'Quality Products'];
  }

  // 🎯 SMART SEARCH SUGGESTIONS 🎯
  static List<String> getSmartSearchSuggestions(String query) {
    query = query.toLowerCase();
    List<String> suggestions = [];
    
    // Add category-based suggestions
    suggestions.addAll(getCategorySuggestions(query));
    
    // Add common business name patterns
    if (query.length >= 2) {
      List<String> patterns = [
        '$query shop',
        '$query store',
        '$query center',
        '$query services',
        '$query mart',
      ];
      suggestions.addAll(patterns);
    }
    
    return suggestions.take(8).toList();
  }
}
