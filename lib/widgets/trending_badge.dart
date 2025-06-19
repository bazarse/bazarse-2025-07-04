import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class TrendingBadge extends StatefulWidget {
  const TrendingBadge({super.key});

  @override
  State<TrendingBadge> createState() => _TrendingBadgeState();
}

class _TrendingBadgeState extends State<TrendingBadge>
    with TickerProviderStateMixin {
  
  late AnimationController _fireController;
  late AnimationController _glowController;
  late Animation<double> _fireAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fireController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fireAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _fireController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _fireController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fireController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fireAnimation, _glowAnimation]),
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B35).withValues(alpha: _glowAnimation.value),
                const Color(0xFFFF8E53).withValues(alpha: _glowAnimation.value),
                const Color(0xFFFFB347).withValues(alpha: _glowAnimation.value),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B35).withValues(alpha: _glowAnimation.value * 0.6),
                blurRadius: 12 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: _fireAnimation.value,
                child: const Text(
                  '🔥',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Trending',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
