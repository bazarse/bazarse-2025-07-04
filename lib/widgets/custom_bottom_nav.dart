import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'dart:math' as math;
import 'dart:ui';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _aiController;
  late AnimationController _dealsController;
  late AnimationController _glowController;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _aiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _dealsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _aiController.dispose();
    _dealsController.dispose();
    _glowController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final floatOffset =
            math.sin(_floatingController.value * 2 * math.pi) * 3;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Container(
            height: 95,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: Stack(
              children: [
                // Glow Effect Background
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    final glowIntensity =
                        (math.sin(_glowController.value * 2 * math.pi) + 1) / 2;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradientStart.withValues(
                              alpha: 0.3 * glowIntensity,
                            ),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: AppColors.gradientMiddle.withValues(
                              alpha: 0.2 * glowIntensity,
                            ),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: AppColors.gradientEnd.withValues(
                              alpha: 0.1 * glowIntensity,
                            ),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Glass Morphism Container
                ClipRRect(
                  borderRadius: BorderRadius.circular(42.5),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42.5),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFuturisticNavItem(
                            index: 0,
                            icon: Icons.home_outlined,
                            activeIcon: Icons.home_rounded,
                            label: 'Home',
                          ),
                          _buildFuturisticNavItem(
                            index: 1,
                            icon: Icons.explore_outlined,
                            activeIcon: Icons.explore_rounded,
                            label: 'Explore',
                          ),
                          _buildCentralAIButton(),
                          _buildFuturisticNavItem(
                            index: 3,
                            icon: Icons.location_on_outlined,
                            activeIcon: Icons.location_on_rounded,
                            label: 'Nearby',
                          ),
                          _buildFuturisticNavItem(
                            index: 4,
                            icon: Icons.local_fire_department_outlined,
                            activeIcon: Icons.local_fire_department_rounded,
                            label: 'Deals',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFuturisticNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Holographic Icon Container
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isActive
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientMiddle,
                          AppColors.gradientEnd,
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.gradientStart.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.gradientEnd.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: Border.all(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
            const SizedBox(height: 4),

            // Futuristic Label
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
                letterSpacing: 0.5,
              ),
            ),

            // Active Indicator
            if (isActive)
              Container(
                width: 20,
                height: 2,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: const LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  ),
                ),
              ).animate().scale(
                begin: const Offset(0, 1),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
              ),
          ],
        ),
      ),
    ).animate().scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
    );
  }

  Widget _buildCentralAIButton() {
    final isActive = widget.currentIndex == 2;

    return GestureDetector(
          onTap: () => widget.onTap(2),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Central AI Orb - Most Futuristic Design Ever! 🚀
                AnimatedBuilder(
                  animation: _aiController,
                  builder: (context, child) {
                    final pulseScale =
                        1.0 +
                        (math.sin(_aiController.value * 2 * math.pi) * 0.1);
                    final rotationAngle = _aiController.value * 2 * math.pi;

                    return Transform.scale(
                      scale: pulseScale,
                      child: Transform.rotate(
                        angle: rotationAngle,
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.gradientStart,
                                AppColors.gradientMiddle,
                                AppColors.gradientEnd,
                                AppColors.gradientStart,
                              ],
                              stops: const [0.0, 0.3, 0.7, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gradientStart.withValues(
                                  alpha: 0.6,
                                ),
                                blurRadius: 25,
                                spreadRadius: 3,
                              ),
                              BoxShadow(
                                color: AppColors.gradientMiddle.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 35,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: AppColors.gradientEnd.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 45,
                                spreadRadius: 8,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.1),
                                ],
                                stops: const [0.0, 0.7, 1.0],
                              ),
                            ),
                            child: Transform.rotate(
                              angle: -rotationAngle, // Counter-rotate the icon
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),

                // AI Label with Gradient Text
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.gradientStart,
                      AppColors.gradientMiddle,
                      AppColors.gradientEnd,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'AI',
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(seconds: 3),
          color: Colors.white.withValues(alpha: 0.3),
        );
  }

  Widget _buildDealsNavItem() {
    final isActive = widget.currentIndex == 4;

    return GestureDetector(
      onTap: () => widget.onTap(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Deals Icon with Instagram Reels Style
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Ring Animation
                AnimatedBuilder(
                  animation: _dealsController,
                  builder: (context, child) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientMiddle,
                            AppColors.gradientEnd,
                          ],
                          stops: [
                            (_dealsController.value - 0.3).clamp(0.0, 1.0),
                            _dealsController.value,
                            (_dealsController.value + 0.3).clamp(0.0, 1.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Inner Container
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkBackground,
                    gradient: isActive ? AppColors.subtleGradient : null,
                  ),
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    color: isActive ? AppColors.gradientEnd : Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Deels',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.premiumGold : Colors.white,
              ),
            ),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
              ).animate().scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
              ),
          ],
        ),
      ),
    );
  }
}
