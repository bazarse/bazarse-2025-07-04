import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/video_deel_tile.dart';
import '../widgets/category_chips.dart';
import '../widgets/city_selector_dropdown.dart';
import '../models/deel_model.dart';
import '../services/deels_api_service.dart';
import '../services/pexels_video_service.dart';
import '../screens/real_video_deels_page.dart';

class DeelsPage extends StatefulWidget {
  const DeelsPage({super.key});

  @override
  State<DeelsPage> createState() => _DeelsPageState();
}

class _DeelsPageState extends State<DeelsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 🔥 STATE VARIABLES 🔥
  PageController _pageController = PageController();
  String _selectedCity = 'Ujjain';
  String _selectedCategory = 'All';
  List<DeelModel> _deels = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  // 🎬 ANIMATION CONTROLLERS 🎬
  late AnimationController _trendingController;
  late AnimationController _likeController;
  late Animation<double> _trendingAnimation;
  late Animation<double> _likeAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDeels();
  }

  // 🎨 INITIALIZE ANIMATIONS 🎨
  void _initializeAnimations() {
    _trendingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _trendingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _trendingController, curve: Curves.elasticInOut),
    );
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.elasticOut),
    );

    _trendingController.repeat(reverse: true);
  }

  // 📱 LOAD DEELS DATA 📱
  Future<void> _loadDeels() async {
    setState(() => _isLoading = true);

    try {
      // Load Real Video Deels from Pexels API
      final deels = await PexelsVideoService.fetchRealVideoDeels(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        city: _selectedCity,
        limit: 20,
      );

      setState(() {
        _deels = deels;
        _isLoading = false;
      });

      debugPrint(
        '✅ Loaded ${deels.length} real video deels for $_selectedCity',
      );
    } catch (e) {
      debugPrint('❌ Error loading real video deels: $e');
      setState(() => _isLoading = false);
    }
  }

  // 📍 CITY CHANGED 📍
  void _onCityChanged(String city) {
    setState(() => _selectedCity = city);
    _loadDeels();
  }

  // 🏷️ CATEGORY CHANGED 🏷️
  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _loadDeels();
  }

  // 📄 PAGE CHANGED 📄
  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    debugPrint('📄 Page changed to index: $index');
  }

  @override
  void dispose() {
    _trendingController.dispose();
    _likeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Stack(
        children: [
          // 🌟 ANIMATED BACKGROUND 🌟
          const AnimatedBackground(child: SizedBox.expand()),

          // 📱 MAIN CONTENT 📱
          Column(
            children: [
              // 🔝 TOP BAR 🔝
              _buildTopBar(),

              // 🏷️ CATEGORY CHIPS 🏷️
              CategoryChips(
                selectedCategory: _selectedCategory,
                onCategoryChanged: _onCategoryChanged,
              ),

              // 🎥 VIDEO FEED 🎥
              Expanded(
                child: _isLoading ? _buildLoadingState() : _buildVideoFeed(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔝 BUILD TOP BAR 🔝
  Widget _buildTopBar() {
    return SafeArea(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlack.withValues(alpha: 0.9),
              AppColors.primaryBlack.withValues(alpha: 0.7),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            // 🔙 BACK BUTTON 🔙
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 🏪 DEELS TITLE 🏪
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deels',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Hyperlocal Video Offers',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // 📍 CITY SELECTOR 📍
            CitySelectorDropdown(
              selectedCity: _selectedCity,
              onCityChanged: _onCityChanged,
            ),

            const SizedBox(width: 12),

            // 🎬 REAL VIDEO DEELS 🎬
            GestureDetector(
              onTap: _openRealVideoDeels,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // 🎙️ VOICE SEARCH 🎙️
            GestureDetector(
              onTap: _showVoiceSearch,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📱 BUILD VIDEO FEED 📱
  Widget _buildVideoFeed() {
    if (_deels.isEmpty) {
      return _buildEmptyState();
    }

    // Navigate directly to Real Video Deels page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RealVideoDeelsPage(
            category: _selectedCategory == 'All' ? null : _selectedCategory,
          ),
        ),
      );
    });

    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  // ⏳ BUILD LOADING STATE ⏳
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading amazing deals...',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 📭 BUILD EMPTY STATE 📭
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.video_library_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Deels Found',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing city or category',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // 🎬 OPEN REAL VIDEO DEELS 🎬
  void _openRealVideoDeels() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealVideoDeelsPage(
          category: _selectedCategory == 'All' ? null : _selectedCategory,
        ),
      ),
    );
  }

  // 🎙️ VOICE SEARCH 🎙️
  void _showVoiceSearch() {
    // TODO: Implement voice search
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search coming soon!'),
        backgroundColor: AppColors.gradientStart,
      ),
    );
  }

  // ❤️ LIKE ACTION ❤️
  void _onLike(int index) {
    _likeController.forward().then((_) => _likeController.reverse());
    // TODO: Implement like API
  }

  // 🔁 SHARE ACTION 🔁
  void _onShare(int index) {
    // TODO: Implement share functionality
  }

  // 💬 COMMENT ACTION 💬
  void _onComment(int index) {
    // TODO: Implement comments modal
  }

  // ✅ CLAIM ACTION ✅
  void _onClaim(int index) {
    // TODO: Implement claim offer API
  }

  // 🤖 ASK AI ACTION 🤖
  void _onAskAI(int index) {
    // TODO: Implement AI chat modal
  }
}
