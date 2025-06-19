// 🔥 VINU BHAISAHAB'S OUTSTANDING LOCATION SELECTION SCREEN 🔥
// Better than Zomato, Swiggy, Blinkit combined! 🚀

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../services/location_service.dart';

class OutstandingLocationScreen extends StatefulWidget {
  const OutstandingLocationScreen({super.key});

  @override
  State<OutstandingLocationScreen> createState() =>
      _OutstandingLocationScreenState();
}

class _OutstandingLocationScreenState extends State<OutstandingLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  LocationModel? _currentLocation;
  List<LocationModel> _savedLocations = [];
  List<LocationModel> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load current location
      _currentLocation = await LocationService.getCurrentLocation();

      // Load saved locations
      _savedLocations = await LocationService.getSavedLocations();

      setState(() {});
    } catch (e) {
      print('Error loading data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      List<LocationModel> results = await LocationService.searchLocations(
        query,
      );
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error searching locations: $e');
    }

    setState(() {
      _isSearching = false;
    });
  }

  Future<void> _saveLocation(LocationModel location) async {
    // Show dialog to choose location type
    LocationType? selectedType = await _showSaveLocationDialog();

    if (selectedType != null) {
      String? customName;

      if (selectedType == LocationType.custom) {
        customName = await _showCustomNameDialog();
        if (customName == null || customName.trim().isEmpty) return;
      }

      bool success = await LocationService.saveLocation(
        location,
        selectedType,
        customName,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location saved as ${selectedType.displayName}'),
            backgroundColor: AppColors.gradientStart,
          ),
        );
        _loadData(); // Refresh saved locations
      }
    }
  }

  Future<LocationType?> _showSaveLocationDialog() async {
    return showDialog<LocationType>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        title: Text(
          'Save Location As',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLocationTypeOption(LocationType.home),
            _buildLocationTypeOption(LocationType.work),
            _buildLocationTypeOption(LocationType.custom),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTypeOption(LocationType type) {
    return ListTile(
      leading: Text(type.emoji, style: const TextStyle(fontSize: 24)),
      title: Text(
        type.displayName,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => Navigator.of(context).pop(type),
    );
  }

  Future<String?> _showCustomNameDialog() async {
    TextEditingController nameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        title: Text(
          'Enter Location Name',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: nameController,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g., Gym, Friend\'s Place',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gradientStart),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gradientStart),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(nameController.text),
            child: Text(
              'Save',
              style: GoogleFonts.poppins(color: AppColors.gradientStart),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLocation(LocationModel location) async {
    bool success = await LocationService.deleteLocation(location.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location deleted'),
          backgroundColor: Colors.red,
        ),
      );
      _loadData(); // Refresh saved locations
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
              // 🔥 OUTSTANDING Header 🔥
              _buildOutstandingHeader(),

              // 🔍 OUTSTANDING Search Bar 🔍
              _buildOutstandingSearchBar(),

              // 📍 OUTSTANDING Content 📍
              Expanded(child: _buildOutstandingContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutstandingHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
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
            'Choose Location',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 600));
  }

  Widget _buildOutstandingSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientStart.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _searchLocation,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search for area, street name...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    ).animate().slideY(begin: -0.5, end: 0).fadeIn();
  }

  Widget _buildOutstandingContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📍 Current Location Section
          if (_currentLocation != null) _buildCurrentLocationSection(),

          const SizedBox(height: 24),

          // 💾 Saved Locations Section
          if (_savedLocations.isNotEmpty) _buildSavedLocationsSection(),

          // 🔍 Search Results Section
          if (_searchResults.isNotEmpty) _buildSearchResultsSection(),

          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildCurrentLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Location',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _buildLocationCard(
          icon: Icons.my_location,
          title: _currentLocation!.displayName,
          subtitle: _currentLocation!.fullAddress,
          onTap: () => Navigator.of(context).pop(_currentLocation!.displayName),
          trailing: IconButton(
            icon: const Icon(Icons.bookmark_add, color: Colors.white),
            onPressed: () => _saveLocation(_currentLocation!),
          ),
        ),
      ],
    ).animate().slideX(begin: -0.3, end: 0).fadeIn();
  }

  Widget _buildSavedLocationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Locations',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_savedLocations.length, (index) {
          LocationModel location = _savedLocations[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
                _buildLocationCard(
                      icon: _getLocationIcon(location.type),
                      title: '${location.type.emoji} ${location.displayName}',
                      subtitle: location.fullAddress,
                      badge: location.type.displayName,
                      onTap: () =>
                          Navigator.of(context).pop(location.displayName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteLocation(location),
                      ),
                    )
                    .animate(delay: Duration(milliseconds: index * 100))
                    .slideX(begin: -0.3, end: 0)
                    .fadeIn(),
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSearchResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Search Results',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (_isSearching) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_searchResults.length, (index) {
          LocationModel location = _searchResults[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
                _buildLocationCard(
                      icon: Icons.location_on,
                      title: location.displayName,
                      subtitle: location.fullAddress,
                      onTap: () =>
                          Navigator.of(context).pop(location.displayName),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.bookmark_add,
                          color: Colors.white,
                        ),
                        onPressed: () => _saveLocation(location),
                      ),
                    )
                    .animate(delay: Duration(milliseconds: index * 100))
                    .slideX(begin: 0.3, end: 0)
                    .fadeIn(),
          );
        }),
      ],
    );
  }

  Widget _buildLocationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing],
          ],
        ),
      ),
    );
  }

  IconData _getLocationIcon(LocationType type) {
    switch (type) {
      case LocationType.home:
        return Icons.home;
      case LocationType.work:
        return Icons.work;
      case LocationType.custom:
        return Icons.location_on;
    }
  }
}
