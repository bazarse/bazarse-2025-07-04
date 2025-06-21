import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/location_map_widget.dart';
import '../widgets/save_location_dialog.dart';
import '../models/saved_location_model.dart';
import '../services/enhanced_location_service.dart';

// 📍 ADD LOCATION SCREEN - ZOMATO/SWIGGY STYLE LOCATION MANAGEMENT 📍
class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SavedLocationModel> _searchResults = [];
  bool _isSearching = false;
  EnhancedLocationService? _locationService;

  @override
  void initState() {
    super.initState();
    _locationService = Provider.of<EnhancedLocationService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildQuickActions(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  // 📱 HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Location',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Search or select location on map',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search for area, street name...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_isSearching)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.gradientStart),
              ),
            ),
        ],
      ),
    );
  }

  // ⚡ QUICK ACTIONS
  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Use current location
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.my_location,
              title: 'Use Current Location',
              subtitle: 'Auto-detect your location',
              onTap: _useCurrentLocation,
            ),
          ),
          const SizedBox(width: 12),
          
          // Select on map
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.map,
              title: 'Select on Map',
              subtitle: 'Choose precise location',
              onTap: _selectOnMap,
            ),
          ),
        ],
      ),
    );
  }

  // 🎯 QUICK ACTION CARD
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gradientStart.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate()
     .slideY(begin: 0.3, end: 0)
     .fadeIn();
  }

  // 📋 CONTENT
  Widget _buildContent() {
    if (_searchController.text.isNotEmpty && _searchResults.isNotEmpty) {
      return _buildSearchResults();
    } else if (_searchController.text.isNotEmpty && !_isSearching) {
      return _buildNoResults();
    } else {
      return _buildSavedLocations();
    }
  }

  // 🔍 SEARCH RESULTS
  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        SavedLocationModel location = _searchResults[index];
        return _buildLocationCard(
          location: location,
          onTap: () => _showSaveLocationDialog(location),
          trailing: const Icon(
            Icons.add_circle_outline,
            color: AppColors.gradientStart,
          ),
        ).animate(delay: Duration(milliseconds: index * 100))
         .slideX(begin: 0.3, end: 0)
         .fadeIn();
      },
    );
  }

  // ❌ NO RESULTS
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No locations found',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 💾 SAVED LOCATIONS
  Widget _buildSavedLocations() {
    return Consumer<EnhancedLocationService>(
      builder: (context, locationService, child) {
        if (locationService.savedLocations.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: locationService.savedLocations.length,
          itemBuilder: (context, index) {
            SavedLocationModel location = locationService.savedLocations[index];
            return _buildLocationCard(
              location: location,
              onTap: () => _selectSavedLocation(location),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _editLocation(location),
              ),
              showType: true,
            ).animate(delay: Duration(milliseconds: index * 100))
             .slideX(begin: -0.3, end: 0)
             .fadeIn();
          },
        );
      },
    );
  }

  // 🏜️ EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No saved locations',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first location to get started',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 📍 LOCATION CARD
  Widget _buildLocationCard({
    required SavedLocationModel location,
    required VoidCallback onTap,
    Widget? trailing,
    bool showType = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gradientStart.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    showType ? Icons.location_on : Icons.search,
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
                        showType ? location.displayTitle : location.customName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location.detailedAddress,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔍 SEARCH HANDLER
  void _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      List<SavedLocationModel> results = await _locationService!.searchLocations(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  // 📍 USE CURRENT LOCATION
  void _useCurrentLocation() async {
    SavedLocationModel? currentLocation = await _locationService!.getCurrentLocation();
    if (currentLocation != null) {
      _showSaveLocationDialog(currentLocation);
    }
  }

  // 🗺️ SELECT ON MAP
  void _selectOnMap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationMapWidget(
        onLocationSelected: _showSaveLocationDialog,
      ),
    );
  }

  // 💾 SHOW SAVE LOCATION DIALOG
  void _showSaveLocationDialog(SavedLocationModel location) {
    showDialog(
      context: context,
      builder: (context) => SaveLocationDialog(
        location: location,
        onLocationSaved: (savedLocation) {
          Navigator.pop(context, savedLocation);
        },
      ),
    );
  }

  // ✅ SELECT SAVED LOCATION
  void _selectSavedLocation(SavedLocationModel location) {
    Navigator.pop(context, location);
  }

  // ✏️ EDIT LOCATION
  void _editLocation(SavedLocationModel location) {
    _showSaveLocationDialog(location);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
