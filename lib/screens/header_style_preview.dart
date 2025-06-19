import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/animated_background.dart';
import '../constants/colors.dart';

class HeaderStylePreview extends StatefulWidget {
  final int styleNumber;
  final Function(int)? onApplyStyle;

  const HeaderStylePreview({
    super.key,
    required this.styleNumber,
    this.onApplyStyle,
  });

  @override
  State<HeaderStylePreview> createState() => _HeaderStylePreviewState();
}

class _HeaderStylePreviewState extends State<HeaderStylePreview>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Header Style ${widget.styleNumber}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Header Preview
              Expanded(child: _buildHeaderStyle(widget.styleNumber)),

              // Apply Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () {
                    // Apply the style and go back
                    if (widget.onApplyStyle != null) {
                      widget.onApplyStyle!(widget.styleNumber);
                    }
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '🔥 EXTRAORDINARY Style ${widget.styleNumber} Applied! 🔥',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: AppColors.gradientStart,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gradientStart.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      '🔥 Apply This EXTRAORDINARY Style 🔥',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStyle(int styleNumber) {
    switch (styleNumber) {
      case 1:
        return _buildGradientGlowStyle();
      case 2:
        return _buildNeonPulseStyle();
      case 3:
        return _buildGlassMorphStyle();
      case 4:
        return _buildCyberTechStyle();
      case 5:
        return _buildAuroraWaveStyle();
      case 6:
        return _buildHologramStyle();
      case 7:
        return _buildMatrixCodeStyle();
      case 8:
        return _buildPlasmaFlowStyle();
      case 9:
        return _buildQuantumFluxStyle();
      case 10:
        return _buildCosmicStormStyle();
      case 11:
        return _buildNeuralNetworkStyle();
      case 12:
        return _buildLiquidMetalStyle();
      case 13:
        return _buildVoidPortalStyle();
      case 14:
        return _buildCrystalPrismStyle();
      case 15:
        return _buildThunderStormStyle();
      case 16:
        return _buildGalaxySpiralStyle();
      case 17:
        return _buildNeonCityStyle();
      case 18:
        return _buildFirePhoenixStyle();
      case 19:
        return _buildIceCrystalStyle();
      case 20:
        return _buildQuantumVoidStyle();
      default:
        return _buildGradientGlowStyle();
    }
  }

  // 🔥 STYLE 1: GRADIENT GLOW 🔥
  Widget _buildGradientGlowStyle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientStart.withValues(alpha: 0.3),
            AppColors.gradientMiddle.withValues(alpha: 0.2),
            AppColors.gradientEnd.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientStart.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationRow(),
          const SizedBox(height: 16),
          _buildMinimalSearchBar(),
        ],
      ),
    );
  }

  // 🔥 STYLE 2: NEON PULSE 🔥
  Widget _buildNeonPulseStyle() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryBlack.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.gradientStart.withValues(
                alpha: _pulseAnimation.value,
              ),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientStart.withValues(
                  alpha: _pulseAnimation.value * 0.5,
                ),
                blurRadius: 20 * _pulseAnimation.value,
                spreadRadius: 2 * _pulseAnimation.value,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 3: GLASS MORPH 🔥
  Widget _buildGlassMorphStyle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildLocationRow(),
          const SizedBox(height: 16),
          _buildMinimalSearchBar(),
        ],
      ),
    );
  }

  // 🔥 STYLE 4: CYBER TECH 🔥
  Widget _buildCyberTechStyle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0A0A0A),
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00FFFF).withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FFFF).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationRow(),
          const SizedBox(height: 16),
          _buildMinimalSearchBar(),
        ],
      ),
    );
  }

  // 🔥 STYLE 5: AURORA WAVE 🔥
  Widget _buildAuroraWaveStyle() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4A00E0).withValues(alpha: 0.6),
                const Color(0xFF8E2DE2).withValues(alpha: 0.4),
                const Color(0xFFFF6B6B).withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, _glowAnimation.value, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 6: HOLOGRAM 🔥
  Widget _buildHologramStyle() {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_rotateAnimation.value * 0.1),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(_rotateAnimation.value * 6.28),
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildLocationRow(),
                const SizedBox(height: 16),
                _buildMinimalSearchBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔥 STYLE 7: MATRIX CODE 🔥
  Widget _buildMatrixCodeStyle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00FF00).withValues(alpha: 0.7),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF00).withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationRow(),
          const SizedBox(height: 16),
          _buildMinimalSearchBar(),
        ],
      ),
    );
  }

  // 🔥 STYLE 8: PLASMA FLOW 🔥
  Widget _buildPlasmaFlowStyle() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color(0xFFFF0080).withValues(alpha: 0.4),
                const Color(0xFF7928CA).withValues(alpha: 0.6),
                const Color(0xFF0070F3).withValues(alpha: 0.4),
              ],
              center: Alignment(_glowAnimation.value - 0.5, 0),
              radius: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 9: QUANTUM FLUX 🔥
  Widget _buildQuantumFluxStyle() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667eea).withValues(alpha: 0.5),
                const Color(0xFF764ba2).withValues(alpha: 0.7),
                const Color(0xFFf093fb).withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: _pulseAnimation.value * 0.5,
              ),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF667eea,
                ).withValues(alpha: _pulseAnimation.value * 0.3),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 10: COSMIC STORM 🔥
  Widget _buildCosmicStormStyle() {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: SweepGradient(
              colors: [
                const Color(0xFF8A2387),
                const Color(0xFFE94057),
                const Color(0xFFF27121),
                const Color(0xFF8A2387),
              ],
              transform: GradientRotation(_rotateAnimation.value * 6.28),
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 MINIMAL LOCATION ROW 🔥
  Widget _buildLocationRow() {
    return Row(
      children: [
        // Location
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white.withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Kajipura, Ujjain',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white.withValues(alpha: 0.8),
                size: 18,
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Notification Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        // Three Dots Menu
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Icon(Icons.more_vert, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  // 🔥 MINIMAL SEARCH BAR 🔥
  Widget _buildMinimalSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: TextField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search for products, stores...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withValues(alpha: 0.8),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // 🔥 STYLE 11: NEURAL NETWORK 🔥
  Widget _buildNeuralNetworkStyle() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0F3460).withValues(alpha: 0.8),
                const Color(0xFF16537e).withValues(alpha: 0.6),
                const Color(0xFF533483).withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(
                0xFF00D4FF,
              ).withValues(alpha: _pulseAnimation.value),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF00D4FF,
                ).withValues(alpha: _pulseAnimation.value * 0.4),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 12: LIQUID METAL 🔥
  Widget _buildLiquidMetalStyle() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2C3E50).withValues(alpha: 0.9),
                const Color(0xFF4CA1AF).withValues(alpha: 0.7),
                const Color(0xFFC4E0E1).withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, _glowAnimation.value, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFC4E0E1).withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 13: VOID PORTAL 🔥
  Widget _buildVoidPortalStyle() {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color(0xFF000000),
                const Color(0xFF1A0033).withValues(alpha: 0.8),
                const Color(0xFF4A0080).withValues(alpha: 0.6),
                const Color(0xFF8A2BE2).withValues(alpha: 0.4),
              ],
              center: Alignment.center,
              radius: 1.0 + (_rotateAnimation.value * 0.5),
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.7),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 14: CRYSTAL PRISM 🔥
  Widget _buildCrystalPrismStyle() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFE5B4).withValues(alpha: 0.3),
                const Color(0xFFFFCCE5).withValues(alpha: 0.5),
                const Color(0xFFE5CCFF).withValues(alpha: 0.3),
                const Color(0xFFCCE5FF).withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                _glowAnimation.value * 0.5,
                _glowAnimation.value,
                1.0,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(
                  alpha: _glowAnimation.value * 0.3,
                ),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 15: THUNDER STORM 🔥
  Widget _buildThunderStormStyle() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1e3c72).withValues(alpha: 0.8),
                const Color(0xFF2a5298).withValues(alpha: 0.9),
                const Color(
                  0xFFFFFF00,
                ).withValues(alpha: _pulseAnimation.value * 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(
                0xFFFFFF00,
              ).withValues(alpha: _pulseAnimation.value),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFFFFF00,
                ).withValues(alpha: _pulseAnimation.value * 0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 16: GALAXY SPIRAL 🔥
  Widget _buildGalaxySpiralStyle() {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: SweepGradient(
              colors: [
                const Color(0xFF000428),
                const Color(0xFF004e92),
                const Color(0xFF009ffd),
                const Color(0xFF00d2ff),
                const Color(0xFF000428),
              ],
              transform: GradientRotation(_rotateAnimation.value * 6.28),
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00d2ff).withValues(alpha: 0.8),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 17: NEON CITY 🔥
  Widget _buildNeonCityStyle() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0F0F23).withValues(alpha: 0.9),
                const Color(0xFF1A1A2E).withValues(alpha: 0.8),
                const Color(0xFF16213E).withValues(alpha: 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(
                0xFFFF0080,
              ).withValues(alpha: _glowAnimation.value),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFFF0080,
                ).withValues(alpha: _glowAnimation.value * 0.4),
                blurRadius: 25,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: const Color(
                  0xFF00FFFF,
                ).withValues(alpha: _glowAnimation.value * 0.3),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 18: FIRE PHOENIX 🔥
  Widget _buildFirePhoenixStyle() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color(0xFFFF4500).withValues(alpha: 0.8),
                const Color(0xFFFF6347).withValues(alpha: 0.6),
                const Color(0xFFFF8C00).withValues(alpha: 0.4),
                const Color(
                  0xFFFFD700,
                ).withValues(alpha: _pulseAnimation.value * 0.3),
              ],
              center: Alignment.center,
              radius: 1.0 + (_pulseAnimation.value * 0.3),
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(
                0xFFFFD700,
              ).withValues(alpha: _pulseAnimation.value),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFFF4500,
                ).withValues(alpha: _pulseAnimation.value * 0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 19: ICE CRYSTAL 🔥
  Widget _buildIceCrystalStyle() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF83a4d4).withValues(alpha: 0.6),
                const Color(0xFFb6fbff).withValues(alpha: 0.4),
                const Color(0xFFe0f6ff).withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, _glowAnimation.value, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFe0f6ff).withValues(alpha: 0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFb6fbff,
                ).withValues(alpha: _glowAnimation.value * 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }

  // 🔥 STYLE 20: QUANTUM VOID 🔥
  Widget _buildQuantumVoidStyle() {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color(0xFF000000),
                const Color(0xFF1a1a2e).withValues(alpha: 0.9),
                const Color(0xFF16213e).withValues(alpha: 0.7),
                const Color(0xFF0f3460).withValues(alpha: 0.5),
              ],
              center: Alignment(
                _rotateAnimation.value - 0.5,
                _rotateAnimation.value - 0.5,
              ),
              radius: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF533483).withValues(alpha: 0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF533483).withValues(alpha: 0.4),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(),
              const SizedBox(height: 16),
              _buildMinimalSearchBar(),
            ],
          ),
        );
      },
    );
  }
}
