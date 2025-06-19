import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Kya dhund rahe ho?',
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: AnimatedBuilder(
            animation: _borderAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: _isFocused ? AppColors.primaryGradient : null,
                  boxShadow: [
                    if (_isFocused)
                      BoxShadow(
                        color: AppColors.gradientMiddle.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.all(_isFocused ? 2 : 0),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(25),
                    border: !_isFocused
                        ? Border.all(color: AppColors.surfaceColor, width: 1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Search Icon
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 15),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.search_rounded,
                            color: _isFocused
                                ? AppColors.gradientMiddle
                                : AppColors.secondaryText,
                            size: 24,
                          ),
                        ),
                      ),

                      // Search Input
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          style: GoogleFonts.inter(
                            color: AppColors.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: GoogleFonts.inter(
                              color: AppColors.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      // Voice Search Icon
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: _isFocused
                                ? AppColors.subtleGradient
                                : null,
                            color: !_isFocused
                                ? AppColors.surfaceColor.withOpacity(0.5)
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                // Voice search functionality
                                HapticFeedback.lightImpact();
                              },
                              child: Icon(
                                Icons.mic_rounded,
                                color: _isFocused
                                    ? AppColors.gradientMiddle
                                    : AppColors.secondaryText,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(
          begin: -0.2,
          end: 0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
  }
}

// Alternative Creative Search Bar Design
class CreativeSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;

  const CreativeSearchBar({
    super.key,
    this.hintText = 'Search bazarse...',
    this.onChanged,
  });

  @override
  State<CreativeSearchBar> createState() => _CreativeSearchBarState();
}

class _CreativeSearchBarState extends State<CreativeSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientMiddle.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gradientStart.withOpacity(0.1),
                      AppColors.gradientMiddle.withOpacity(0.1),
                      AppColors.gradientEnd.withOpacity(0.1),
                    ],
                    stops: [
                      (_pulseController.value - 0.3).clamp(0.0, 1.0),
                      _pulseController.value,
                      (_pulseController.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ),
                ),
              );
            },
          ),

          // Main Container
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _isFocused
                    ? AppColors.gradientMiddle
                    : AppColors.surfaceColor,
                width: _isFocused ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Icon(
                  Icons.search_rounded,
                  color: _isFocused
                      ? AppColors.gradientMiddle
                      : AppColors.secondaryText,
                  size: 24,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    onChanged: widget.onChanged,
                    style: GoogleFonts.inter(
                      color: AppColors.primaryText,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.secondaryText,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
