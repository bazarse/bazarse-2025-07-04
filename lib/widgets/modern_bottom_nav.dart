import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../screens/explore_page.dart';
import '../screens/ai_page.dart';
import '../screens/nearby_page.dart';
import '../screens/deals_page.dart';

class ModernBottomNav extends StatefulWidget {
  final int currentIndex;

  const ModernBottomNav({super.key, required this.currentIndex});

  @override
  _ModernBottomNavState createState() => _ModernBottomNavState();
}

class _ModernBottomNavState extends State<ModernBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _borderController;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _borderAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          height: 65, // Optimized height for titles
          margin: const EdgeInsets.all(0), // Full width - no margin
          decoration: BoxDecoration(
            // 🔥 GLASS MORPHISM EFFECT 🔥
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(0), // Rectangular border
            border: Border.all(
              // 🔥 CLEAN WHITE BORDER 🔥
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                context,
                icon: Icons.explore_rounded,
                label: 'Explore',
                index: 1,
              ),
              _buildAINavItem(context),
              _buildNavItem(
                context,
                icon: Icons.near_me_rounded,
                label: 'Nearby',
                index: 3,
              ),
              _buildDeelsNavItem(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () {
        // 🔥 HAPTIC FEEDBACK 🔥
        HapticFeedback.lightImpact();
        _navigateToPage(context, index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 6,
        ), // Optimized padding for titles
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 ICON WITH FUTURISTIC GLOW PATTERN 🔥
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(4), // Reduced icon padding
              decoration: isActive
                  ? BoxDecoration(
                      color: Color(
                        0xFF0070FF,
                      ).withValues(alpha: 0.1), // Light blue background
                      borderRadius: BorderRadius.circular(8), // Rectangular
                      boxShadow: [
                        // 🔥 LIGHT AND SOOTHING BLUE GLOW 🔥
                        BoxShadow(
                          color: Color(0xFF0070FF).withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : null,
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ), // Reduced icon size
            ),
            SizedBox(height: 3), // Perfect spacing
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isActive ? 9 : 8, // Optimized font size
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAINavItem(BuildContext context) {
    final isActive = widget.currentIndex == 2;

    return GestureDetector(
      onTap: () {
        // 🔥 HAPTIC FEEDBACK 🔥
        HapticFeedback.lightImpact();
        _navigateToPage(context, 2);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 6,
        ), // Optimized padding for titles
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 GLOWING AI TEXT AS ICON 🔥
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ), // Reduced AI padding
              decoration: isActive
                  ? BoxDecoration(
                      color: Color(
                        0xFF0070FF,
                      ).withValues(alpha: 0.1), // Light blue background
                      borderRadius: BorderRadius.circular(8), // Rectangular
                      boxShadow: [
                        // 🔥 LIGHT AND SOOTHING BLUE GLOW 🔥
                        BoxShadow(
                          color: Color(0xFF0070FF).withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : null,
              child: Text(
                'AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12, // Much smaller AI font size to fix overflow
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  shadows: [
                    // 🔥 BLUE GLOWING AI 🔥
                    Shadow(
                      color: Color(0xFF0070FF).withValues(alpha: 0.8),
                      blurRadius: 12,
                    ),
                    Shadow(
                      color: Color(0xFF0070FF).withValues(alpha: 0.6),
                      blurRadius: 18,
                    ),
                    Shadow(
                      color: Color(0xFF0070FF).withValues(alpha: 0.4),
                      blurRadius: 25,
                    ),
                  ],
                ),
              ),
            ),
            // 🔥 NO TITLE BELOW AI 🔥
          ],
        ),
      ),
    );
  }

  Widget _buildDeelsNavItem(BuildContext context) {
    final isActive = widget.currentIndex == 4;

    return GestureDetector(
      onTap: () {
        // 🔥 HAPTIC FEEDBACK 🔥
        HapticFeedback.lightImpact();
        _navigateToPage(context, 4);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 6,
        ), // Optimized padding for titles
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 INSTAGRAM REELS ICON WITH FUTURISTIC GLOW 🔥
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(4), // Reduced Deels icon padding
              decoration: isActive
                  ? BoxDecoration(
                      color: Color(
                        0xFF0070FF,
                      ).withValues(alpha: 0.1), // Light blue background
                      borderRadius: BorderRadius.circular(8), // Rectangular
                      boxShadow: [
                        // 🔥 LIGHT AND SOOTHING BLUE GLOW 🔥
                        BoxShadow(
                          color: Color(0xFF0070FF).withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : null,
              child: Icon(
                Icons.video_library_rounded, // Instagram Reels style icon
                color: Colors.white,
                size: 20, // Reduced Deels icon size
              ),
            ),
            SizedBox(height: 3), // Perfect spacing
            Text(
              'Deels',
              style: TextStyle(
                color: Colors.white,
                fontSize: isActive ? 9 : 8, // Optimized font size
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    if (widget.currentIndex == index) {
      return; // Don't navigate if already on the page
    }

    Widget page;
    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const ExplorePage();
        break;
      case 2:
        page = const AIPage();
        break;
      case 3:
        page = const NearbyPage();
        break;
      case 4:
        page = const DealsPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
