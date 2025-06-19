class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isInStock;
  final bool isFeatured;
  final bool isOnSale;
  final String brand;
  final List<String> tags;
  final Map<String, dynamic> specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.images,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.isInStock,
    required this.isFeatured,
    required this.isOnSale,
    required this.brand,
    required this.tags,
    required this.specifications,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate discount percentage
  double get discountPercentage {
    if (originalPrice <= price) return 0;
    return ((originalPrice - price) / originalPrice * 100);
  }

  // Check if product has discount
  bool get hasDiscount => discountPercentage > 0;

  // Get formatted price
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedOriginalPrice => '₹${originalPrice.toStringAsFixed(0)}';

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isInStock': isInStock,
      'isFeatured': isFeatured,
      'isOnSale': isOnSale,
      'brand': brand,
      'tags': tags,
      'specifications': specifications,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isInStock: json['isInStock'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      isOnSale: json['isOnSale'] ?? false,
      brand: json['brand'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      specifications: json['specifications'] ?? {},
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Copy with method
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? images,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isInStock,
    bool? isFeatured,
    bool? isOnSale,
    String? brand,
    List<String>? tags,
    Map<String, dynamic>? specifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isInStock: isInStock ?? this.isInStock,
      isFeatured: isFeatured ?? this.isFeatured,
      isOnSale: isOnSale ?? this.isOnSale,
      brand: brand ?? this.brand,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}
