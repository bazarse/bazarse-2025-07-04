import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/colors.dart';
import '../models/saved_location_model.dart';
import '../services/enhanced_location_service.dart';

// 🗺️ LOCATION MAP WIDGET - HALF SCREEN MAP FOR ADDRESS SELECTION 🗺️
class LocationMapWidget extends StatefulWidget {
  final SavedLocationModel? initialLocation;
  final Function(SavedLocationModel) onLocationSelected;
  final String title;

  const LocationMapWidget({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
    this.title = 'Select Location on Map',
  });

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  SavedLocationModel? _selectedLocationModel;
  bool _isLoading = false;
  final EnhancedLocationService _locationService = EnhancedLocationService();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() {
    if (widget.initialLocation != null) {
      _selectedLocation = LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
      _selectedLocationModel = widget.initialLocation;
    } else {
      // Default to a central location (can be changed based on user's city)
      _selectedLocation = const LatLng(23.1815, 75.7849); // Ujjain
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5, // Half screen
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMap()),
          _buildBottomControls(),
        ],
      ),
    );
  }

  // 📱 HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Tap on map to select precise location',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Current location button
          IconButton(
            onPressed: _getCurrentLocation,
            icon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.gradientStart),
                    ),
                  )
                : const Icon(Icons.my_location, color: AppColors.gradientStart),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.gradientStart.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🗺️ MAP
  Widget _buildMap() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _setMapStyle();
        },
        initialCameraPosition: CameraPosition(
          target: _selectedLocation!,
          zoom: 16.0,
        ),
        onTap: _onMapTapped,
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: const MarkerId('selected_location'),
                  position: _selectedLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                  infoWindow: InfoWindow(
                    title: _selectedLocationModel?.customName ?? 'Selected Location',
                    snippet: _selectedLocationModel?.shortAddress ?? 'Tap to confirm',
                  ),
                ),
              }
            : {},
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        trafficEnabled: false,
        buildingsEnabled: true,
        indoorViewEnabled: false,
      ),
    );
  }

  // 🎮 BOTTOM CONTROLS
  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected location info
          if (_selectedLocationModel != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gradientStart.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedLocationModel!.customName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedLocationModel!.detailedAddress,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          
          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedLocationModel != null ? _confirmLocation : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientStart,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm Location',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🎯 MAP TAP HANDLER
  void _onMapTapped(LatLng location) async {
    setState(() {
      _selectedLocation = location;
      _isLoading = true;
    });

    try {
      // Reverse geocode the tapped location
      SavedLocationModel? locationModel = await _locationService.getCurrentLocation();
      
      if (locationModel != null) {
        setState(() {
          _selectedLocationModel = locationModel.copyWith(
            id: 'map_selected_${DateTime.now().millisecondsSinceEpoch}',
            latitude: location.latitude,
            longitude: location.longitude,
            customName: 'Selected Location',
          );
        });
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 📍 GET CURRENT LOCATION
  void _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _selectedLocation = currentLatLng;
      });

      // Move camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLatLng),
      );

      // Trigger reverse geocoding
      _onMapTapped(currentLatLng);
    } catch (e) {
      debugPrint('Error getting current location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ CONFIRM LOCATION
  void _confirmLocation() {
    if (_selectedLocationModel != null) {
      widget.onLocationSelected(_selectedLocationModel!);
      Navigator.pop(context);
    }
  }

  // 🎨 SET MAP STYLE (DARK THEME)
  void _setMapStyle() {
    const String mapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [{"color": "#1d2c4d"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#8ec3b9"}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "#1a3646"}]
      },
      {
        "featureType": "administrative.country",
        "elementType": "geometry.stroke",
        "stylers": [{"color": "#4b6878"}]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [{"color": "#304a7d"}]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{"color": "#0e1626"}]
      }
    ]
    ''';
    
    _mapController?.setMapStyle(mapStyle);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
