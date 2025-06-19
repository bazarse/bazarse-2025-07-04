import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../constants/colors.dart';

class HolographicCategoryGrid extends StatefulWidget {
  final Function(String) onCategoryTap;

  const HolographicCategoryGrid({
    super.key,
    required this.onCategoryTap,
  });

  @override
  State<HolographicCategoryGrid> createState() => _HolographicCategoryGridState();
}

class _HolographicCategoryGridState extends State<HolographicCategoryGrid>
    with TickerProviderStateMixin {
  late AnimationController _hologramController;
  late AnimationController _floatController;
  
  final List<CategoryItem> categories = [
    CategoryItem(
      name: 'Electronics',
      icon: Icons.smartphone_rounded,
      gradient: [AppColors.gradientStart, AppColors.gradientMiddle],
      description: 'Latest gadgets & tech',
    ),
    CategoryItem(
      name: 'Fashion',
      icon: Icons.checkroom_rounded,
      gradient: [AppColors.gradientMiddle, AppColors.gradientEnd],
      description: 'Trending styles',
    ),
    CategoryItem(
      name: 'Home & Kitchen',
      icon: Icons.home_rounded,
      gradient: [AppColors.gradientEnd, AppColors.gradientStart],
      description: 'Smart home solutions',
    ),
    CategoryItem(
      name: 'Books',
      icon: Icons.menu_book_rounded,
      gradient: [AppColors.gradientStart, AppColors.gradientEnd],
      description: 'Knowledge & stories',
    ),
    CategoryItem(
      name: 'Sports',
      icon: Icons.sports_soccer_rounded,
      gradient: [AppColors.gradientMiddle, AppColors.gradientStart],
      description: 'Fitness & games',
    ),
    CategoryItem(
      name: 'Beauty',
      icon: Icons.face_rounded,
      gradient: [AppColors.gradientEnd, AppColors.gradientMiddle],
      description: 'Skincare & makeup',
    ),
    CategoryItem(
      name: 'Groceries',
      icon: Icons.shopping_cart_rounded,
      gradient: [AppColors.gradientStart, AppColors.gradientMiddle],
      description: 'Fresh & organic',
    ),
    CategoryItem(
      name: 'Toys',
      icon: Icons.toys_rounded,
      gradient: [AppColors.gradientMiddle, AppColors.gradientEnd],
      description: 'Fun for all ages',
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _hologramController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _hologramController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                child: Text(
                  'Categories',
                  style: GoogleFonts.orbitron(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: const Duration(seconds: 2),
                  color: Colors.white.withOpacity(0.5),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Holographic Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildHolographicCategoryCard(categories[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHolographicCategoryCard(CategoryItem category, int index) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hologramController, _floatController]),
      builder: (context, child) {
        final floatOffset = math.sin((_floatController.value * 2 * math.pi) + (index * 0.5)) * 3;
        final hologramIntensity = (math.sin((_hologramController.value * 2 * math.pi) + (index * 0.3)) + 1) / 2;
        
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: GestureDetector(
            onTap: () => widget.onCategoryTap(category.name),
            child: Container(
              child: Stack(
                children: [
                  // Holographic Glow Background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: category.gradient[0].withOpacity(hologramIntensity * 0.4),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: category.gradient[1].withOpacity(hologramIntensity * 0.3),
                          blurRadius: 35,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  // Glass Morphism Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Holographic Scan Line Effect
                            AnimatedBuilder(
                              animation: _hologramController,
                              builder: (context, child) {
                                return Positioned(
                                  top: (_hologramController.value * 200) - 50,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          category.gradient[0].withOpacity(0.8),
                                          category.gradient[1].withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: category.gradient[0].withOpacity(0.5),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Main Content
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Holographic Icon
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          category.gradient[0].withOpacity(0.8),
                                          category.gradient[1].withOpacity(0.6),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: category.gradient[0].withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Inner glow
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.2),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Icon
                                        Icon(
                                          category.icon,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Category Name
                                  Text(
                                    category.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),

                                  // Description
                                  Text(
                                    category.description,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Particle Effects
                            ...List.generate(5, (particleIndex) {
                              final particleAnimation = (_hologramController.value + (particleIndex * 0.2)) % 1.0;
                              final x = 20 + (particleIndex * 30.0);
                              final y = 20 + (particleAnimation * 120);
                              
                              return Positioned(
                                left: x,
                                top: y,
                                child: Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: category.gradient[particleIndex % 2].withOpacity(
                                      (1 - particleAnimation) * 0.6,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: category.gradient[particleIndex % 2].withOpacity(0.3),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
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
      delay: Duration(milliseconds: index * 150),
      duration: const Duration(milliseconds: 600),
    ).slideY(
      begin: 0.3,
      end: 0,
      delay: Duration(milliseconds: index * 150),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
    );
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final String description;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.description,
  });
}
