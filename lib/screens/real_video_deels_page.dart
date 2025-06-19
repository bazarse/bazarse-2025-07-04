import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../models/deel_model.dart';
import '../services/pexels_video_service.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';

class RealVideoDeelsPage extends StatefulWidget {
  final String? category;
  final bool isLive;

  const RealVideoDeelsPage({super.key, this.category, this.isLive = false});

  @override
  State<RealVideoDeelsPage> createState() => _RealVideoDeelsPageState();
}

class _RealVideoDeelsPageState extends State<RealVideoDeelsPage>
    with TickerProviderStateMixin {
  // 📱 STATE VARIABLES 📱
  List<DeelModel> _deels = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  PageController _pageController = PageController();

  // 🎬 VIDEO CONTROLLERS 🎬
  Map<int, VideoPlayerController> _videoControllers = {};
  VideoPlayerController? _currentVideoController;

  // 🎭 ANIMATION CONTROLLERS 🎭
  late AnimationController _likeAnimationController;
  late AnimationController _heartAnimationController;
  late Animation<double> _likeAnimation;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadRealVideoDeels();
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    _heartAnimationController.dispose();
    _pageController.dispose();
    _disposeVideoControllers();
    super.dispose();
  }

  // 🎭 INITIALIZE ANIMATIONS 🎭
  void _initializeAnimations() {
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _likeAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _heartAnimation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  // 🎬 DISPOSE VIDEO CONTROLLERS 🎬
  void _disposeVideoControllers() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
  }

  // 📱 LOAD REAL VIDEO DEELS 📱
  Future<void> _loadRealVideoDeels() async {
    print('🎬 Starting to load real video deels...');
    setState(() => _isLoading = true);

    try {
      print('🔍 Fetching deels for category: ${widget.category}');
      final deels = await PexelsVideoService.fetchRealVideoDeels(
        category: widget.category,
        city: 'Ujjain',
        limit: 20,
      );

      print('✅ Received ${deels.length} deels from API');
      setState(() {
        _deels = deels;
        _isLoading = false;
      });

      // Initialize first few video controllers
      _initializeVideoControllers();
    } catch (e) {
      print('❌ Error loading real video deels: $e');
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load videos: $e');
    }
  }

  // 🎬 INITIALIZE VIDEO CONTROLLERS 🎬
  void _initializeVideoControllers() {
    // Initialize controllers for first 3 videos
    for (int i = 0; i < _deels.length && i < 3; i++) {
      _createVideoController(i);
    }

    // Play first video
    if (_deels.isNotEmpty) {
      _playVideoAtIndex(0);
    }
  }

  // 🎬 CREATE VIDEO CONTROLLER 🎬
  void _createVideoController(int index) {
    if (_videoControllers.containsKey(index)) return;

    final videoUrl = _deels[index].videoUrl;
    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    _videoControllers[index] = controller;

    controller
        .initialize()
        .then((_) {
          if (mounted) {
            setState(() {});
            // Auto-play if this is the current video
            if (index == _currentIndex) {
              controller.play();
              controller.setLooping(true);
              _currentVideoController = controller;
            }
          }
        })
        .catchError((error) {
          print('🚨 Error initializing video $index: $error');
        });
  }

  // 🎬 PLAY VIDEO AT INDEX 🎬
  void _playVideoAtIndex(int index) {
    // Pause current video
    _currentVideoController?.pause();

    // Create controller if not exists
    if (!_videoControllers.containsKey(index)) {
      _createVideoController(index);
    }

    // Play new video
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isInitialized) {
      controller.play();
      controller.setLooping(true);
      _currentVideoController = controller;
    }

    // Preload next videos
    _preloadNextVideos(index);
  }

  // 🔄 PRELOAD NEXT VIDEOS 🔄
  void _preloadNextVideos(int currentIndex) {
    // Preload next 2 videos
    for (int i = 1; i <= 2; i++) {
      final nextIndex = currentIndex + i;
      if (nextIndex < _deels.length &&
          !_videoControllers.containsKey(nextIndex)) {
        _createVideoController(nextIndex);
      }
    }

    // Dispose old controllers to save memory
    final indicesToRemove = <int>[];
    for (int index in _videoControllers.keys) {
      if ((index < currentIndex - 1) || (index > currentIndex + 3)) {
        indicesToRemove.add(index);
      }
    }

    for (int index in indicesToRemove) {
      _videoControllers[index]?.dispose();
      _videoControllers.remove(index);
    }
  }

  // 📱 BUILD UI 📱
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🌟 ANIMATED BACKGROUND 🌟
          const AnimatedBackground(child: SizedBox.expand()),

          // 📱 MAIN CONTENT 📱
          if (_isLoading)
            _buildLoadingScreen()
          else if (_deels.isEmpty)
            _buildEmptyScreen()
          else
            _buildVideoPageView(),

          // 🔝 TOP OVERLAY 🔝
          _buildTopOverlay(),
        ],
      ),
    );
  }

  // ⏳ BUILD LOADING SCREEN ⏳
  Widget _buildLoadingScreen() {
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
            'Loading Real Videos...',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fetching from Pexels API',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 📭 BUILD EMPTY SCREEN 📭
  Widget _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No Videos Available',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try refreshing or check your connection',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadRealVideoDeels,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gradientStart,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🎬 BUILD VIDEO PAGE VIEW 🎬
  Widget _buildVideoPageView() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _deels.length,
      onPageChanged: (index) {
        setState(() => _currentIndex = index);
        _playVideoAtIndex(index);
      },
      itemBuilder: (context, index) {
        return _buildVideoPage(_deels[index], index);
      },
    );
  }

  // 🎬 BUILD VIDEO PAGE 🎬
  Widget _buildVideoPage(DeelModel deel, int index) {
    final controller = _videoControllers[index];

    return GestureDetector(
      onDoubleTap: () => _onDoubleTap(deel),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🎬 VIDEO PLAYER 🎬
          if (controller != null && controller.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            )
          else
            Container(
              color: Colors.grey.shade900,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

          // 🎬 PLAY/PAUSE OVERLAY 🎬
          if (controller != null && controller.value.isInitialized)
            Center(
              child: GestureDetector(
                onTap: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                  setState(() {});
                },
                child: AnimatedOpacity(
                  opacity: controller.value.isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

          // 📱 RIGHT SIDE ACTIONS 📱
          Positioned(right: 16, bottom: 120, child: _buildRightActions(deel)),

          // 📝 BOTTOM INFO 📝
          Positioned(
            left: 16,
            right: 80,
            bottom: 40,
            child: _buildBottomInfo(deel),
          ),

          // 💖 FLOATING HEART ANIMATION 💖
          if (_heartAnimationController.isAnimating)
            Positioned(
              right: 80,
              bottom: 200,
              child: AnimatedBuilder(
                animation: _heartAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _heartAnimation.value,
                    child: Opacity(
                      opacity: 1.0 - _heartAnimation.value,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 100,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // 🔝 BUILD TOP OVERLAY 🔝
  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
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
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
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
                child: Text(
                  widget.isLive ? 'Live Shopping' : 'Real Video Deels',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // 📊 COUNTER 📊
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentIndex + 1}/${_deels.length}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📱 BUILD RIGHT ACTIONS 📱
  Widget _buildRightActions(DeelModel deel) {
    return Column(
      children: [
        // ❤️ LIKE BUTTON ❤️
        _buildActionButton(
          icon: Icons.favorite,
          count: deel.likes,
          color: Colors.red,
          onTap: () => _onLike(deel),
          animation: _likeAnimation,
        ),
        const SizedBox(height: 20),
        // 💬 COMMENT BUTTON 💬
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          count: deel.comments,
          color: Colors.white,
          onTap: () => _onComment(deel),
        ),
        const SizedBox(height: 20),
        // 🔁 SHARE BUTTON 🔁
        _buildActionButton(
          icon: Icons.share,
          count: deel.shares,
          color: Colors.white,
          onTap: () => _onShare(deel),
        ),
        const SizedBox(height: 20),
        // 🤖 ASK AI BUTTON 🤖
        GestureDetector(
          onTap: () => _onAskAI(deel),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradientStart.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  // 🎯 BUILD ACTION BUTTON 🎯
  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
    Animation<double>? animation,
  }) {
    Widget button = GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCount(count),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(scale: animation.value, child: button);
        },
      );
    }
    return button;
  }

  // 📝 BUILD BOTTOM INFO 📝
  Widget _buildBottomInfo(DeelModel deel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏪 STORE INFO 🏪
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  deel.storeInitial,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                deel.store,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 🎯 OFFER TITLE 🎯
        Text(
          deel.offer,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // 💰 PRICE INFO 💰
        if (deel.originalPrice > 0) _buildPriceInfo(deel),
        const SizedBox(height: 12),
        // ⏰ COUNTDOWN & TRENDING 🔥
        Row(
          children: [
            if (deel.isTrending) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFFB347)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🔥 Trending',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (!deel.isExpired)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  deel.timeLeftString,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // ✅ CLAIM BUTTON ✅
        GestureDetector(
          onTap: deel.canClaim ? () => _onClaim(deel) : null,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: deel.canClaim
                  ? AppColors.primaryGradient
                  : LinearGradient(
                      colors: [Colors.grey.shade600, Colors.grey.shade700],
                    ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: deel.canClaim
                  ? [
                      BoxShadow(
                        color: AppColors.gradientStart.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                deel.canClaim
                    ? 'Claim Offer'
                    : deel.isExpired
                    ? 'Expired'
                    : 'Out of Stock',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 💰 BUILD PRICE INFO 💰
  Widget _buildPriceInfo(DeelModel deel) {
    return Row(
      children: [
        Text(
          '₹${deel.discountedPrice.toInt()}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '₹${deel.originalPrice.toInt()}',
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${deel.discountPercentage}% OFF',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
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

  // 💖 ON DOUBLE TAP 💖
  void _onDoubleTap(DeelModel deel) {
    _onLike(deel);
    _heartAnimationController.forward().then((_) {
      _heartAnimationController.reset();
    });
  }

  // ❤️ ON LIKE ❤️
  void _onLike(DeelModel deel) {
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });

    // Note: DeelModel likes is final, so we'll just show animation
    // In real app, this would call API to update likes

    _showSnackBar('❤️ Liked ${deel.store}!');
  }

  // 💬 ON COMMENT 💬
  void _onComment(DeelModel deel) {
    _showSnackBar('💬 Comments coming soon!');
  }

  // 🔁 ON SHARE 🔁
  void _onShare(DeelModel deel) {
    _showSnackBar('🔁 Shared ${deel.offer}!');
  }

  // 🤖 ON ASK AI 🤖
  void _onAskAI(DeelModel deel) {
    _showSnackBar('🤖 AI Chat coming soon!');
  }

  // ✅ ON CLAIM ✅
  void _onClaim(DeelModel deel) {
    _showSnackBar('✅ Offer claimed! Visit ${deel.store}');
  }

  // 📱 SHOW SNACK BAR 📱
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.gradientStart,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // 🚨 SHOW ERROR SNACK BAR 🚨
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
