import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../constants/colors.dart';
import '../models/product.dart';

class FloatingProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final int index;

  const FloatingProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.index = 0,
  });

  @override
  State<FloatingProductCard> createState() => _FloatingProductCardState();
}

class _FloatingProductCardState extends State<FloatingProductCard>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _rotateController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotateAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _floatController = AnimationController(
      duration: Duration(milliseconds: 3000 + (widget.index * 200)),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000 + (widget.index * 150)),
      vsync: this,
    )..repeat();

    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _glowController, _rotateController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) => setState(() => _isHovered = false),
            onTapCancel: () => setState(() => _isHovered = false),
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  // Holographic Glow Effect
                  Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Container(
                      width: 200,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.gradientStart.withOpacity(_glowAnimation.value * 0.3),
                            AppColors.gradientMiddle.withOpacity(_glowAnimation.value * 0.2),
                            AppColors.gradientEnd.withOpacity(_glowAnimation.value * 0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradientStart.withOpacity(_glowAnimation.value * 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: AppColors.gradientEnd.withOpacity(_glowAnimation.value * 0.3),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main Card with Glass Morphism
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_isHovered ? 0.1 : 0)
                      ..rotateY(_isHovered ? 0.1 : 0)
                      ..scale(_isHovered ? 1.05 : 1.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 200,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image with Holographic Effect
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.gradientStart.withOpacity(0.1),
                                        AppColors.gradientEnd.withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Stack(
                                      children: [
                                        // Placeholder for actual image
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.gradientStart.withOpacity(0.3),
                                                AppColors.gradientMiddle.withOpacity(0.2),
                                                AppColors.gradientEnd.withOpacity(0.3),
                                              ],
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 40,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                        
                                        // Shimmer Effect
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(-1.0, -1.0),
                                                end: Alignment(1.0, 1.0),
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.white.withOpacity(0.2),
                                                  Colors.transparent,
                                                ],
                                                stops: const [0.0, 0.5, 1.0],
                                                transform: GradientRotation(_rotateAnimation.value),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Sale Badge
                                        if (widget.product.isOnSale)
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: AppColors.primaryGradient,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.gradientEnd.withOpacity(0.5),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                '${widget.product.discountPercentage.toInt()}% OFF',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Product Details
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product Name
                                      Text(
                                        widget.product.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),

                                      // Rating
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.product.rating.toStringAsFixed(1),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '(${widget.product.reviewCount})',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),

                                      // Price Section
                                      Row(
                                        children: [
                                          Text(
                                            widget.product.formattedPrice,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.gradientEnd,
                                            ),
                                          ),
                                          if (widget.product.hasDiscount) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.product.formattedOriginalPrice,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white54,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      },
    ).animate().fadeIn(
      delay: Duration(milliseconds: widget.index * 100),
      duration: const Duration(milliseconds: 600),
    ).slideY(
      begin: 0.3,
      end: 0,
      delay: Duration(milliseconds: widget.index * 100),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
    );
  }
}
