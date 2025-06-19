import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';

/// Outstanding Onboarding Screen - FINAL VERSION! 🚀
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _logoAnimationController;

  int _currentPage = 0;

  // Outstanding Onboarding Data - Vinu Bhaisahab's Premium Content
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "AI Bazar",
      subtitle:
          "India's first AI-powered local bazaar — deals before you even search.",
      icon: Icons.smart_toy,
      color: AppColors.gradientStart,
    ),
    OnboardingData(
      title: "Explore Bazar",
      subtitle: "Explore trending offers from real shops across your city.",
      icon: Icons.explore,
      color: AppColors.gradientMiddle,
    ),
    OnboardingData(
      title: "Nearby Bazar",
      subtitle: "Find live deals from shops just around your corner.",
      icon: Icons.location_on,
      color: AppColors.gradientEnd,
    ),
    OnboardingData(
      title: "Personalised Deals",
      subtitle:
          "Get offers picked just for you, based on your needs and location.",
      icon: Icons.favorite,
      color: AppColors.gradientStart,
    ),
    OnboardingData(
      title: "Vocal for Local",
      subtitle: "Support local shops, power local dreams — go vocal for local.",
      icon: Icons.store,
      color: AppColors.gradientMiddle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Start logo animation
    _logoAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _logoAnimationController.reset();
      _logoAnimationController.forward();
    } else {
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _logoAnimationController.reset();
      _logoAnimationController.forward();
    }
  }

  void _skipToEnd() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Main Content
              Column(
                children: [
                  const SizedBox(height: 60), // Space for skip button
                  // Page Content - Bigger Size!
                  Expanded(
                    flex: 8,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                        _logoAnimationController.reset();
                        _logoAnimationController.forward();
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _buildPageContent(_pages[index]);
                      },
                    ),
                  ),

                  // Page Indicator
                  _buildPageIndicator(),

                  // Navigation Buttons
                  _buildNavigationButtons(),

                  const SizedBox(height: 10), // Small bottom padding
                ],
              ),

              // Skip Button - TOP RIGHT as Vinu bhaisahab wants! 🔥
              Positioned(
                top: 80, // Top position as requested
                right: 30, // Right side with proper margin
                child:
                    GestureDetector(
                          onTap: _skipToEnd,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 800))
                        .slideX(begin: 0.3, end: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          // Amazing Icon Animation - BIGGER SIZE!
          SizedBox(
            height: 120, // Much bigger for phone
            width: 120,
            child: _buildIconAnimation(data),
          ),

          const SizedBox(height: 30), // More spacing
          // Title - BIGGER SIZE!
          Text(
                data.title,
                style: GoogleFonts.poppins(
                  // Poppins font as requested
                  fontSize: 26, // Much bigger for phone
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 800))
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 15), // More spacing
          // Subtitle - BIGGER SIZE!
          Text(
                data.subtitle,
                style: GoogleFonts.poppins(
                  // Poppins font as requested
                  fontSize: 16, // Much bigger for phone
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryText,
                  height: 1.4, // Better line height
                ),
                textAlign: TextAlign.center,
                maxLines: 3, // More lines for bigger text
                overflow: TextOverflow.ellipsis,
              )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 1000))
              .slideY(begin: 0.5, end: 0),
        ],
      ),
    );
  }

  Widget _buildIconAnimation(OnboardingData data) {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Gradient ring animation - BIGGER!
            Transform.scale(
              scale: 1 + (_logoAnimationController.value * 0.2),
              child: Container(
                width: 100, // Much bigger for phone
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle, // Square as requested
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gradientStart.withValues(
                        alpha: 0.3 * (1 - _logoAnimationController.value),
                      ),
                      AppColors.gradientMiddle.withValues(
                        alpha: 0.3 * (1 - _logoAnimationController.value),
                      ),
                      AppColors.gradientEnd.withValues(
                        alpha: 0.3 * (1 - _logoAnimationController.value),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Central icon container - Square with gradient background - BIGGER!
            Transform.scale(
              scale: 0.8 + (_logoAnimationController.value * 0.3),
              child: Container(
                width: 70, // Much bigger for phone
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle, // Square as requested
                  borderRadius: BorderRadius.circular(15),
                  gradient: AppColors
                      .primaryGradient, // Gradient background as requested
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientStart.withValues(alpha: 0.4),
                      blurRadius: 15, // Bigger shadow
                      spreadRadius: 3, // Bigger spread
                    ),
                  ],
                ),
                child: Icon(
                  data.icon,
                  color: Colors.white,
                  size: 35, // Much bigger icon
                ), // White icon as requested
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: _currentPage == index
                  ? AppColors.primaryGradient
                  : null,
              color: _currentPage == index
                  ? null
                  : Colors.white.withValues(alpha: 0.3),
            ),
          ).animate().scale(duration: const Duration(milliseconds: 300)),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          if (_currentPage > 0)
            _buildOutlineButton(text: 'Previous', onTap: _previousPage)
          else
            const SizedBox(width: 80),

          // Next/Welcome Button - Same style as Previous
          _buildOutlineButton(
            text: _currentPage == _pages.length - 1 ? 'Welcome' : 'Next',
            onTap: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(2), // Padding for gradient border
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient:
                  AppColors.primaryGradient, // Gradient border as requested
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack, // Dark background inside
                borderRadius: BorderRadius.circular(23),
              ),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  // Poppins font as requested
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // White text as requested
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.3, end: 0);
  }
}

// Outstanding Data Model
class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
