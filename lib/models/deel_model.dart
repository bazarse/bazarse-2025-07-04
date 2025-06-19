class DeelModel {
  final String id;
  final String store;
  final String offer;
  final String videoUrl;
  final String thumbnailUrl;
  final int likes;
  final int comments;
  final int shares;
  final bool isTrending;
  final String category;
  final DateTime expiry;
  final String city;
  final double originalPrice;
  final double discountedPrice;
  final String description;
  final String storeAddress;
  final String storePhone;
  final List<String> tags;
  final bool isActive;
  final int stockLeft;
  final String claimInstructions;

  DeelModel({
    required this.id,
    required this.store,
    required this.offer,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isTrending,
    required this.category,
    required this.expiry,
    required this.city,
    required this.originalPrice,
    required this.discountedPrice,
    required this.description,
    required this.storeAddress,
    required this.storePhone,
    required this.tags,
    required this.isActive,
    required this.stockLeft,
    required this.claimInstructions,
  });

  // 🔥 FACTORY CONSTRUCTOR FROM JSON 🔥
  factory DeelModel.fromJson(Map<String, dynamic> json) {
    return DeelModel(
      id: json['id'] ?? '',
      store: json['store'] ?? '',
      offer: json['offer'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      isTrending: json['isTrending'] ?? false,
      category: json['category'] ?? 'Others',
      expiry: DateTime.parse(
        json['expiry'] ??
            DateTime.now().add(Duration(days: 1)).toIso8601String(),
      ),
      city: json['city'] ?? '',
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      storeAddress: json['storeAddress'] ?? '',
      storePhone: json['storePhone'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['isActive'] ?? true,
      stockLeft: json['stockLeft'] ?? 0,
      claimInstructions: json['claimInstructions'] ?? '',
    );
  }

  // 🔥 FROM FIRESTORE 🔥
  factory DeelModel.fromFirestore(Map<String, dynamic> data) {
    return DeelModel(
      id: data['id'] ?? '',
      store: data['store'] ?? '',
      offer: data['offer'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      shares: data['shares'] ?? 0,
      isTrending: data['isTrending'] ?? false,
      category: data['category'] ?? 'Others',
      expiry: data['expiry'] != null
          ? (data['expiry'] is String
                ? DateTime.parse(data['expiry'])
                : (data['expiry'] as dynamic).toDate())
          : DateTime.now().add(Duration(days: 1)),
      city: data['city'] ?? '',
      originalPrice: (data['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (data['discountedPrice'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      storeAddress: data['storeAddress'] ?? '',
      storePhone: data['storePhone'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      isActive: data['isActive'] ?? true,
      stockLeft: data['stockLeft'] ?? 0,
      claimInstructions: data['claimInstructions'] ?? '',
    );
  }

  // 🔥 TO JSON 🔥
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store': store,
      'offer': offer,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isTrending': isTrending,
      'category': category,
      'expiry': expiry.toIso8601String(),
      'city': city,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'description': description,
      'storeAddress': storeAddress,
      'storePhone': storePhone,
      'tags': tags,
      'isActive': isActive,
      'stockLeft': stockLeft,
      'claimInstructions': claimInstructions,
    };
  }

  // 🔥 HELPER METHODS 🔥

  // ⏰ IS EXPIRED ⏰
  bool get isExpired => DateTime.now().isAfter(expiry);

  // 💰 DISCOUNT PERCENTAGE 💰
  int get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice * 100).round();
  }

  // ⏳ TIME LEFT ⏳
  Duration get timeLeft {
    if (isExpired) return Duration.zero;
    return expiry.difference(DateTime.now());
  }

  // 📅 TIME LEFT STRING 📅
  String get timeLeftString {
    if (isExpired) return 'Expired';

    final duration = timeLeft;
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h left';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m left';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m left';
    } else {
      return '${duration.inSeconds}s left';
    }
  }

  // 🔥 IS HOT DEAL 🔥
  bool get isHotDeal => discountPercentage >= 50 || stockLeft <= 5;

  // 📊 ENGAGEMENT SCORE 📊
  int get engagementScore => likes + (comments * 2) + (shares * 3);

  // 🏪 STORE INITIAL 🏪
  String get storeInitial => store.isNotEmpty ? store[0].toUpperCase() : 'S';

  // 💸 SAVINGS AMOUNT 💸
  double get savingsAmount => originalPrice - discountedPrice;

  // 🎯 CAN CLAIM 🎯
  bool get canClaim => isActive && !isExpired && stockLeft > 0;

  // 🔥 COPY WITH 🔥
  DeelModel copyWith({
    String? id,
    String? store,
    String? offer,
    String? videoUrl,
    String? thumbnailUrl,
    int? likes,
    int? comments,
    int? shares,
    bool? isTrending,
    String? category,
    DateTime? expiry,
    String? city,
    double? originalPrice,
    double? discountedPrice,
    String? description,
    String? storeAddress,
    String? storePhone,
    List<String>? tags,
    bool? isActive,
    int? stockLeft,
    String? claimInstructions,
  }) {
    return DeelModel(
      id: id ?? this.id,
      store: store ?? this.store,
      offer: offer ?? this.offer,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isTrending: isTrending ?? this.isTrending,
      category: category ?? this.category,
      expiry: expiry ?? this.expiry,
      city: city ?? this.city,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      description: description ?? this.description,
      storeAddress: storeAddress ?? this.storeAddress,
      storePhone: storePhone ?? this.storePhone,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      stockLeft: stockLeft ?? this.stockLeft,
      claimInstructions: claimInstructions ?? this.claimInstructions,
    );
  }

  @override
  String toString() {
    return 'DeelModel(id: $id, store: $store, offer: $offer, category: $category, city: $city, isExpired: $isExpired, canClaim: $canClaim)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeelModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
