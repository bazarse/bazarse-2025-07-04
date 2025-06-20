import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../services/location_service.dart';
import 'claim_business_profile_page.dart';

class ClaimBusinessSearchPage extends StatefulWidget {
  const ClaimBusinessSearchPage({super.key});

  @override
  State<ClaimBusinessSearchPage> createState() => _ClaimBusinessSearchPageState();
}

class _ClaimBusinessSearchPageState extends State<ClaimBusinessSearchPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _currentCity = 'Ujjain';
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _getCurrentCity();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _getCurrentCity() async {
    try {
      final locationData = await LocationService.getCurrentLocationWithAddress();
      if (locationData['success'] && locationData['address'] != null) {
        setState(() {
          _currentCity = locationData['address'].split(',').first.trim();
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 🔥 HEADER 🔥
              _buildHeader(),
              
              // 🔥 SEARCH BAR 🔥
              _buildSearchBar(),
              
              // 🔥 SEARCH RESULTS 🔥
              Expanded(
                child: _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 HEADER 🔥
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Claim Your Business',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Search in $_currentCity',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gradientStart,
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

  // 🔥 SEARCH BAR 🔥
  Widget _buildSearchBar() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart.withValues(alpha: 0.3),
              AppColors.gradientMiddle.withValues(alpha: 0.2),
              AppColors.gradientEnd.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.gradientStart.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _performSearch(value);
          },
          decoration: InputDecoration(
            hintText: 'Search for your business (e.g., Devi Mobile)',
            hintStyle: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.gradientStart,
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _searchResults.clear();
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  // 🔥 SEARCH RESULTS 🔥
  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return _buildEmptyState();
    }

    if (_isSearching) {
      return _buildLoadingState();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResultsState();
    }

    return _buildResultsList();
  }

  // 🔥 EMPTY STATE 🔥
  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientStart.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.business_center,
                size: 48,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Search for Your Business',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Enter your business name to find and claim it',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Example: "Devi Mobile", "Sharma Electronics"',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.gradientStart,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 LOADING STATE 🔥
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'AI is searching for businesses...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          Text(
            'in $_currentCity',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gradientStart,
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 NO RESULTS STATE 🔥
  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withValues(alpha: 0.5),
          ),

          const SizedBox(height: 20),

          Text(
            'No businesses found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Try searching with a different name',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 RESULTS LIST 🔥
  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final business = _searchResults[index];
        return _buildBusinessCard(business, index);
      },
    );
  }

  // 🔥 BUSINESS CARD 🔥
  Widget _buildBusinessCard(Map<String, dynamic> business, int index) {
    return GestureDetector(
      onTap: () => _navigateToBusinessProfile(business),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gradientStart.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientStart.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // Business Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getBusinessIcon(business['category']),
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Business Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    business['category'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gradientStart,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    business['address'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Claim Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientStart.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                'Claim',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 PERFORM SEARCH 🔥
  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate AI search delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock search results based on query
    final results = _getMockSearchResults(query);

    setState(() {
      _isSearching = false;
      _searchResults = results;
    });
  }

  // 🔥 MOCK SEARCH RESULTS 🔥
  List<Map<String, dynamic>> _getMockSearchResults(String query) {
    final allBusinesses = [
      {
        'name': 'Devi Mobile',
        'category': 'Mobile & Electronics',
        'address': 'Freeganj, Ujjain, MP',
        'rating': 4.2,
        'verified': false,
        'phone': '+91 98765 43210',
        'email': 'devi.mobile@gmail.com',
      },
      {
        'name': 'Sharma Electronics',
        'category': 'Electronics Store',
        'address': 'Mahakal Road, Ujjain, MP',
        'rating': 4.5,
        'verified': true,
        'phone': '+91 98765 43211',
        'email': 'sharma.electronics@gmail.com',
      },
      {
        'name': 'Mobile Zone',
        'category': 'Mobile Shop',
        'address': 'Tower Chowk, Ujjain, MP',
        'rating': 4.0,
        'verified': false,
        'phone': '+91 98765 43212',
        'email': 'mobilezone@gmail.com',
      },
    ];

    return allBusinesses
        .where((business) =>
            (business['name'] as String).toLowerCase().contains(query.toLowerCase()) ||
            (business['category'] as String).toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 🔥 GET BUSINESS ICON 🔥
  IconData _getBusinessIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mobile & electronics':
      case 'mobile shop':
        return Icons.phone_android;
      case 'electronics store':
        return Icons.electrical_services;
      case 'restaurant':
        return Icons.restaurant;
      case 'grocery':
        return Icons.local_grocery_store;
      default:
        return Icons.business;
    }
  }

  // 🔥 NAVIGATE TO BUSINESS PROFILE 🔥
  void _navigateToBusinessProfile(Map<String, dynamic> business) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClaimBusinessProfilePage(business: business),
      ),
    );
  }
}
