import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CategoryChips extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips>
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.apps, 'color': Colors.purple},
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink},
    {'name': 'Electronics', 'icon': Icons.phone_android, 'color': Colors.blue},
    {'name': 'Grocery', 'icon': Icons.shopping_cart, 'color': Colors.green},
    {'name': 'Others', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category['name'] == widget.selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                _animationController.forward().then((_) {
                  _animationController.reverse();
                });
                widget.onCategoryChanged(category['name']);
              },
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected ? _scaleAnimation.value : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected 
                          ? AppColors.primaryGradient
                          : null,
                        color: isSelected 
                          ? null 
                          : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected 
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: AppColors.gradientStart.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ] : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category['icon'],
                            color: isSelected 
                              ? Colors.white 
                              : Colors.white.withValues(alpha: 0.8),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            category['name'],
                            style: GoogleFonts.inter(
                              color: isSelected 
                                ? Colors.white 
                                : Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                              fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
