import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/deel_model.dart';
import '../widgets/ai_store_chat_modal.dart';

class DeelsFullscreenPage extends StatefulWidget {
  final int initialIndex;
  final List<DeelModel> deels;
  final bool isLive;

  const DeelsFullscreenPage({
    super.key,
    required this.initialIndex,
    required this.deels,
    required this.isLive,
  });

  @override
  State<DeelsFullscreenPage> createState() => _DeelsFullscreenPageState();
}

class _DeelsFullscreenPageState extends State<DeelsFullscreenPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;

  // Animation controllers
  late AnimationController _likeAnimationController;
  late AnimationController _heartAnimationController;
  late Animation<double> _likeAnimation;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    _heartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _likeAnimationController.dispose();
    _heartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🎥 MAIN VIDEO FEED 🎥
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: widget.deels.length,
            itemBuilder: (context, index) {
              return _buildVideoPage(widget.deels[index], index);
            },
          ),

          // 🔝 TOP OVERLAY 🔝
          _buildTopOverlay(),
        ],
      ),
    );
  }

  // 🎥 BUILD VIDEO PAGE 🎥
  Widget _buildVideoPage(DeelModel deel, int index) {
    return Stack(
      children: [
        // 🖼️ VIDEO/IMAGE BACKGROUND 🖼️
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
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),

        // 🎬 PLAY BUTTON OVERLAY 🎬
        Center(
          child: GestureDetector(
            onTap: () => _playVideo(deel.videoUrl),
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

        // 🔴 LIVE INDICATOR 🔴
        if (widget.isLive)
          Positioned(
            top: 60,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'LIVE',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
                  widget.isLive ? 'Live Shopping' : 'Deels',
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
                  '${_currentIndex + 1}/${widget.deels.length}',
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

  // 🎬 PLAY VIDEO 🎬
  void _playVideo(String videoUrl) {
    // TODO: Implement video player
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening video: $videoUrl'),
        backgroundColor: AppColors.gradientStart,
      ),
    );
  }

  // ❤️ ON LIKE ❤️
  void _onLike(DeelModel deel) {
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });
    _heartAnimationController.forward().then((_) {
      _heartAnimationController.reset();
    });

    // TODO: Implement like API
    debugPrint('Liked deel: ${deel.id}');
  }

  // 💬 ON COMMENT 💬
  void _onComment(DeelModel deel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildCommentsModal(deel),
    );
  }

  // 🔁 ON SHARE 🔁
  void _onShare(DeelModel deel) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${deel.store} offer...'),
        backgroundColor: AppColors.gradientStart,
      ),
    );
  }

  // 🤖 ON ASK AI 🤖
  void _onAskAI(DeelModel deel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AiStoreChatModal(deel: deel),
    );
  }

  // ✅ ON CLAIM 🎯
  void _onClaim(DeelModel deel) {
    // TODO: Implement claim functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Claiming offer from ${deel.store}...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 💬 BUILD COMMENTS MODAL 💬
  Widget _buildCommentsModal(DeelModel deel) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.comment, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Comments',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${deel.comments}',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Comments List
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 60,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Comments Coming Soon!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interactive comments feature is under development',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
