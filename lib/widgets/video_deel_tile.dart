import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/deel_model.dart';
import 'countdown_timer_widget.dart';
import 'trending_badge.dart';

class VideoDeelTile extends StatefulWidget {
  final DeelModel deel;
  final dynamic videoController; // Placeholder for now
  final bool isActive;
  final Animation<double> trendingAnimation;
  final Animation<double> likeAnimation;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onComment;
  final VoidCallback onClaim;
  final VoidCallback onAskAI;

  const VideoDeelTile({
    super.key,
    required this.deel,
    this.videoController,
    required this.isActive,
    required this.trendingAnimation,
    required this.likeAnimation,
    required this.onLike,
    required this.onShare,
    required this.onComment,
    required this.onClaim,
    required this.onAskAI,
  });

  @override
  State<VideoDeelTile> createState() => _VideoDeelTileState();
}

class _VideoDeelTileState extends State<VideoDeelTile>
    with TickerProviderStateMixin {
  late AnimationController _claimController;
  late AnimationController _heartController;
  late Animation<double> _claimAnimation;
  late Animation<double> _heartAnimation;

  bool _isLiked = false;
  bool _isClaimed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _claimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _claimAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _claimController, curve: Curves.elasticOut),
    );
    _heartAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _claimController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // 🎥 VIDEO PLAYER 🎥
          _buildVideoPlayer(),

          // 🌟 GRADIENT OVERLAY 🌟
          _buildGradientOverlay(),

          // 🔥 TRENDING BADGE 🔥
          if (widget.deel.isTrending) _buildTrendingBadge(),

          // ⏰ COUNTDOWN TIMER ⏰
          _buildCountdownTimer(),

          // 📱 RIGHT SIDE ACTIONS 📱
          _buildRightActions(),

          // 📝 BOTTOM INFO 📝
          _buildBottomInfo(),

          // ✅ CLAIM BUTTON ✅
          _buildClaimButton(),
        ],
      ),
    );
  }

  // 🎥 BUILD VIDEO PLAYER 🎥
  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.deel.thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Video overlay effect
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          // Play button overlay
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🌟 BUILD GRADIENT OVERLAY 🌟
  Widget _buildGradientOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 0.4, 0.8, 1.0],
        ),
      ),
    );
  }

  // 🔥 BUILD TRENDING BADGE 🔥
  Widget _buildTrendingBadge() {
    return Positioned(
      top: 60,
      left: 16,
      child: AnimatedBuilder(
        animation: widget.trendingAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.trendingAnimation.value,
            child: TrendingBadge(),
          );
        },
      ),
    );
  }

  // ⏰ BUILD COUNTDOWN TIMER ⏰
  Widget _buildCountdownTimer() {
    return Positioned(
      top: widget.deel.isTrending ? 110 : 60,
      left: 16,
      child: CountdownTimerWidget(
        expiry: widget.deel.expiry,
        isExpired: widget.deel.isExpired,
      ),
    );
  }

  // 📱 BUILD RIGHT ACTIONS 📱
  Widget _buildRightActions() {
    return Positioned(
      right: 16,
      bottom: 200,
      child: Column(
        children: [
          // ❤️ LIKE BUTTON ❤️
          _buildActionButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
            count: widget.deel.likes + (_isLiked ? 1 : 0),
            color: _isLiked ? Colors.red : Colors.white,
            onTap: () {
              setState(() => _isLiked = !_isLiked);
              _heartController.forward().then(
                (_) => _heartController.reverse(),
              );
              widget.onLike();
            },
            animation: _heartAnimation,
          ),

          const SizedBox(height: 20),

          // 💬 COMMENT BUTTON 💬
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            count: widget.deel.comments,
            color: Colors.white,
            onTap: widget.onComment,
          ),

          const SizedBox(height: 20),

          // 🔁 SHARE BUTTON 🔁
          _buildActionButton(
            icon: Icons.share,
            count: widget.deel.shares,
            color: Colors.white,
            onTap: widget.onShare,
          ),

          const SizedBox(height: 20),

          // 🤖 ASK AI BUTTON 🤖
          _buildAIButton(),
        ],
      ),
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

  // 🤖 BUILD AI BUTTON 🤖
  Widget _buildAIButton() {
    return GestureDetector(
      onTap: widget.onAskAI,
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
    );
  }

  // 📝 BUILD BOTTOM INFO 📝
  Widget _buildBottomInfo() {
    return Positioned(
      left: 16,
      right: 80,
      bottom: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏪 STORE NAME 🏪
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
                    widget.deel.storeInitial,
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
                  widget.deel.store,
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
            widget.deel.offer,
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
          if (widget.deel.originalPrice > 0) _buildPriceInfo(),

          const SizedBox(height: 8),

          // 🏷️ TAGS 🏷️
          if (widget.deel.tags.isNotEmpty) _buildTags(),
        ],
      ),
    );
  }

  // 💰 BUILD PRICE INFO 💰
  Widget _buildPriceInfo() {
    return Row(
      children: [
        Text(
          '₹${widget.deel.discountedPrice.toInt()}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '₹${widget.deel.originalPrice.toInt()}',
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
            '${widget.deel.discountPercentage}% OFF',
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

  // 🏷️ BUILD TAGS 🏷️
  Widget _buildTags() {
    return Wrap(
      spacing: 6,
      children: widget.deel.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#$tag',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ✅ BUILD CLAIM BUTTON ✅
  Widget _buildClaimButton() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 40,
      child: AnimatedBuilder(
        animation: _claimAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _claimAnimation.value,
            child: GestureDetector(
              onTap: widget.deel.canClaim && !_isClaimed ? _handleClaim : null,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: widget.deel.canClaim && !_isClaimed
                      ? AppColors.primaryGradient
                      : LinearGradient(
                          colors: [Colors.grey.shade600, Colors.grey.shade700],
                        ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: widget.deel.canClaim && !_isClaimed
                      ? [
                          BoxShadow(
                            color: AppColors.gradientStart.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: _isClaimed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Claimed!',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          widget.deel.canClaim
                              ? 'Claim Offer'
                              : widget.deel.isExpired
                              ? 'Expired'
                              : 'Out of Stock',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ HANDLE CLAIM ✅
  void _handleClaim() {
    setState(() => _isClaimed = true);
    _claimController.forward().then((_) => _claimController.reverse());
    widget.onClaim();
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
