import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../services/location_service.dart';
import '../widgets/animated_background.dart';

// 🏆 COMPREHENSIVE LOCATION SCREEN - Beats Zomato! 🏆
class ComprehensiveLocationScreen extends StatefulWidget {
  const ComprehensiveLocationScreen({super.key});

  @override
  State<ComprehensiveLocationScreen> createState() =>
      _ComprehensiveLocationScreenState();
}

class _ComprehensiveLocationScreenState
    extends State<ComprehensiveLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> _searchResults = [];
  List<LocationModel> _savedLocations = [];
  bool _isSearching = false;
  bool _isLoadingSaved = true;
  LocationModel? _currentLocation;

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🔥 LOAD SAVED LOCATIONS 🔥
  Future<void> _loadSavedLocations() async {
    setState(() => _isLoadingSaved = true);
    try {
      List<LocationModel> locations = await LocationService.getSavedLocations();
      setState(() {
        _savedLocations = locations;
        _isLoadingSaved = false;
      });
    } catch (e) {
      setState(() => _isLoadingSaved = false);
    }
  }

  // 📍 GET CURRENT LOCATION 📍
  Future<void> _getCurrentLocation() async {
    try {
      LocationModel? location = await LocationService.getCurrentLocation();
      setState(() => _currentLocation = location);
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  // 🔍 SEARCH LOCATIONS 🔍
  Future<void> _searchLocations(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    try {
      List<LocationModel> results = await LocationService.searchLocations(
        query,
      );
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  // 💾 SAVE LOCATION 💾
  Future<void> _saveLocation(
    LocationModel location,
    LocationType type, [
    String? customName,
  ]) async {
    bool success = await LocationService.saveLocation(
      location,
      type,
      customName,
    );
    if (success) {
      _loadSavedLocations();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location saved successfully!'),
          backgroundColor: AppColors.gradientStart,
        ),
      );
    }
  }

  // 🗑️ DELETE LOCATION 🗑️
  Future<void> _deleteLocation(String locationId) async {
    bool success = await LocationService.deleteLocation(locationId);
    if (success) {
      _loadSavedLocations();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location deleted successfully!'),
          backgroundColor: AppColors.gradientStart,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 🔝 HEADER 🔝
              _buildHeader(),

              // 🔍 SEARCH BAR 🔍
              _buildSearchBar(),

              // 📍 CURRENT LOCATION 📍
              if (_currentLocation != null) _buildCurrentLocation(),

              // 📋 CONTENT 📋
              Expanded(
                child: _searchController.text.isNotEmpty
                    ? _buildSearchResults()
                    : _buildSavedLocations(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔝 HEADER WIDGET 🔝
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gradientStart.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Choose Location',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 SEARCH BAR WIDGET 🔍
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _searchLocations,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Search for area, street name...',
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.gradientStart,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // 📍 CURRENT LOCATION WIDGET 📍
  Widget _buildCurrentLocation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.my_location, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: GoogleFonts.inter(
                    color: AppColors.gradientStart,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _currentLocation!.displayName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context, _currentLocation),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Use',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 SEARCH RESULTS WIDGET 🔍
  Widget _buildSearchResults() {
    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.gradientStart,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Searching locations...',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 60,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No locations found',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        LocationModel location = _searchResults[index];
        return _buildLocationItem(location, isSearchResult: true);
      },
    );
  }

  // 📋 SAVED LOCATIONS WIDGET 📋
  Widget _buildSavedLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Saved Locations',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: _isLoadingSaved
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.gradientStart,
                    ),
                  ),
                )
              : _savedLocations.isEmpty
              ? _buildEmptySavedLocations()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _savedLocations.length,
                  itemBuilder: (context, index) {
                    LocationModel location = _savedLocations[index];
                    return _buildLocationItem(location, isSearchResult: false);
                  },
                ),
        ),
      ],
    );
  }

  // 📍 LOCATION ITEM WIDGET 📍
  Widget _buildLocationItem(
    LocationModel location, {
    required bool isSearchResult,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context, location),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.location_on, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.displayName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location.fullAddress,
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isSearchResult)
                  GestureDetector(
                    onTap: () => _showSaveLocationDialog(location),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gradientStart.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.bookmark_add,
                        color: AppColors.gradientStart,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📭 EMPTY SAVED LOCATIONS WIDGET 📭
  Widget _buildEmptySavedLocations() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 60,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No saved locations',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 💾 SAVE LOCATION DIALOG 💾
  void _showSaveLocationDialog(LocationModel location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.gradientStart.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Save Location',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSaveOption('🏠 Home', LocationType.home, location),
            const SizedBox(height: 12),
            _buildSaveOption('🏢 Work', LocationType.work, location),
            const SizedBox(height: 12),
            _buildSaveOption('📍 Custom', LocationType.custom, location),
          ],
        ),
      ),
    );
  }

  // 💾 SAVE OPTION WIDGET 💾
  Widget _buildSaveOption(
    String title,
    LocationType type,
    LocationModel location,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _saveLocation(location, type);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gradientStart.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
