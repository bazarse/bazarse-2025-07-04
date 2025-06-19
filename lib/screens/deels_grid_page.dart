import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../models/deel_model.dart';
import '../services/enhanced_deels_api_service.dart';
import 'real_video_deels_page.dart';

class DeelsGridPage extends StatefulWidget {
  final bool isLive;

  const DeelsGridPage({super.key, required this.isLive});

  @override
  State<DeelsGridPage> createState() => _DeelsGridPageState();
}

class _DeelsGridPageState extends State<DeelsGridPage>
    with TickerProviderStateMixin {
  List<DeelModel> _deels = [];
  bool _isLoading = true;
  String _selectedCity = 'Ujjain';
  String _selectedCategory = 'All';

  late AnimationController _gridAnimationController;
  late Animation<double> _gridAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDeels();
  }

  void _initializeAnimations() {
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _gridAnimation = CurvedAnimation(
      parent: _gridAnimationController,
      curve: Curves.easeOutBack,
    );
    _gridAnimationController.forward();
  }

  Future<void> _loadDeels() async {
    setState(() => _isLoading = true);

    try {
      final deels = await EnhancedDeelsApiService.getDeels(
        city: _selectedCity,
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        isLive: widget.isLive,
        limit: 50,
      );

      setState(() {
        _deels = deels;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading deels: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _gridAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Stack(
        children: [
          // 🌟 ANIMATED BACKGROUND 🌟
          const AnimatedBackground(child: SizedBox.expand()),

          // 📱 MAIN CONTENT 📱
          SafeArea(
            child: Column(
              children: [
                // 🔝 HEADER 🔝
                _buildHeader(),

                // 🏷️ CATEGORY FILTERS 🏷️
                _buildCategoryFilters(),

                // 📱 GRID CONTENT 📱
                Expanded(
                  child: _isLoading ? _buildLoadingGrid() : _buildDeelsGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔝 BUILD HEADER 🔝
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
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

          // 🏪 TITLE 🏪
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.isLive ? 'Live Shopping' : 'Explore Deels',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.isLive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'LIVE',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  widget.isLive
                      ? 'Live video shopping streams'
                      : 'Video offers from local stores',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // 📍 CITY SELECTOR 📍
          GestureDetector(
            onTap: _showCitySelector,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _selectedCity,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🏷️ BUILD CATEGORY FILTERS 🏷️
  Widget _buildCategoryFilters() {
    final categories = [
      'All',
      'Food',
      'Fashion',
      'Electronics',
      'Grocery',
      'Others',
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
                _loadDeels();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected
                      ? null
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 📱 BUILD DEELS GRID 📱
  Widget _buildDeelsGrid() {
    if (_deels.isEmpty) {
      return _buildEmptyState();
    }

    return AnimatedBuilder(
      animation: _gridAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _deels.length,
          itemBuilder: (context, index) {
            return _buildGridItem(_deels[index], index);
          },
        ),
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _gridAnimation.value,
          child: Opacity(opacity: _gridAnimation.value, child: child),
        );
      },
    );
  }

  // 📦 BUILD GRID ITEM 📦
  Widget _buildGridItem(DeelModel deel, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RealVideoDeelsPage(
              category: null, // Show all categories
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 🖼️ THUMBNAIL/VIDEO 🖼️
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(deel.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 🌟 GRADIENT OVERLAY 🌟
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // 🔥 TRENDING BADGE 🔥
              if (deel.isTrending)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFFB347)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '🔥 Trending',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

              // 🔴 LIVE INDICATOR 🔴
              if (widget.isLive)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 📝 BOTTOM INFO 📝
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        deel.store,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        deel.offer,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatCount(deel.likes),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (!deel.isExpired)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                deel.timeLeftString,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
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
  }

  // ⏳ BUILD LOADING GRID ⏳
  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  // 📭 BUILD EMPTY STATE 📭
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.isLive ? Icons.live_tv : Icons.video_library_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 20),
          Text(
            widget.isLive ? 'No Live Streams' : 'No Deels Found',
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

  // 📍 SHOW CITY SELECTOR 📍
  void _showCitySelector() {
    // TODO: Implement city selector modal
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('City selector coming soon!')));
  }

  // 📊 FORMAT COUNT 📊
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}
