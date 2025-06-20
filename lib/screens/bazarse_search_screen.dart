import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';

/// 🔥 AMAZING BAZARSE SEARCH SCREEN WITH AUTO-SUGGESTIONS 🔥
class BazarseSearchScreen extends StatefulWidget {
  const BazarseSearchScreen({super.key});

  @override
  State<BazarseSearchScreen> createState() => _BazarseSearchScreenState();
}

class _BazarseSearchScreenState extends State<BazarseSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAIPoweredSearchEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header with Search Bar
              _buildSearchHeader(),

              // AI Powered Search Toggle - Small
              _buildSmallAIToggle(),

              // Main Content Area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Start typing to search',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isAIPoweredSearchEnabled
                            ? 'AI will help you find better results'
                            : 'Using standard search',
                        style: GoogleFonts.inter(
                          color: _isAIPoweredSearchEnabled
                              ? AppColors.gradientStart
                              : Colors.white.withValues(alpha: 0.4),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 SEARCH HEADER WITH ANIMATED SEARCH BAR 🔥
  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),

          // Search Bar
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientStart.withValues(alpha: 0.3),
                    AppColors.gradientEnd.withValues(alpha: 0.3),
                  ],
                ),
                border: Border.all(
                  color: AppColors.gradientStart.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search products, stores, services...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.gradientStart,
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 SMALL AI TOGGLE 🔥
  Widget _buildSmallAIToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            color: _isAIPoweredSearchEnabled
                ? AppColors.gradientStart
                : Colors.white.withValues(alpha: 0.5),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'AI Powered Search',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: _isAIPoweredSearchEnabled,
            onChanged: (value) {
              setState(() {
                _isAIPoweredSearchEnabled = value;
              });
            },
            thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.gradientStart;
                }
                return Colors.white.withValues(alpha: 0.7);
              },
            ),
            trackColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.gradientStart.withValues(alpha: 0.3);
                }
                return Colors.white.withValues(alpha: 0.2);
              },
            ),
          ),
        ],
      ),
    );
  }
}
