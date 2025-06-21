import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/saved_location_model.dart';

// 🚀 ENHANCED LOCATION SERVICE - ZOMATO/SWIGGY STYLE LOCATION MANAGEMENT 🚀
class EnhancedLocationService extends ChangeNotifier {
  static const String _savedLocationsKey = 'bazarse_enhanced_saved_locations';
  static const String _currentLocationKey = 'bazarse_enhanced_current_location';
  static const String _googleApiKey = 'AIzaSyDexYes91JK03iFpCtLIE65J0FoUEYlFRI';

  // 🌍 STATE MANAGEMENT
  List<SavedLocationModel> _savedLocations = [];
  SavedLocationModel? _currentLocation;
  bool _isLoading = false;
  String? _error;

  // 📍 GETTERS
  List<SavedLocationModel> get savedLocations => _savedLocations;
  SavedLocationModel? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCurrentLocation => _currentLocation != null;

  // 🏠 GET LOCATIONS BY TYPE
  SavedLocationModel? get homeLocation {
    final homeLocations = _savedLocations.where((loc) => loc.type == SavedLocationType.home);
    return homeLocations.isNotEmpty ? homeLocations.first : null;
  }

  SavedLocationModel? get workLocation {
    final workLocations = _savedLocations.where((loc) => loc.type == SavedLocationType.work);
    return workLocations.isNotEmpty ? workLocations.first : null;
  }
  
  List<SavedLocationModel> get otherLocations => 
      _savedLocations.where((loc) => loc.type == SavedLocationType.other).toList();

