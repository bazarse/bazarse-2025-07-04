import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../constants/colors.dart';
import '../widgets/gradient_widgets.dart';
import 'permission_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _taglineController;
  late AnimationController _gradientWaveController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _gradientWaveAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Outstanding Gradient Wave Controller 🌊 - Perfect speed (5X faster)
    _gradientWaveController = AnimationController(
      duration: const Duration(seconds: 6), // Perfect speed - 6 seconds total
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    // Outstanding Gradient Wave Animation 🌊
    _gradientWaveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientWaveController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Start gradient wave immediately for outstanding effect
    _gradientWaveController.repeat();

    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    _taglineController.forward();

    // Navigate to permission screen after showing splash
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PermissionScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    _gradientWaveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBuilder(
        animation: _gradientWaveController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: _buildDynamicGradient()),
            child: Stack(
              children: [
                // Outstanding Spot Glow Effects 🌟
                ..._buildSpotGlows(),

                // Main Content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Opacity(
                            opacity: _logoOpacity.value,
                            child: Column(
                              children: [
                                // Main Logo
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    // "Bazar" text - B capital as requested
                                    ShaderMask(
                                      shaderCallback: (bounds) => AppColors
                                          .primaryGradient
                                          .createShader(
                                            Rect.fromLTWH(
                                              0,
                                              0,
                                              bounds.width,
                                              bounds.height,
                                            ),
                                          ),
                                      child: Text(
                                        'Bazar ',
                                        style: GoogleFonts.poppins(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                    ),
                                    // "से" text with special styling
                                    ShaderMask(
                                      shaderCallback: (bounds) => AppColors
                                          .primaryGradient
                                          .createShader(
                                            Rect.fromLTWH(
                                              0,
                                              0,
                                              bounds.width,
                                              bounds.height,
                                            ),
                                          ),
                                      child: Text(
                                        'से',
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontSize:
                                              48, // Same as Bazar for equal height
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Underline removed as requested by Vinu bhaisahab
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20), // Less gap as requested
                    // Tagline Section with Fade Animation
                    AnimatedBuilder(
                      animation: _taglineController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, (1 - _taglineOpacity.value) * 20),
                          child: Opacity(
                            opacity: _taglineOpacity.value,
                            child: Column(
                              children: [
                                Text(
                                      'Naye Bharat Ka AI Bazar',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.secondaryText
                                            .withValues(
                                              alpha: _taglineOpacity.value,
                                            ),
                                        letterSpacing: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                    .animate()
                                    .fadeIn(
                                      duration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      curve: Curves.easeOut,
                                    )
                                    .slideY(
                                      begin: 0.5,
                                      end: 0,
                                      duration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      curve: Curves.easeOut,
                                    ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Outstanding Dynamic Gradient Builder with Spot Glows 🌊
  LinearGradient _buildDynamicGradient() {
    // Background stays dark black, only subtle spot glows
    return const LinearGradient(
      colors: [AppColors.primaryBlack, AppColors.primaryBlack],
    );
  }

  // Simple Spot Effects - No More Magic Show! 😅
  List<Widget> _buildSpotGlows() {
    final waveValue = _gradientWaveAnimation.value;
    final spots = <Widget>[];

    // Define colors for simple sequence
    final colors = [
      AppColors.gradientStart, // Light blue
      AppColors.gradientMiddle, // Purple
      AppColors.gradientEnd, // Dark pink
    ];

    // Simple sequential spots - one at a time, slow and calm
    final numSpots = 3;

    for (int i = 0; i < numSpots; i++) {
      // Each spot gets its own time slot in the 8-second cycle
      final spotStartTime = i / numSpots;
      final spotEndTime = (i + 1) / numSpots;

      // Calculate if this spot should be visible
      final normalizedTime = waveValue % 1.0;
      double opacity = 0.0;

      if (normalizedTime >= spotStartTime && normalizedTime < spotEndTime) {
        // Spot is in its active period
        final localTime =
            (normalizedTime - spotStartTime) / (spotEndTime - spotStartTime);

        // Ultra slow and steady fade - very gentle
        if (localTime < 0.4) {
          // Ultra slow fade in - 40% of time (4 seconds)
          opacity = localTime / 0.4;
        } else if (localTime > 0.6) {
          // Ultra slow fade out - 40% of time (4 seconds)
          opacity = (1.0 - localTime) / 0.4;
        } else {
          // Steady glow phase - 20% of time (2 seconds)
          opacity = 1.0;
        }
      }

      if (opacity > 0.05) {
        // Random position for each appearance - changes every cycle!
        final currentCycle = (waveValue / (1.0 / numSpots))
            .floor(); // Which cycle we're in
        final randomSeed =
            (currentCycle * 1000) +
            (i * 123) +
            DateTime.now().millisecondsSinceEpoch ~/ 10000;
        final random = math.Random(randomSeed);

        final spotX = random.nextDouble(); // Random X every time
        final spotY = random.nextDouble(); // Random Y every time

        final spotSize = 180.0 + (opacity * 40.0); // Reasonable size

        spots.add(
          Positioned(
            left: MediaQuery.of(context).size.width * spotX - (spotSize / 2),
            top: MediaQuery.of(context).size.height * spotY - (spotSize / 2),
            child: Container(
              width: spotSize,
              height: spotSize,
              decoration: BoxDecoration(
                // Simple irregular shape - not too crazy
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(spotSize * 0.3),
                  topRight: Radius.circular(spotSize * 0.6),
                  bottomLeft: Radius.circular(spotSize * 0.5),
                  bottomRight: Radius.circular(spotSize * 0.4),
                ),
                gradient: RadialGradient(
                  colors: [
                    colors[i].withValues(
                      alpha:
                          0.05 +
                          (opacity * 0.06), // Perfect 5-6% glow intensity
                    ),
                    colors[i].withValues(alpha: 0.04 + (opacity * 0.04)),
                    colors[i].withValues(alpha: 0.03 + (opacity * 0.03)),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),
        );
      }
    }

    return spots;
  }
}
