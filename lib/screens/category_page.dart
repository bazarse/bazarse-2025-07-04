import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/animated_background.dart';
import '../services/pexels_service.dart';
import 'store_page.dart';

// 🏪 CATEGORY PAGE - VINU BHAISAHAB KA CATEGORY EXPLORER 🏪
class CategoryPage extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> subcategories;

  const CategoryPage({
    super.key,
    required this.category,
    required this.subcategories,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;

  String _selectedSubcategory = 'All';
  String _sortBy = 'Popular';
  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadStores();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );
    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.elasticOut),
    );

    _headerController.forward();
    Future.delayed(
      Duration(milliseconds: 300),
      () => _contentController.forward(),
    );
  }

  Future<void> _loadStores() async {
    try {
      print('🔥 Loading stores for category: ${widget.category}');

      // Get stores from Firebase based on category
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('marketplaces')
          .doc('ujjain')
          .collection('places')
          .where('category', isEqualTo: widget.category)
          .where('business_status', isEqualTo: 'OPERATIONAL')
          .get();

      List<Map<String, dynamic>> loadedStores = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> storeData = doc.data() as Map<String, dynamic>;
        storeData['id'] = doc.id;

        // Generate category-specific offers
        storeData['generatedOffers'] = _generateOffersForCategory(
          storeData['category'] ?? 'General',
        );

        // Get Google Photos URL if available
        if (storeData['photo_reference'] != null &&
            storeData['photo_reference'].isNotEmpty) {
          storeData['imageUrl'] = _getGooglePhotoUrl(
            storeData['photo_reference'],
          );
        } else if (storeData['imageUrl'] == null ||
            storeData['imageUrl'].isEmpty) {
          // Fallback to Pexels if no Google photo
          storeData['imageUrl'] = await PexelsService.getStoreImage(
            storeData['store_name'] ?? storeData['name'] ?? 'Store',
            widget.category,
          );
        }

        loadedStores.add(storeData);
      }

      print('✅ Loaded ${loadedStores.length} stores from Firebase');

      if (mounted) {
        setState(() {
          _stores = loadedStores;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading stores: $e');
      if (mounted) {
        setState(() {
          _stores = [];
          _isLoading = false;
        });
      }
    }
  }

  // 🎯 GENERATE CATEGORY-SPECIFIC OFFERS 🎯
  List<String> _generateOffersForCategory(String category) {
    Map<String, List<String>> categoryOffers = {
      'Beauty & Personal Care': [
        'Bridal Makeup Package - 50% OFF',
        'Free consultation + 20% discount',
        'Wedding season special - Book now!',
        'Makeup trial + photoshoot combo',
        'Get 3 services, pay for 2',
      ],
      'Food & Dining': [
        'Flat 30% OFF on all items',
        'Buy 2 Get 1 FREE on desserts',
        'Free home delivery above ₹500',
        'Special thali combo - ₹199 only',
        'Happy hours - 50% OFF drinks',
      ],
      'Electronics & Tech': [
        'Latest smartphone deals - Up to 40% OFF',
        'Free accessories with purchase',
        'EMI starting from ₹999/month',
        'Extended warranty - 2 years FREE',
        'Trade-in bonus - Extra ₹5000',
      ],
      'Fashion & Clothing': [
        'End of season sale - 60% OFF',
        'Buy 3 Get 2 FREE',
        'Free alteration services',
        'Festive collection - Starting ₹499',
        'Premium brands - Flat 40% OFF',
      ],
      'Grocery & Daily': [
        'Fresh vegetables - 20% OFF',
        'Free home delivery',
        'Buy groceries worth ₹1000, get ₹200 OFF',
        'Daily essentials combo pack',
        'Organic products - Special discount',
      ],
      'Health & Medical': [
        'Free home delivery of medicines',
        '10% OFF on all medicines',
        'Health checkup packages available',
        'Buy 2 Get 1 FREE on supplements',
        '24/7 emergency medicine delivery',
      ],
    };

    return categoryOffers[category] ??
        [
          'Special discount available',
          'Limited time offer',
          'Best deals in town',
          'Quality guaranteed',
          'Customer favorite',
        ];
  }

  // 📸 GET GOOGLE PHOTOS URL 📸
  String _getGooglePhotoUrl(String photoReference) {
    const String apiKey =
        'AIzaSyDexYes91JK03iFpCtLIE65J0FoUEYlFRI'; // Your Google Maps API key
    const int maxWidth = 400;

    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // 🎯 ANIMATED HEADER 🎯
              _buildAnimatedHeader(),

              // 🔍 FILTERS & SORT 🔍
              _buildFiltersSection(),

              // 🎨 CATEGORY BANNER 🎨
              _buildCategoryBanner(),

              // 🏪 STORES GRID 🏪
              _buildStoresGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 BUILD ANIMATED HEADER 🎯
  Widget _buildAnimatedHeader() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _headerAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _headerAnimation.value)),
            child: Opacity(
              opacity: _headerAnimation.value,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Color(0xFF0070FF), Color(0xFF7D30F5)],
                            ).createShader(bounds),
                            child: Text(
                              widget.category,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${_stores.length} stores available',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(Icons.search, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔍 BUILD FILTERS SECTION 🔍
  Widget _buildFiltersSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Subcategories
            if (widget.subcategories.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSubcategoryChip('All', true),
                    ...widget.subcategories.map(
                      (sub) => _buildSubcategoryChip(sub['name'], false),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
            ],

            // Sort Options
            Row(
              children: [
                Expanded(child: _buildSortChip('Popular', Icons.trending_up)),
                SizedBox(width: 10),
                Expanded(child: _buildSortChip('Nearby', Icons.location_on)),
                SizedBox(width: 10),
                Expanded(child: _buildSortChip('Rating', Icons.star)),
                SizedBox(width: 10),
                Expanded(child: _buildSortChip('Offers', Icons.local_offer)),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryChip(String name, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(colors: [Color(0xFF0070FF), Color(0xFF7D30F5)])
            : null,
        color: isSelected ? null : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSortChip(String title, IconData icon) {
    bool isSelected = _sortBy == title;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = title),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Color(0xFF0070FF), Color(0xFF7D30F5)])
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🏪 BUILD STORES GRID 🏪
  Widget _buildStoresGrid() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _contentAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _contentAnimation.value)),
            child: Opacity(
              opacity: _contentAnimation.value,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: _isLoading
                    ? _buildLoadingGrid()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Stores',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 15),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 3.5,
                                  mainAxisSpacing: 15,
                                ),
                            itemCount: _stores.length,
                            itemBuilder: (context, index) {
                              return _buildStoreCard(_stores[index]);
                            },
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return Column(
      children: List.generate(
        5,
        (index) => Container(
          height: 120,
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0070FF)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StorePage(store: store)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF0070FF).withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Store Image
            Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.network(
                  store['imageUrl'] ?? 'https://via.placeholder.com/100x120',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0070FF), Color(0xFF7D30F5)],
                        ),
                      ),
                      child: Icon(Icons.store, color: Colors.white, size: 40),
                    );
                  },
                ),
              ),
            ),

            // Store Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Name & Verified Badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            store['store_name'] ??
                                store['name'] ??
                                'Store Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (store['claimed'] == true ||
                            store['isVerified'] == true)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'VERIFIED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 5),

                    // Offer
                    Text(
                      store['generatedOffers'] != null &&
                              store['generatedOffers'].isNotEmpty
                          ? store['generatedOffers'][0]
                          : store['offer'] ?? 'Special offers available',
                      style: TextStyle(
                        color: Color(0xFF0070FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8),

                    // Rating, Distance, Credibility
                    Row(
                      children: [
                        // Rating
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            SizedBox(width: 2),
                            Text(
                              '${store['rating'] ?? 4.5}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 15),

                        // Distance
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 14,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${store['distance'] ?? '1.2'} km',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        // Credibility Score
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0070FF), Color(0xFF7D30F5)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${store['credibilityScore'] ?? 85}/100',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎨 BUILD CATEGORY BANNER 🎨
  Widget _buildCategoryBanner() {
    return SliverToBoxAdapter(
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0070FF), Color(0xFF7D30F5), Color(0xFFFF2EB4)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF0070FF).withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Pattern
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Banner Content
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Offers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Up to 50% OFF on ${widget.category}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Explore Now',
                      style: TextStyle(
                        color: Color(0xFF0070FF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
