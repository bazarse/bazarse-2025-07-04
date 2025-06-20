import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../services/location_service.dart';
import '../services/google_places_service.dart';
import '../services/ai_category_service.dart';
import 'claim_business_profile_page.dart';
import 'report_claimed_business_page.dart';

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
  String _selectedCategory = 'All Categories';
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _allResults = [];
  List<String> _searchSuggestions = [];
  
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

              // 🔥 CATEGORY FILTER 🔥
              if (_searchQuery.isNotEmpty) _buildCategoryFilter(),

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

  // 🔥 CATEGORY FILTER 🔥
  Widget _buildCategoryFilter() {
    final categories = AICategoryService.getAllCategories();

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                _applyFilter();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppColors.primaryGradient
                      : null,
                  color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔥 APPLY FILTER 🔥
  void _applyFilter() {
    final filteredResults = AICategoryService.filterByCategory(_allResults, _selectedCategory);
    setState(() {
      _searchResults = filteredResults;
    });
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

            // Claim/Report Button
            _buildActionButton(business),
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
        _allResults.clear();
        _searchSuggestions.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchSuggestions = AICategoryService.getSmartSearchSuggestions(query);
    });

    try {
      // Search using Google Places API
      print('🔍 Searching Google Places for: $query in $_currentCity');

      final results = await GooglePlacesService.searchBusinesses(
        query: query,
        city: _currentCity,
      );

      // Apply AI category filtering and ranking
      final rankedResults = AICategoryService.rankBusinesses(results, query);
      final filteredResults = AICategoryService.filterByCategory(rankedResults, _selectedCategory);

      setState(() {
        _isSearching = false;
        _allResults = rankedResults;
        _searchResults = filteredResults;
      });

      print('✅ Found ${_searchResults.length} businesses');
    } catch (e) {
      print('❌ Search error: $e');

      // Fallback to mock results
      final fallbackResults = _getMockSearchResults(query);
      final rankedResults = AICategoryService.rankBusinesses(fallbackResults, query);
      final filteredResults = AICategoryService.filterByCategory(rankedResults, _selectedCategory);

      setState(() {
        _isSearching = false;
        _allResults = rankedResults;
        _searchResults = filteredResults;
      });
    }
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

  // 🔥 BUILD ACTION BUTTON 🔥
  Widget _buildActionButton(Map<String, dynamic> business) {
    final isClaimed = business['is_claimed'] ?? false;

    if (isClaimed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Claimed Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified,
                  color: Colors.green,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  'Claimed',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Report Button
          GestureDetector(
            onTap: () => _navigateToReportBusiness(business),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.report_outlined,
                    color: Colors.red,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Report',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // Claim Button
      return Container(
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
      );
    }
  }

  // 🔥 NAVIGATE TO BUSINESS PROFILE 🔥
  void _navigateToBusinessProfile(Map<String, dynamic> business) {
    final isClaimed = business['is_claimed'] ?? false;

    if (isClaimed) {
      // Show claimed business info dialog
      _showClaimedBusinessDialog(business);
    } else {
      // Navigate to claim flow
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClaimBusinessProfilePage(business: business),
        ),
      );
    }
  }

  // 🔥 NAVIGATE TO REPORT BUSINESS 🔥
  void _navigateToReportBusiness(Map<String, dynamic> business) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportClaimedBusinessPage(business: business),
      ),
    );
  }

  // 🔥 SHOW CLAIMED BUSINESS DIALOG 🔥
  void _showClaimedBusinessDialog(Map<String, dynamic> business) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.gradientStart.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Business Already Claimed',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This business has already been claimed by:',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            if (business['claimed_by'] != null) ...[
              Text(
                '• Owner: ${business['claimed_by']['owner_name']}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '• Status: ${business['claimed_by']['verification_status']}',
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'If you believe this is incorrect, you can report this business.',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToReportBusiness(business);
            },
            child: Text(
              'Report',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
