import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import 'dart:math' as math;

class FuturisticBackground extends StatefulWidget {
  final Widget child;

  const FuturisticBackground({super.key, required this.child});

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _particleController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF000000), // Pure black background
      ),
      child: Stack(
        children: [
          // Subtle Animated Glow Orbs - Professional & Premium
          ...List.generate(2, (index) => _buildPremiumGlowOrb(index)),

          // Main Content
          widget.child,
        ],
      ),
    );
  }

  Widget _buildPremiumGlowOrb(int index) {
    final colors = [AppColors.gradientStart, AppColors.gradientMiddle];

    final positions = [const Alignment(-1.5, -1.0), const Alignment(1.5, 1.0)];

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final progress = _glowController.value;
        final opacity =
            (math.sin(progress * 2 * math.pi + index * 1.5) + 1) / 2;
        final scale = 0.6 + 0.2 * opacity;

        return Positioned.fill(
          child: Align(
            alignment: positions[index],
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors[index].withValues(alpha: 0.08 * opacity),
                      colors[index].withValues(alpha: 0.03 * opacity),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
