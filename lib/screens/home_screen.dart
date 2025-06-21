import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/extraordinary_video_player.dart';
import '../services/location_service.dart';
import '../services/enhanced_location_service.dart';
import '../widgets/universal_location_modal.dart';
import '../models/location_context.dart';
import 'menu_page.dart';
import 'explore_page.dart';
import 'ai_page.dart';
import 'nearby_page.dart';
import 'deals_page.dart';
import 'bazarse_search_screen.dart';
import '../widgets/modern_bottom_nav.dart';
import 'ultra_location_screen.dart';
import 'claim_business_search_page.dart';

/// Outstanding Home Screen - Vinu Bhaisahab's Premium App 🚀
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _currentLocation = 'Getting location...';
  final int _selectedHeaderStyle = 1; // ULTIMATE FUTURISTIC HEADER DESIGN

  // 🔥 REMOVED OLD NAVIGATION VARIABLES 🔥

  // 🔥 SEARCH ANIMATION VARIABLES 🔥
  late AnimationController _searchAnimationController;
  late Animation<double> _searchFadeAnimation;
  int _currentSearchIndex = 0;



  // Auto-changing search suggestions
  final List<String> _searchSuggestions = [
    'Mobile under ₹10,000',
    'Fresh fruits near me',
    'AC repair in Ujjain',
    'Kurti shop Indore',
    'Discounted grocery items',
    'Tiffin service daily',
    'Home salon for women',
    'Refill gas cylinder',
    'Laptop accessories',
    'Kids toys shop',
    'Best deals around you',
    'Trending offers in your colony',
    '₹99 deals today',
    'Nearby open stores now',
    'Free delivery today',
    'Brands giving cashback',
    'Bhopal Kirana stores',
    'Indore Bada Bazar offers',
    'Book plumber today',
    'Schedule AC service',
    'Get a haircut now',
    'Order veg thali',
    'Recharge Jio plan',
    'Pay electricity bill',
    '50% off mobile covers',
    'Flat ₹200 cashback on beauty',
    'Buy 1 get 1 free snacks',
    'Use coupon "LOCAL20"',
    'Bazar Se verified shops',
    'Chat with Bazar AI',
    'Top 10 deals today',
    'Hot offers under ₹100',
  ];

  @override
  void initState() {
    super.initState();

    // Get current location
    _getCurrentLocation();

    // Removed old navigation animation code

    // Initialize search animation controller
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchFadeAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );

    // Start search text animation
    _startSearchAnimation();
  }

  // 📍 GET CURRENT LOCATION - SIMPLE & WORKING 📍
  Future<void> _getCurrentLocation() async {
    try {
      final locationData =
          await LocationService.getCurrentLocationWithAddress();
      if (locationData['success'] && mounted) {
        setState(() {
          _currentLocation = locationData['address'];
        });
        print('✅ Location updated: ${locationData['address']}');
      } else {
        setState(() {
          _currentLocation = 'Connaught Place, Delhi'; // Fallback
        });
      }
    } catch (e) {
      print('❌ Error getting location: $e');
      if (mounted) {
        setState(() {
          _currentLocation = 'Connaught Place, Delhi'; // Fallback
        });
      }
    }
  }

  void _startSearchAnimation() {
    _searchAnimationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          _searchAnimationController.reverse().then((_) {
            setState(() {
              _currentSearchIndex =
                  (_currentSearchIndex + 1) % _searchSuggestions.length;
            });
            _startSearchAnimation();
          });
        }
      });
    });
  }



  @override
  void dispose() {
    _searchAnimationController.dispose();
    super.dispose();
  }

  Future<void> _openLocationSelection() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UniversalLocationModal(
        title: 'Select Your Location',
        subtitle: 'Choose your location for personalized offers and delivery',
        onLocationSelected: (LocationContext location) {
          setState(() {
            _currentLocation = location.homeDisplayFormat;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(child: SizedBox.expand()),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Sleek Professional Header - Outstanding Design! 🔥
                  _buildSleekHeader(),

                  const SizedBox(height: 20),

                  // 🔥 EXTRAORDINARY VIDEO PLAYER 🔥
                  const ExtraordinaryVideoPlayer(),

                  const SizedBox(height: 30),

                  // 🔥 CLAIM YOUR BUSINESS BANNER 🔥
                  _buildClaimBusinessBanner(),

                  const SizedBox(height: 20),

                  // Main Content Area - Clean and Minimal
                  const SizedBox(height: 50),

                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
      // 🔥 MODERN BOTTOM NAV 🔥
      bottomNavigationBar: const ModernBottomNav(currentIndex: 0),
    );
  }

  // 🔥 ULTRA COMPACT & SHORT HEADER 🔥
  Widget _buildSleekHeader() {
    return Container(
      height: 100, // Much bigger header
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), // More vertical padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientStart.withValues(alpha: 0.1),
            AppColors.gradientMiddle.withValues(alpha: 0.05),
            AppColors.gradientEnd.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo Row
          Row(
            children: [
              // Logo with perfect alignment
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Bazar',
                    style: GoogleFonts.inter(
                      fontSize: 18, // Much smaller font
                      fontWeight: FontWeight.w800,
                      height: 0.9, // Tighter line height
                      foreground: Paint()
                        ..shader = AppColors.primaryGradient.createShader(
                          const Rect.fromLTWH(0, 0, 80, 25),
                        ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ), // Reduced space for better alignment
                  Text(
                    'से',
                    style: GoogleFonts.inter(
                      fontSize: 18, // Much smaller font
                      fontWeight: FontWeight.w800,
                      height: 0.9, // Tighter line height
                      foreground: Paint()
                        ..shader = AppColors.primaryGradient.createShader(
                          const Rect.fromLTWH(0, 0, 80, 25),
                        ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Notification Icon
              _buildCompactIcon(Icons.notifications_outlined),
              const SizedBox(width: 8),
              // 3-dot menu
              _buildCompactIcon(Icons.more_vert),
            ],
          ),

          const SizedBox(height: 4), // Better spacing
          // Location Row - Below Logo
          GestureDetector(
            onTap: () => _openLocationSelection(),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.gradientStart,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentLocation,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10, // Much smaller font
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6), // Better spacing
          // Animated Search Bar - Wrapped in Flexible to prevent overflow
          Flexible(child: _buildAnimatedSearchBar()),
        ],
      ),
    );
  }



  // 🔥 CLAIM YOUR BUSINESS BANNER 🔥
  Widget _buildClaimBusinessBanner() {
    return GestureDetector(
      onTap: () => _navigateToClaimBusiness(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0070FF).withValues(alpha: 0.9),
              const Color(0xFF7D30F5).withValues(alpha: 0.8),
              const Color(0xFFFF2EB4).withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0070FF).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 3,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side - Business icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            // Middle - Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Claim Your Business',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'in 2 min and get upto ₹5000 free credits',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Are you a business owner?',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Right side - Arrow
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 NAVIGATE TO CLAIM BUSINESS 🔥
  void _navigateToClaimBusiness() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClaimBusinessSearchPage()),
    );
  }





  // 🔥 AMAZING SEARCH BAR WITH AUTO-SUGGESTIONS 🔥
  Widget _buildAnimatedSearchBar() {
    return GestureDetector(
      onTap: _showSearchSuggestions,
      child: Container(
        height: 40, // Bigger search bar height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Rectangular border
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart.withValues(alpha: 0.6),
              AppColors.gradientMiddle.withValues(alpha: 0.4),
              AppColors.gradientEnd.withValues(alpha: 0.6),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: AppColors.primaryBlack.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(6), // Rectangular border
          ),
          child: Row(
            children: [
              const SizedBox(width: 12), // Reduced spacing
              Icon(
                Icons.search,
                color: Colors.white.withValues(alpha: 0.7),
                size: 18,
              ),
              const SizedBox(width: 8), // Reduced spacing
              Expanded(
                child: AnimatedBuilder(
                  animation: _searchFadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _searchFadeAnimation.value,
                      child: Text(
                        _searchSuggestions[_currentSearchIndex],
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11, // Even smaller font
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Voice Search Icon
              GestureDetector(
                onTap: _showVoiceComingSoon,
                child: Container(
                  padding: const EdgeInsets.all(6), // Reduced padding
                  child: Icon(
                    Icons.mic,
                    color: AppColors.gradientStart,
                    size: 18,
                  ),
                ),
              ),
              // Camera Search Icon
              GestureDetector(
                onTap: _showCameraComingSoon,
                child: Container(
                  padding: const EdgeInsets.all(6), // Reduced padding
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.gradientStart,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 6), // Reduced spacing
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 AMAZING SEARCH SUGGESTIONS SCREEN 🔥
  void _showSearchSuggestions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BazarseSearchScreen()),
    );
  }

  // 🔥 COMING SOON DIALOGS 🔥
  void _showVoiceComingSoon() {
    _showComingSoonDialog(
      'Voice Search',
      'Voice search feature is coming soon!',
    );
  }

  void _showCameraComingSoon() {
    _showComingSoonDialog(
      'Camera Search',
      'Camera search feature is coming soon!',
    );
  }

  void _showComingSoonDialog(String title, String message) {
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
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.inter(
                color: AppColors.gradientStart,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 COMPACT ICON WIDGET 🔥
  Widget _buildCompactIcon(IconData icon) {
    return GestureDetector(
      onTap: icon == Icons.more_vert ? _showCompactMenu : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  // 🔥 MENU PAGE - INSTEAD OF POPUP 🔥
  void _showCompactMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuPage()),
    );
  }

  Widget _buildCompactMenuOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withValues(alpha: 0.6),
            size: 12,
          ),
        ],
      ),
    );
  }

  // 🔥 ULTRA COMPACT BOTTOM NAVIGATION - NO BLUE OUTLINE 🔥
  Widget _buildSleekBottomNav() {
    return Container(
      height: 72, // Increased by 20% (60 * 1.2 = 72)
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlack.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(12),
        // Removed blue border outline
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
          // Subtle shadow only
          BoxShadow(
            color: AppColors.gradientStart.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 🔥 OLD NAVIGATION REMOVED - USING NEW MODERN NAV 🔥
        ],
      ),
    );
  }

  // 🔥 OLD NAVIGATION CODE REMOVED 🔥

  // 🔥 OLD NAVIGATION CODE REMOVED 🔥

  // Category Item Builder
  Widget _buildCategoryItem(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Featured Store Builder
  Widget _buildFeaturedStore(int index) {
    final stores = ['Store A', 'Store B', 'Store C', 'Store D', 'Store E'];
    final icons = [
      Icons.store,
      Icons.restaurant,
      Icons.local_grocery_store,
      Icons.medical_services,
      Icons.shopping_bag,
    ];

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icons[index], color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            stores[index],
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicHeaderStyle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: _getHeaderDecoration(_selectedHeaderStyle),
      child: TextField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search for products, stores...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  // 🔥 ULTIMATE FIXED HEADER DESIGN - NO CORNERS! 🔥
  BoxDecoration _getHeaderDecoration(int styleNumber) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.gradientStart.withValues(alpha: 0.4),
          AppColors.gradientMiddle.withValues(alpha: 0.3),
          AppColors.gradientEnd.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      // NO BORDER RADIUS - FIXED CORNERS!
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          blurRadius: 25,
          spreadRadius: 3,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.gradientEnd.withValues(alpha: 0.2),
          blurRadius: 35,
          spreadRadius: 5,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  BoxDecoration _getHeaderBackgroundDecoration(int styleNumber) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
    );
  }

  Widget _buildDynamicThreeDotsMenu() {
    return GestureDetector(
      onTap: _showUltimateVerticalMenu,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientStart.withValues(alpha: 0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(Icons.more_vert, color: Colors.white, size: 24),
      ),
    );
  }

  // 🔥 ULTIMATE VERTICAL MENU - 3 DIFFERENT STYLES! 🔥
  int _currentMenuStyle = 1;

  void _showUltimateVerticalMenu() {
    // Cycle through 3 different menu styles
    _currentMenuStyle = (_currentMenuStyle % 3) + 1;

    switch (_currentMenuStyle) {
      case 1:
        _showGradientSlideMenu();
        break;
      case 2:
        _showNeonGlowMenu();
        break;
      case 3:
        _showHolographicMenu();
        break;
    }
  }

  // Style 1: Gradient Slide Menu
  void _showGradientSlideMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientStart.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuOption(Icons.receipt_long, 'Claims'),
                  _buildMenuOption(Icons.chat_bubble_outline, 'Chats'),
                  _buildMenuOption(Icons.settings_outlined, 'Settings'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Style 2: Neon Glow Menu
  void _showNeonGlowMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF00FFFF), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFFF).withValues(alpha: 0.6),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuOption(Icons.receipt_long, 'Claims'),
                  _buildMenuOption(Icons.chat_bubble_outline, 'Chats'),
                  _buildMenuOption(Icons.settings_outlined, 'Settings'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Style 3: Holographic Menu
  void _showHolographicMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: FadeTransition(
            opacity: animation,
            child: Transform.scale(
              scale: animation.value,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0x40FFFFFF),
                      Color(0x20FF00FF),
                      Color(0x4000FFFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuOption(Icons.receipt_long, 'Claims'),
                    _buildMenuOption(Icons.chat_bubble_outline, 'Chats'),
                    _buildMenuOption(Icons.settings_outlined, 'Settings'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withValues(alpha: 0.7),
            size: 16,
          ),
        ],
      ),
    );
  }

  // 🔥 OLD NAVIGATION CODE REMOVED 🔥

  // 🔥 OLD NAVIGATION DECORATION CODE REMOVED 🔥
  BoxDecoration _getBottomNavDecoration(int style) {
    switch (style) {
      case 1: // Gradient Glow
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart.withValues(alpha: 0.9),
              AppColors.gradientMiddle.withValues(alpha: 0.8),
              AppColors.gradientEnd.withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientStart.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 2: // Neon Pulse
        return BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF00FFFF), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FFFF).withValues(alpha: 0.5),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        );
      case 3: // Glass Morph
        return BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 4: // Fire Phoenix
        return BoxDecoration(
          gradient: const RadialGradient(
            colors: [Color(0xFFFF4500), Color(0xFFFF6347), Color(0xFFFFD700)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4500).withValues(alpha: 0.5),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        );
      case 5: // Ice Crystal
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF83a4d4), Color(0xFFb6fbff)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFb6fbff).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 6: // Matrix Code
        return BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF00FF00), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF00).withValues(alpha: 0.5),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        );
      case 7: // Plasma Flow
        return BoxDecoration(
          gradient: const RadialGradient(
            colors: [Color(0xFFFF0080), Color(0xFF7928CA), Color(0xFF0070F3)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF0080).withValues(alpha: 0.5),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        );
      case 8: // Quantum Flux
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 9: // Cosmic Storm
        return BoxDecoration(
          gradient: const SweepGradient(
            colors: [
              Color(0xFF8A2387),
              Color(0xFFE94057),
              Color(0xFFF27121),
              Color(0xFF8A2387),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8A2387).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 10: // Neural Network
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F3460), Color(0xFF16537e), Color(0xFF533483)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF00D4FF), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        );
      case 11: // Liquid Metal
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF), Color(0xFFC4E0E1)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CA1AF).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 12: // Void Portal
        return BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF1A0033),
              Color(0xFF4A0080),
              Color(0xFF8A2BE2),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF8A2BE2), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.5),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        );
      case 13: // Crystal Prism
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFE5B4),
              Color(0xFFFFCCE5),
              Color(0xFFE5CCFF),
              Color(0xFFCCE5FF),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 14: // Thunder Storm
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298), Color(0xFFFFFF00)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFFFFF00), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFFF00).withValues(alpha: 0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        );
      case 15: // Galaxy Spiral
        return BoxDecoration(
          gradient: const SweepGradient(
            colors: [
              Color(0xFF000428),
              Color(0xFF004e92),
              Color(0xFF009ffd),
              Color(0xFF00d2ff),
              Color(0xFF000428),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF00d2ff), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00d2ff).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 16: // Neon City
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFFF0080), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF0080).withValues(alpha: 0.4),
              blurRadius: 25,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: const Color(0xFF00FFFF).withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        );
      case 17: // Aurora Wave
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2), Color(0xFFFF6B6B)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A00E0).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 18: // Hologram
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.gradientStart.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.gradientStart, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientStart.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        );
      case 19: // Cyber Tech
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF00FFFF), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FFFF).withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
      case 20: // Quantum Void
        return BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF533483), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF533483).withValues(alpha: 0.4),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        );
      default:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStart.withValues(alpha: 0.9),
              AppColors.gradientMiddle.withValues(alpha: 0.8),
              AppColors.gradientEnd.withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientStart.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        );
    }
  }

  // 🔥 OLD NAVIGATION CODE REMOVED 🔥
}
