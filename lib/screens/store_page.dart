import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../constants/colors.dart';

// 🏪 STORE PAGE - VINU BHAISAHAB KA STORE DETAILS 🏪
class StorePage extends StatefulWidget {
  final Map<String, dynamic> store;

  const StorePage({super.key, required this.store});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;

  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadOffers();
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

  Future<void> _loadOffers() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _offers = _getDummyOffers();
      _isLoading = false;
    });
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
              // 🎯 STORE HEADER 🎯
              _buildStoreHeader(),

              // 📊 STORE INFO 📊
              _buildStoreInfo(),

              // 🎁 LIVE OFFERS 🎁
              _buildLiveOffers(),

              // 🤖 AI STORE OPTION 🤖
              if (widget.store['isAIStore'] == true) _buildAIStoreOption(),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 BUILD STORE HEADER 🎯
  Widget _buildStoreHeader() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _headerAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _headerAnimation.value)),
            child: Opacity(
              opacity: _headerAnimation.value,
              child: Container(
                height: 250,
                child: Stack(
                  children: [
                    // Store Image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.network(
                          widget.store['imageUrl'] ??
                              'https://via.placeholder.com/400x200',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF0070FF),
                                    Color(0xFF7D30F5),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.store,
                                color: Colors.white,
                                size: 80,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Gradient Overlay
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),

                    // Back Button
                    Positioned(
                      top: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // Store Info Card
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.store['name'] ?? 'Store Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (widget.store['isVerified'] == true)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'VERIFIED',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  '${widget.store['rating'] ?? 4.5}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '${widget.store['distance'] ?? '1.2'} km away',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0070FF),
                                        Color(0xFF7D30F5),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    '${widget.store['credibilityScore'] ?? 85}/100',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
            ),
          );
        },
      ),
    );
  }

  // 📊 BUILD STORE INFO 📊
  Widget _buildStoreInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Store Details
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.location_on,
                    'Address',
                    widget.store['address'] ?? 'Address not available',
                  ),
                  SizedBox(height: 15),
                  _buildInfoRow(
                    Icons.phone,
                    'Phone',
                    widget.store['phone'] ?? 'Phone not available',
                  ),
                  SizedBox(height: 15),
                  _buildInfoRow(
                    Icons.access_time,
                    'Hours',
                    widget.store['openingHours'] ?? 'Hours not available',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF0070FF), size: 20),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🎁 BUILD LIVE OFFERS 🎁
  Widget _buildLiveOffers() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Offers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 15),
                    _isLoading
                        ? _buildOffersLoading()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _offers.length,
                            itemBuilder: (context, index) {
                              return _buildOfferCard(_offers[index]);
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

  Widget _buildOffersLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          height: 100,
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

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
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
          // Offer Image
          Container(
            width: 80,
            height: 100,
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
                offer['imageUrl'] ?? 'https://via.placeholder.com/80x100',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0070FF), Color(0xFF7D30F5)],
                      ),
                    ),
                    child: Icon(
                      Icons.local_offer,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),

          // Offer Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer['title'] ?? 'Special Offer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    offer['description'] ?? 'Limited time offer',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${offer['discount'] ?? '20'}% OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Valid till ${offer['validTill'] ?? 'Dec 31'}',
                        style: TextStyle(color: Colors.white60, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Claim Button
          Container(
            padding: EdgeInsets.all(15),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0070FF), Color(0xFF7D30F5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Claim',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🤖 BUILD AI STORE OPTION 🤖
  Widget _buildAIStoreOption() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            // Navigate to AI Store page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('AI Store feature coming soon!'),
                backgroundColor: Color(0xFF0070FF),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0070FF),
                  Color(0xFF7D30F5),
                  Color(0xFFFF2EB4),
                ],
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
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.smart_toy, color: Colors.white, size: 30),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Store Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Chat with AI for personalized recommendations',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📊 GET DUMMY OFFERS DATA 📊
  List<Map<String, dynamic>> _getDummyOffers() {
    return [
      {
        'title': 'Special Combo Deal',
        'description': 'Get 2 items at the price of 1',
        'discount': 50,
        'validTill': 'Dec 31',
        'imageUrl':
            'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
      },
      {
        'title': 'Weekend Special',
        'description': 'Extra 20% off on all items',
        'discount': 20,
        'validTill': 'Dec 25',
        'imageUrl':
            'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=400',
      },
      {
        'title': 'Flash Sale',
        'description': 'Limited time offer - Hurry up!',
        'discount': 30,
        'validTill': 'Dec 20',
        'imageUrl':
            'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=400',
      },
    ];
  }
}
