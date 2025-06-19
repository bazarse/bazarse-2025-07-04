import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/location_context.dart';
import '../services/bazarse_location_service.dart';
import '../widgets/animated_background.dart';

// 🚀 UNIVERSAL LOCATION MODAL - GPS, SEARCH, SAVED LOCATIONS 🚀
class UniversalLocationModal extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(LocationContext) onLocationSelected;

  const UniversalLocationModal({
    super.key,
    this.title = 'Select Location',
    this.subtitle = 'Choose your location for personalized offers',
    required this.onLocationSelected,
  });

  @override
  State<UniversalLocationModal> createState() => _UniversalLocationModalState();
}

class _UniversalLocationModalState extends State<UniversalLocationModal>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<LocationContext> _searchResults = [];
  bool _isSearching = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          // Animated background
          const AnimatedBackground(child: SizedBox.expand()),

          // Content
          Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCurrentLocationTab(),
                    _buildSearchTab(),
                    _buildSavedLocationsTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 📱 HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            widget.subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 📑 TAB BAR
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.my_location, size: 20), text: 'Current'),
          Tab(icon: Icon(Icons.search, size: 20), text: 'Search'),
          Tab(icon: Icon(Icons.bookmark, size: 20), text: 'Saved'),
        ],
      ),
    );
  }

  // 📍 CURRENT LOCATION TAB
  Widget _buildCurrentLocationTab() {
    return Consumer<BazarseLocationService>(
      builder: (context, locationService, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Current location display
              if (locationService.currentLocation != null)
                _buildLocationCard(
                  locationService.currentLocation!,
                  isSelected: true,
                  subtitle: 'Current Location',
                ),

              const SizedBox(height: 20),

              // Detect location button
              _buildDetectLocationButton(locationService),

              const SizedBox(height: 20),

              // Error display
              if (locationService.error != null)
                _buildErrorCard(locationService.error!),
            ],
          ),
        );
      },
    );
  }

  // 🔍 SEARCH TAB
  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          const SizedBox(height: 20),

          // Search results
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.gradientStart,
                    ),
                  )
                : _searchResults.isEmpty
                ? _buildEmptySearchState()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  // 💾 SAVED LOCATIONS TAB
  Widget _buildSavedLocationsTab() {
    return Consumer<BazarseLocationService>(
      builder: (context, locationService, child) {
        final savedLocations = locationService.savedLocations;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: savedLocations.isEmpty
              ? _buildEmptySavedState()
              : ListView.builder(
                  itemCount: savedLocations.length,
                  itemBuilder: (context, index) {
                    final location = savedLocations[index];
                    return _buildLocationCard(
                      location,
                      onTap: () => _selectLocation(location),
                      showDelete: true,
                      onDelete: () =>
                          locationService.removeSavedLocation(location),
                    );
                  },
                ),
        );
      },
    );
  }

  // 🔍 SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by street, area, or city...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.6),
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.gradientStart),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  // 📍 DETECT LOCATION BUTTON
  Widget _buildDetectLocationButton(BazarseLocationService locationService) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locationService.isLoading
              ? null
              : () => _detectCurrentLocation(),
          child: Center(
            child: locationService.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.my_location, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Detect Current Location',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // 📍 LOCATION CARD
  Widget _buildLocationCard(
    LocationContext location, {
    VoidCallback? onTap,
    bool isSelected = false,
    String? subtitle,
    bool showDelete = false,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.gradientStart.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppColors.gradientStart, width: 2)
            : Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap ?? () => _selectLocation(location),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Location icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Location details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.homeDisplayFormat,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            color: AppColors.gradientStart,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Delete button
                if (showDelete)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: onDelete,
                  ),

                // Selected indicator
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.gradientStart,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ❌ ERROR CARD
  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 SEARCH RESULTS
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final location = _searchResults[index];
        return _buildLocationCard(
          location,
          onTap: () => _selectLocation(location),
        );
      },
    );
  }

  // 🔍 EMPTY SEARCH STATE
  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for your location',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type street, area, or city name',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 💾 EMPTY SAVED STATE
  Widget _buildEmptySavedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No saved locations',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Locations you select will appear here',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 SEARCH CHANGED
  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        _performSearch(query);
      }
    });
  }

  // 🔍 PERFORM SEARCH
  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final locationService = Provider.of<BazarseLocationService>(
        context,
        listen: false,
      );
      final results = await locationService.searchLocations(query);

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // 📍 DETECT CURRENT LOCATION
  Future<void> _detectCurrentLocation() async {
    final locationService = Provider.of<BazarseLocationService>(
      context,
      listen: false,
    );
    final location = await locationService.getCurrentLocation();

    if (location != null) {
      _selectLocation(location);
    }
  }

  // ✅ SELECT LOCATION
  void _selectLocation(LocationContext location) {
    widget.onLocationSelected(location);
    Navigator.of(context).pop();
  }

  // 📱 SHOW MODAL
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? subtitle,
    required Function(LocationContext) onLocationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UniversalLocationModal(
        title: title ?? 'Select Location',
        subtitle: subtitle ?? 'Choose your location for personalized offers',
        onLocationSelected: onLocationSelected,
      ),
    );
  }
}
