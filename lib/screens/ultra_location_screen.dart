import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../services/advanced_location_service.dart';

import '../models/enhanced_location_model.dart';
import '../widgets/animated_background.dart';

// 🚀 ULTRA LOCATION SCREEN - DELIVERY APP LEVEL 🚀
class UltraLocationScreen extends StatefulWidget {
  const UltraLocationScreen({super.key});

  @override
  State<UltraLocationScreen> createState() => _UltraLocationScreenState();
}

class _UltraLocationScreenState extends State<UltraLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  LocationModel? _currentLocation;
  List<LocationModel> _searchResults = [];
  List<LocationModel> _nearbyLandmarks = [];
  List<LocationModel> _savedLocations = [];
  bool _isSearching = false;
  bool _isGettingLocation = false;
  bool _showLandmarkInput = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadSavedLocations();
  }

  // 📍 GET CURRENT LOCATION WITH HIGH ACCURACY 📍
  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      final location = await AdvancedLocationService.getUltraPreciseLocation();
      if (location != null) {
        setState(() => _currentLocation = location);
        _getNearbyLandmarks();
        print('✅ Current location: ${location.displayName}');
      }
    } catch (e) {
      print('Error getting current location: $e');
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  // 🏢 GET NEARBY LANDMARKS 🏢
  Future<void> _getNearbyLandmarks() async {
    if (_currentLocation == null) return;

    try {
      final landmarks = await AdvancedLocationService.getNearbyLandmarks(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
      setState(() => _nearbyLandmarks = landmarks);
    } catch (e) {
      print('Error getting nearby landmarks: $e');
    }
  }

  // 🔍 SEARCH LOCATIONS WITH NEIGHBORHOODS & LOCALITIES 🔍
  Future<void> _searchLocations(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results =
          await AdvancedLocationService.searchLocationsWithAutocomplete(query);
      setState(() => _searchResults = results);
      print('✅ Found ${results.length} locations for: $query');
    } catch (e) {
      print('Error searching locations: $e');
      setState(() => _searchResults = []);
    } finally {
      setState(() => _isSearching = false);
    }
  }

  // 💾 LOAD SAVED LOCATIONS 💾
  void _loadSavedLocations() {
    // Mock saved locations - in production, load from local storage
    setState(() {
      _savedLocations = [
        LocationModel(
          id: 'home',
          displayName: 'Home',
          fullAddress: 'Sample Home Address',
          latitude: 23.1942901,
          longitude: 75.7754718,
          type: LocationType.home,
        ),
        LocationModel(
          id: 'work',
          displayName: 'Work',
          fullAddress: 'Sample Work Address',
          latitude: 23.1942901,
          longitude: 75.7754718,
          type: LocationType.work,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Location',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedBackground(
        child: Column(
          children: [
            // 🔍 SEARCH BAR 🔍
            _buildSearchBar(),

            // 📍 CURRENT LOCATION 📍
            if (_currentLocation != null) _buildCurrentLocationCard(),

            // 📋 CONTENT 📋
            Expanded(
              child: _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildLocationOptions(),
            ),
          ],
        ),
      ),
    );
  }

  // 🔍 SEARCH BAR 🔍
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for area, street name...',
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.gradientStart),
          suffixIcon: _isSearching
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: _searchLocations,
      ),
    );
  }

  // 📍 CURRENT LOCATION CARD 📍
  Widget _buildCurrentLocationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gradientStart.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.my_location,
              color: AppColors.gradientStart,
              size: 20,
            ),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _currentLocation!.shortAddress,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _currentLocation!.areaName,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _currentLocation),
            child: Text(
              'Use This',
              style: GoogleFonts.inter(
                color: AppColors.gradientStart,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 SEARCH RESULTS 🔍
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && !_isSearching) {
      return Center(
        child: Text(
          'No locations found',
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final location = _searchResults[index];
        return _buildLocationTile(location);
      },
    );
  }

  // 📋 LOCATION OPTIONS 📋
  Widget _buildLocationOptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saved Locations
          if (_savedLocations.isNotEmpty) ...[
            _buildSectionHeader('Saved Locations'),
            ..._savedLocations.map((location) => _buildLocationTile(location)),
            const SizedBox(height: 16),
          ],

          // Nearby Landmarks
          if (_nearbyLandmarks.isNotEmpty) ...[
            _buildSectionHeader('Nearby Landmarks'),
            ..._nearbyLandmarks.map((location) => _buildLocationTile(location)),
          ],
        ],
      ),
    );
  }

  // 📝 SECTION HEADER 📝
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 📍 LOCATION TILE 📍
  Widget _buildLocationTile(LocationModel location) {
    IconData icon;
    Color iconColor;

    switch (location.type) {
      case LocationType.home:
        icon = Icons.home;
        iconColor = Colors.green;
        break;
      case LocationType.work:
        icon = Icons.work;
        iconColor = Colors.blue;
        break;
      case LocationType.landmark:
        icon = Icons.place;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.location_on;
        iconColor = AppColors.gradientStart;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 20),
        title: Text(
          location.displayName,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          location.shortAddress,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        onTap: () => Navigator.pop(context, location),
        tileColor: Colors.white.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
