import 'dart:math';
import '../models/product.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  // Mock data - In real app, this would come from API
  List<Product> _products = [];
  List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home & Kitchen',
    'Books',
    'Sports',
    'Beauty',
    'Groceries',
    'Toys',
    'Automotive',
    'Health'
  ];

  // Initialize with mock data
  void initializeMockData() {
    if (_products.isNotEmpty) return;

    final random = Random();
    final productNames = [
      'iPhone 15 Pro Max', 'Samsung Galaxy S24', 'MacBook Air M3', 'iPad Pro',
      'Nike Air Jordan', 'Adidas Ultraboost', 'Levi\'s Jeans', 'Zara Shirt',
      'KitchenAid Mixer', 'Dyson Vacuum', 'Sony Headphones', 'Canon Camera',
      'The Alchemist Book', 'Harry Potter Set', 'Yoga Mat', 'Dumbbells',
      'Lakme Lipstick', 'Nivea Cream', 'Basmati Rice', 'Organic Honey',
      'LEGO Set', 'Hot Wheels Car', 'Car Charger', 'Engine Oil',
      'Vitamin D3', 'Protein Powder', 'Gaming Chair', 'LED Monitor'
    ];

    final brands = [
      'Apple', 'Samsung', 'Nike', 'Adidas', 'Sony', 'Canon', 'Dyson',
      'KitchenAid', 'Levi\'s', 'Zara', 'Lakme', 'Nivea', 'LEGO', 'Hot Wheels'
    ];

    for (int i = 0; i < productNames.length; i++) {
      final originalPrice = 500 + random.nextInt(9500).toDouble();
      final discountPercent = random.nextInt(50);
      final price = originalPrice * (100 - discountPercent) / 100;

      _products.add(Product(
        id: 'prod_${i + 1}',
        name: productNames[i],
        description: 'Premium quality ${productNames[i]} with amazing features and excellent build quality. Perfect for daily use.',
        price: price,
        originalPrice: originalPrice,
        imageUrl: 'https://picsum.photos/400/400?random=${i + 1}',
        images: List.generate(3, (index) => 'https://picsum.photos/400/400?random=${i + 1}${index}'),
        category: _categories[random.nextInt(_categories.length)],
        rating: 3.5 + random.nextDouble() * 1.5,
        reviewCount: random.nextInt(1000) + 10,
        isInStock: random.nextBool() || random.nextBool(), // 75% chance of being in stock
        isFeatured: random.nextInt(4) == 0, // 25% chance of being featured
        isOnSale: discountPercent > 0,
        brand: brands[random.nextInt(brands.length)],
        tags: ['trending', 'popular', 'new arrival', 'bestseller']..shuffle(),
        specifications: {
          'warranty': '${random.nextInt(3) + 1} years',
          'color': ['Black', 'White', 'Blue', 'Red'][random.nextInt(4)],
          'weight': '${random.nextInt(500) + 100}g',
        },
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
        updatedAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
      ));
    }
  }

  // Get all products
  List<Product> getAllProducts() {
    initializeMockData();
    return List.from(_products);
  }

  // Get featured products
  List<Product> getFeaturedProducts() {
    initializeMockData();
    return _products.where((product) => product.isFeatured).toList();
  }

  // Get products on sale
  List<Product> getSaleProducts() {
    initializeMockData();
    return _products.where((product) => product.isOnSale).toList();
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    initializeMockData();
    return _products.where((product) => product.category == category).toList();
  }

  // Search products
  List<Product> searchProducts(String query) {
    initializeMockData();
    if (query.isEmpty) return getAllProducts();
    
    final lowercaseQuery = query.toLowerCase();
    return _products.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
             product.description.toLowerCase().contains(lowercaseQuery) ||
             product.category.toLowerCase().contains(lowercaseQuery) ||
             product.brand.toLowerCase().contains(lowercaseQuery) ||
             product.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Get product by ID
  Product? getProductById(String id) {
    initializeMockData();
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get categories
  List<String> getCategories() {
    return List.from(_categories);
  }

  // Get trending products (based on rating and review count)
  List<Product> getTrendingProducts() {
    initializeMockData();
    final trending = List<Product>.from(_products);
    trending.sort((a, b) {
      final aScore = a.rating * a.reviewCount;
      final bScore = b.rating * b.reviewCount;
      return bScore.compareTo(aScore);
    });
    return trending.take(10).toList();
  }

  // Get recommended products (mock AI recommendations)
  List<Product> getRecommendedProducts({String? category, List<String>? tags}) {
    initializeMockData();
    var recommended = List<Product>.from(_products);
    
    if (category != null) {
      recommended = recommended.where((p) => p.category == category).toList();
    }
    
    if (tags != null && tags.isNotEmpty) {
      recommended = recommended.where((p) => 
        p.tags.any((tag) => tags.contains(tag))
      ).toList();
    }
    
    recommended.shuffle();
    return recommended.take(8).toList();
  }

  // Get price range for category
  Map<String, double> getPriceRangeForCategory(String category) {
    final products = getProductsByCategory(category);
    if (products.isEmpty) return {'min': 0, 'max': 0};
    
    final prices = products.map((p) => p.price).toList();
    return {
      'min': prices.reduce((a, b) => a < b ? a : b),
      'max': prices.reduce((a, b) => a > b ? a : b),
    };
  }
}