  // 🚀 INITIALIZE SERVICE
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _loadSavedLocations();
      await _loadCurrentLocation();
    } catch (e) {
      _setError('Failed to initialize location service: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 📍 GET CURRENT LOCATION WITH HIGH ACCURACY
  Future<SavedLocationModel?> getCurrentLocation() async {
    _setLoading(true);
    _setError(null);

    try {
      // 1. Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setError('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setError('Location permissions are permanently denied');
        return null;
      }

      // 2. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('Location services are disabled');
        return null;
      }

      // 3. Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).timeout(const Duration(seconds: 20));

      // 4. Reverse geocode to get detailed address
      SavedLocationModel? location = await _reverseGeocodeToSavedLocation(
        position.latitude,
        position.longitude,
      );

      if (location != null) {
        await _setCurrentLocation(location);
        return location;
      } else {
        _setError('Failed to get address from coordinates');
        return null;
      }
    } catch (e) {
      _setError('Failed to get current location: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // 🔍 REVERSE GEOCODE TO SAVED LOCATION MODEL
  Future<SavedLocationModel?> _reverseGeocodeToSavedLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Build address components
        String? streetAddress = place.name ?? place.thoroughfare;
        String locality = place.subLocality ?? place.locality ?? 'Unknown Area';
        String city = place.locality ?? place.administrativeArea ?? 'Unknown City';
        String state = place.administrativeArea ?? 'Unknown State';
        String? postalCode = place.postalCode;

        // Build full address
        List<String> addressParts = [];
        if (streetAddress != null && streetAddress.isNotEmpty) {
          addressParts.add(streetAddress);
        }
        addressParts.add(locality);
        addressParts.add(city);
        addressParts.add(state);
        if (postalCode != null && postalCode.isNotEmpty) {
          addressParts.add(postalCode);
        }

        return SavedLocationModel(
          id: 'current_${DateTime.now().millisecondsSinceEpoch}',
          customName: 'Current Location',
          fullAddress: addressParts.join(', '),
          streetAddress: streetAddress,
          locality: locality,
          city: city,
          state: state,
          postalCode: postalCode,
          latitude: latitude,
          longitude: longitude,
          type: SavedLocationType.other,
        );
      }
    } catch (e) {
      debugPrint('Error in reverse geocoding: $e');
    }
    return null;
  }

  // 💾 SAVE LOCATION
  Future<bool> saveLocation(SavedLocationModel location) async {
    try {
      // Remove existing location of same type (only one home/work allowed)
      if (location.type != SavedLocationType.other) {
        _savedLocations.removeWhere((loc) => loc.type == location.type);
      }

      // Add new location
      _savedLocations.insert(0, location);

      // Keep only last 20 locations for 'other' type
      List<SavedLocationModel> otherLocs = _savedLocations
          .where((loc) => loc.type == SavedLocationType.other)
          .toList();
      if (otherLocs.length > 20) {
        for (int i = 20; i < otherLocs.length; i++) {
          _savedLocations.remove(otherLocs[i]);
        }
      }

      await _saveSavedLocations();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to save location: $e');
      return false;
    }
  }

  // 🗑️ DELETE LOCATION
  Future<bool> deleteLocation(String locationId) async {
    try {
      _savedLocations.removeWhere((loc) => loc.id == locationId);
      await _saveSavedLocations();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete location: $e');
      return false;
    }
  }

  // ✏️ UPDATE LOCATION
  Future<bool> updateLocation(SavedLocationModel updatedLocation) async {
    try {
      int index = _savedLocations.indexWhere((loc) => loc.id == updatedLocation.id);
      if (index != -1) {
        _savedLocations[index] = updatedLocation.copyWith(lastUsed: DateTime.now());
        await _saveSavedLocations();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update location: $e');
      return false;
    }
  }

  // 🎯 SET CURRENT LOCATION
  Future<void> setCurrentLocation(SavedLocationModel location) async {
    await _setCurrentLocation(location);
    notifyListeners();
  }

  // 🔍 SEARCH LOCATIONS USING GOOGLE PLACES API
  Future<List<SavedLocationModel>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=${Uri.encodeComponent(query)}'
          '&key=$_googleApiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        return results.take(10).map((result) {
          return SavedLocationModel(
            id: 'search_${result['place_id']}',
            customName: result['name'] ?? 'Unknown Place',
            fullAddress: result['formatted_address'] ?? '',
            locality: _extractLocalityFromAddress(result['formatted_address'] ?? ''),
            city: _extractCityFromAddress(result['formatted_address'] ?? ''),
            state: _extractStateFromAddress(result['formatted_address'] ?? ''),
            latitude: result['geometry']['location']['lat'].toDouble(),
            longitude: result['geometry']['location']['lng'].toDouble(),
            type: SavedLocationType.other,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('Error searching locations: $e');
    }
    return [];
  }

  // 🏷️ HELPER METHODS FOR ADDRESS EXTRACTION
  String _extractLocalityFromAddress(String address) {
    List<String> parts = address.split(', ');
    return parts.length > 1 ? parts[1] : 'Unknown Area';
  }

  String _extractCityFromAddress(String address) {
    List<String> parts = address.split(', ');
    return parts.length > 2 ? parts[2] : 'Unknown City';
  }

  String _extractStateFromAddress(String address) {
    List<String> parts = address.split(', ');
    return parts.length > 3 ? parts[3] : 'Unknown State';
  }

  // 💾 PRIVATE STORAGE METHODS
  Future<void> _saveSavedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = _savedLocations.map((loc) => loc.toJsonString()).toList();
      await prefs.setStringList(_savedLocationsKey, locationsJson);
    } catch (e) {
      debugPrint('Error saving locations: $e');
    }
  }

  Future<void> _loadSavedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getStringList(_savedLocationsKey) ?? [];
      _savedLocations = locationsJson
          .map((json) => SavedLocationModel.fromJsonString(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading saved locations: $e');
      _savedLocations = [];
    }
  }

  Future<void> _setCurrentLocation(SavedLocationModel location) async {
    _currentLocation = location;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentLocationKey, location.toJsonString());
    } catch (e) {
      debugPrint('Error saving current location: $e');
    }
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationJson = prefs.getString(_currentLocationKey);
      if (locationJson != null) {
        _currentLocation = SavedLocationModel.fromJsonString(locationJson);
      }
    } catch (e) {
      debugPrint('Error loading current location: $e');
    }
  }

  // 🔧 UTILITY METHODS
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
