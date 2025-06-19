import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/colors.dart';

/// Outstanding Animated Background - Exact Same as Splash Screen! 🌟
/// Vinu Bhaisahab's Premium Component with Perfect Spot Animations
class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientWaveController;
  late Animation<double> _gradientWaveAnimation;

  @override
  void initState() {
    super.initState();

    // EXACT SAME as splash screen - 6 second cycle
    _gradientWaveController = AnimationController(
      duration: const Duration(seconds: 6), // Perfect speed - 6 seconds total
      vsync: this,
    );

    _gradientWaveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientWaveController, curve: Curves.easeInOut),
    );

    // Start gradient wave immediately for outstanding effect
    _gradientWaveController.repeat();
    print("🌟 AnimatedBackground initialized - animation started!");
  }

  @override
  void dispose() {
    _gradientWaveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientWaveController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: _buildDynamicGradient()),
          child: Stack(
            children: [
              // Outstanding Spot Glow Effects - EXACT SAME as splash screen 🌟
              ..._buildSpotGlows(),

              // Main Content
              widget.child,
            ],
          ),
        );
      },
    );
  }

  // EXACT SAME Dynamic Gradient Builder as splash screen 🌊
  LinearGradient _buildDynamicGradient() {
    // Background stays dark black, only subtle spot glows
    return const LinearGradient(
      colors: [AppColors.primaryBlack, AppColors.primaryBlack],
    );
  }

  // EXACT SAME Spot Effects as Splash Screen - No More Magic Show! 😅
  List<Widget> _buildSpotGlows() {
    final waveValue = _gradientWaveAnimation.value;
    final spots = <Widget>[];

    // Define colors for simple sequence - EXACT SAME as splash screen
    final colors = [
      AppColors.gradientStart, // Light blue
      AppColors.gradientMiddle, // Purple
      AppColors.gradientEnd, // Dark pink
    ];

    // Simple sequential spots - one at a time, slow and calm - EXACT SAME
    final numSpots = 3;

    for (int i = 0; i < numSpots; i++) {
      // Each spot gets its own time slot in the 6-second cycle - EXACT SAME
      final spotStartTime = i / numSpots;
      final spotEndTime = (i + 1) / numSpots;

      // Calculate if this spot should be visible - EXACT SAME
      final normalizedTime = waveValue % 1.0;
      double opacity = 0.0;

      if (normalizedTime >= spotStartTime && normalizedTime < spotEndTime) {
        // Spot is in its active period - EXACT SAME
        final localTime =
            (normalizedTime - spotStartTime) / (spotEndTime - spotStartTime);

        // Ultra slow and steady fade - very gentle - EXACT SAME
        if (localTime < 0.4) {
          // Ultra slow fade in - 40% of time (4 seconds) - EXACT SAME
          opacity = localTime / 0.4;
        } else if (localTime > 0.6) {
          // Ultra slow fade out - 40% of time (4 seconds) - EXACT SAME
          opacity = (1.0 - localTime) / 0.4;
        } else {
          // Steady glow phase - 20% of time (2 seconds) - EXACT SAME
          opacity = 1.0;
        }
      }

      if (opacity > 0.05) {
        // Random position for each appearance - changes every cycle! - EXACT SAME
        final currentCycle = (waveValue / (1.0 / numSpots))
            .floor(); // Which cycle we're in - EXACT SAME
        final randomSeed =
            (currentCycle * 1000) +
            (i * 123) +
            DateTime.now().millisecondsSinceEpoch ~/ 10000; // EXACT SAME
        final random = math.Random(randomSeed);

        final spotX = random.nextDouble(); // Random X every time - EXACT SAME
        final spotY = random.nextDouble(); // Random Y every time - EXACT SAME

        final spotSize =
            180.0 + (opacity * 40.0); // Reasonable size - EXACT SAME

        print("🔥 Creating spot $i with opacity $opacity at ($spotX, $spotY)");

        spots.add(
          Positioned(
            left:
                (MediaQuery.maybeOf(context)?.size.width ?? 1080) * spotX -
                (spotSize / 2),
            top:
                (MediaQuery.maybeOf(context)?.size.height ?? 2400) * spotY -
                (spotSize / 2),
            child: Container(
              width: spotSize,
              height: spotSize,
              decoration: BoxDecoration(
                // Simple irregular shape - not too crazy - EXACT SAME
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
                          (opacity *
                              0.06), // Perfect 5-6% glow intensity - EXACT SAME
                    ),
                    colors[i].withValues(alpha: 0.04 + (opacity * 0.04)),
                    colors[i].withValues(alpha: 0.03 + (opacity * 0.03)),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0], // EXACT SAME
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
