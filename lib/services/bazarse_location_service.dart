import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/location_context.dart';

// 🚀 BAZARSE LOCATION SERVICE - HYPERLOCAL LOCATION MANAGEMENT 🚀
class BazarseLocationService extends ChangeNotifier {
  static const String _locationKey = 'bazarse_location_context';
  static const String _savedLocationsKey = 'bazarse_saved_locations';
  static const String _googleApiKey = 'AIzaSyDexYes91JK03iFpCtLIE65J0FoUEYlFRI';

  // 🌍 GLOBAL LOCATION CONTEXT
  LocationContext? _currentLocation;
  List<LocationContext> _savedLocations = [];
  bool _isLoading = false;
  String? _error;

  // GETTERS
  LocationContext? get currentLocation => _currentLocation;
  List<LocationContext> get savedLocations => _savedLocations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _currentLocation != null && _currentLocation!.isValid;

  // 🚀 INITIALIZE LOCATION SERVICE
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Load saved location from storage
      await _loadSavedLocationFromStorage();

      // Load saved locations list
      await _loadSavedLocationsList();

      // If no saved location, try to get current location
      if (!hasLocation) {
        await getCurrentLocation();
      }
    } catch (e) {
      _setError('Failed to initialize location service: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 📍 GET CURRENT LOCATION WITH HIGH ACCURACY
  Future<LocationContext?> getCurrentLocation() async {
    _setLoading(true);
    _setError(null);

    try {
      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('Location services are disabled. Please enable them.');
        return null;
      }

      // 2. Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setError('Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setError('Location permissions are permanently denied.');
        return null;
      }

      // 3. Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15));

      // 4. Reverse geocode to get address components
      LocationContext? locationContext = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );

      if (locationContext != null) {
        await setCurrentLocation(locationContext);
        return locationContext;
      } else {
        _setError('Failed to get address from coordinates.');
        return null;
      }
    } catch (e) {
      _setError('Failed to get current location: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // 🔍 REVERSE GEOCODING - COORDINATES TO ADDRESS
  Future<LocationContext?> _reverseGeocode(double lat, double lng) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?'
          'latlng=$lat,$lng&'
          'key=$_googleApiKey&'
          'result_type=street_address|premise|subpremise';

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final components = result['address_components'] as List;

          String? street;
          String locality = '';
          String city = '';

          // Parse address components
          for (var component in components) {
            final types = component['types'] as List<String>;
            final longName = component['long_name'] as String;

            if (types.contains('street_number') || types.contains('route')) {
              if (street == null) {
                street = longName;
              } else {
                street = '$street $longName';
              }
            } else if (types.contains('sublocality') ||
                types.contains('sublocality_level_1')) {
              if (locality.isEmpty) locality = longName;
            } else if (types.contains('locality')) {
              if (city.isEmpty) city = longName;
            } else if (types.contains('administrative_area_level_2') &&
                city.isEmpty) {
              city = longName;
            } else if (types.contains('administrative_area_level_1') &&
                city.isEmpty) {
              city = longName;
            }
          }

          // Fallback if locality is empty
          if (locality.isEmpty) {
            for (var component in components) {
              final types = component['types'] as List<String>;
              if (types.contains('neighborhood') ||
                  types.contains('sublocality_level_2')) {
                locality = component['long_name'];
                break;
              }
            }
          }

          // Ensure we have at least locality and city
          if (locality.isNotEmpty && city.isNotEmpty) {
            return LocationContext(
              street: street,
              locality: locality,
              city: city,
              lat: lat,
              lng: lng,
            );
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
      return null;
    }
  }

  // 🔍 SEARCH LOCATIONS
  Future<List<LocationContext>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
          'input=${Uri.encodeComponent(query)}&'
          'key=$_googleApiKey&'
          'components=country:in&'
          'types=geocode&'
          'language=en';

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['predictions'] != null) {
          List<LocationContext> results = [];

          for (var prediction in data['predictions']) {
            final placeId = prediction['place_id'];
            final locationContext = await _getPlaceDetails(placeId);

            if (locationContext != null) {
              results.add(locationContext);
            }

            // Limit results
            if (results.length >= 10) break;
          }

          return results;
        }
      }

      return [];
    } catch (e) {
      debugPrint('Search locations error: $e');
      return [];
    }
  }

  // 🏢 GET PLACE DETAILS
  Future<LocationContext?> _getPlaceDetails(String placeId) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?'
          'place_id=$placeId&'
          'key=$_googleApiKey&'
          'fields=geometry,address_components,formatted_address';

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final result = data['result'];
          final geometry = result['geometry']['location'];
          final components = result['address_components'] as List;

          String? street;
          String locality = '';
          String city = '';

          // Parse components similar to reverse geocoding
          for (var component in components) {
            final types = component['types'] as List<String>;
            final longName = component['long_name'] as String;

            if (types.contains('street_number') || types.contains('route')) {
              if (street == null) {
                street = longName;
              } else {
                street = '$street $longName';
              }
            } else if (types.contains('sublocality') ||
                types.contains('sublocality_level_1')) {
              if (locality.isEmpty) locality = longName;
            } else if (types.contains('locality')) {
              if (city.isEmpty) city = longName;
            } else if (types.contains('administrative_area_level_2') &&
                city.isEmpty) {
              city = longName;
            }
          }

          if (locality.isNotEmpty && city.isNotEmpty) {
            return LocationContext(
              street: street,
              locality: locality,
              city: city,
              lat: geometry['lat'].toDouble(),
              lng: geometry['lng'].toDouble(),
            );
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('Place details error: $e');
      return null;
    }
  }

  // 💾 SET CURRENT LOCATION
  Future<void> setCurrentLocation(LocationContext location) async {
    _currentLocation = location;
    notifyListeners();

    // Save to storage
    await _saveLocationToStorage(location);

    // Add to saved locations if not already present
    if (!_savedLocations.any((saved) => saved == location)) {
      _savedLocations.insert(0, location);

      // Keep only last 10 locations
      if (_savedLocations.length > 10) {
        _savedLocations = _savedLocations.take(10).toList();
      }

      await _saveSavedLocationsList();
    }
  }

  // 💾 SAVE LOCATION TO STORAGE
  Future<void> _saveLocationToStorage(LocationContext location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_locationKey, location.toJsonString());
    } catch (e) {
      debugPrint('Error saving location to storage: $e');
    }
  }

  // 📂 LOAD SAVED LOCATION FROM STORAGE
  Future<void> _loadSavedLocationFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationString = prefs.getString(_locationKey);

      if (locationString != null) {
        _currentLocation = LocationContext.fromJsonString(locationString);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading location from storage: $e');
    }
  }

  // 💾 SAVE SAVED LOCATIONS LIST
  Future<void> _saveSavedLocationsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = _savedLocations
          .map((loc) => loc.toJsonString())
          .toList();
      await prefs.setStringList(_savedLocationsKey, locationsJson);
    } catch (e) {
      debugPrint('Error saving locations list: $e');
    }
  }

  // 📂 LOAD SAVED LOCATIONS LIST
  Future<void> _loadSavedLocationsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getStringList(_savedLocationsKey) ?? [];

      _savedLocations = locationsJson
          .map((json) => LocationContext.fromJsonString(json))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading locations list: $e');
    }
  }

  // 🗑️ REMOVE SAVED LOCATION
  Future<void> removeSavedLocation(LocationContext location) async {
    _savedLocations.removeWhere((saved) => saved == location);
    await _saveSavedLocationsList();
    notifyListeners();
  }

  // 🔄 REFRESH CURRENT LOCATION
  Future<void> refreshCurrentLocation() async {
    await getCurrentLocation();
  }

  // 🏠 GET FALLBACK LOCATION
  LocationContext getFallbackLocation() {
    if (_savedLocations.isNotEmpty) {
      return _savedLocations.first;
    }
    return LocationContext.mockUjjain;
  }

  // 🎯 CHECK LOCATION PERMISSIONS
  Future<bool> checkLocationPermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  // ⚙️ OPEN APP SETTINGS
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // 🔧 PRIVATE HELPERS
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // 🧹 CLEAR ERROR
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 📊 GET LOCATION FOR API CALLS
  Map<String, dynamic>? getLocationForApi() {
    return _currentLocation?.apiFormat;
  }

  // 🎭 SET MOCK LOCATION (FOR TESTING)
  void setMockLocation(LocationContext location) {
    _currentLocation = location;
    notifyListeners();
  }
}
