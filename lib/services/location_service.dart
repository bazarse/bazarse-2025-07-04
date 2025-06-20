// 🔥 VINU BHAISAHAB'S OUTSTANDING LOCATION SERVICE 🔥
// Better than Zomato, Swiggy, Blinkit combined! 🚀

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// 🏆 OUTSTANDING Location Model - Zomato killer! 🏆
class LocationModel {
  final String id;
  final String displayName;
  final String fullAddress;
  final String neighborhood;
  final String locality;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final LocationType type;
  final DateTime savedAt;

  LocationModel({
    required this.id,
    required this.displayName,
    required this.fullAddress,
    required this.neighborhood,
    required this.locality,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'fullAddress': fullAddress,
        'neighborhood': neighborhood,
        'locality': locality,
        'city': city,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
        'type': type.toString(),
        'savedAt': savedAt.toIso8601String(),
      };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json['id'],
        displayName: json['displayName'],
        fullAddress: json['fullAddress'],
        neighborhood: json['neighborhood'],
        locality: json['locality'],
        city: json['city'],
        state: json['state'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        type:
            LocationType.values.firstWhere((e) => e.toString() == json['type']),
        savedAt: DateTime.parse(json['savedAt']),
      );
}

enum LocationType { home, work, custom }

extension LocationTypeExtension on LocationType {
  String get displayName {
    switch (this) {
      case LocationType.home:
        return 'Home';
      case LocationType.work:
        return 'Work';
      case LocationType.custom:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case LocationType.home:
        return '🏠';
      case LocationType.work:
        return '🏢';
      case LocationType.custom:
        return '📍';
    }
  }
}

// 🚀 OUTSTANDING Location Service - Beats all competitors! 🚀
class LocationService {
  static const String _savedLocationsKey = 'saved_locations';
  static const String _currentLocationKey = 'current_location';

  // 🔥 Get current location with OUTSTANDING accuracy! 🔥
  static Future<LocationModel?> getCurrentLocation() async {
    try {
      print('🌟 Getting current location with BEST accuracy...');

      // Check permissions first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Location permissions denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permissions permanently denied');
        return null;
      }

      // Get current position with HIGH accuracy (works better on web)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 20));

      print('📍 Got coordinates: ${position.latitude}, ${position.longitude}');

      // Get detailed address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Extract DETAILED location info like Zomato Pro
        String neighborhood = place.subLocality ?? place.thoroughfare ?? '';
        String locality = place.locality ?? '';
        String city = place.subAdministrativeArea ?? place.locality ?? '';
        String state = place.administrativeArea ?? '';

        // Create PERFECT display name like "Koramangala 4th Block, Bengaluru"
        String displayName = '';
        if (neighborhood.isNotEmpty && locality.isNotEmpty) {
          displayName = '$neighborhood, $locality';
        } else if (locality.isNotEmpty && city.isNotEmpty) {
          displayName = '$locality, $city';
        } else if (city.isNotEmpty) {
          displayName = city;
        } else {
          displayName = 'Current Location';
        }

        // Full address for detailed view
        String fullAddress = [
          place.name,
          place.thoroughfare,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
          place.postalCode,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        LocationModel location = LocationModel(
          id: 'current_${DateTime.now().millisecondsSinceEpoch}',
          displayName: displayName,
          fullAddress: fullAddress,
          neighborhood: neighborhood,
          locality: locality,
          city: city,
          state: state,
          latitude: position.latitude,
          longitude: position.longitude,
          type: LocationType.custom,
          savedAt: DateTime.now(),
        );

        // Save current location
        await _saveCurrentLocation(location);

        print('✅ Location found: $displayName');
        return location;
      }

      print('❌ No placemarks found');
      return null;
    } catch (e) {
      print('❌ Error getting location: $e');
      // Return a default location for web testing
      LocationModel defaultLocation = LocationModel(
        id: 'default_${DateTime.now().millisecondsSinceEpoch}',
        displayName: 'Current Location, India',
        fullAddress: 'Current Location, India',
        neighborhood: '',
        locality: 'Current Location',
        city: 'India',
        state: 'India',
        latitude: 28.6139, // Delhi coordinates as fallback
        longitude: 77.2090,
        type: LocationType.custom,
        savedAt: DateTime.now(),
      );
      await _saveCurrentLocation(defaultLocation);
      return defaultLocation;
    }
  }

  // 🔍 Search locations like Zomato with DEEP results! 🔍
  static Future<List<LocationModel>> searchLocations(String query) async {
    try {
      print('🔍 Searching for: $query');

      if (query.trim().isEmpty) return [];

      // Get locations from geocoding
      List<Location> locations = await locationFromAddress(query);
      List<LocationModel> results = [];

      for (Location location in locations.take(15)) {
        // More results than Zomato!
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];

            String neighborhood = place.subLocality ?? place.thoroughfare ?? '';
            String locality = place.locality ?? '';
            String city = place.subAdministrativeArea ?? place.locality ?? '';
            String state = place.administrativeArea ?? '';

            String displayName = '';
            if (neighborhood.isNotEmpty && locality.isNotEmpty) {
              displayName = '$neighborhood, $locality';
            } else if (locality.isNotEmpty && city.isNotEmpty) {
              displayName = '$locality, $city';
            } else if (city.isNotEmpty) {
              displayName = city;
            } else {
              displayName = query;
            }

            String fullAddress = [
              place.name,
              place.thoroughfare,
              place.subLocality,
              place.locality,
              place.subAdministrativeArea,
              place.administrativeArea,
              place.postalCode,
            ].where((e) => e != null && e.isNotEmpty).join(', ');

            results.add(
              LocationModel(
                id: 'search_${DateTime.now().millisecondsSinceEpoch}_${results.length}',
                displayName: displayName,
                fullAddress: fullAddress,
                neighborhood: neighborhood,
                locality: locality,
                city: city,
                state: state,
                latitude: location.latitude,
                longitude: location.longitude,
                type: LocationType.custom,
                savedAt: DateTime.now(),
              ),
            );
          }
        } catch (e) {
          print('Error processing location: $e');
        }
      }

      print('✅ Found ${results.length} locations');
      return results;
    } catch (e) {
      print('❌ Error searching locations: $e');
      return [];
    }
  }

  // 🏠 Save location with type (Home/Work/Custom) 🏠
  static Future<bool> saveLocation(
    LocationModel location,
    LocationType type, [
    String? customName,
  ]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedLocations =
          prefs.getStringList(_savedLocationsKey) ?? [];

      // Create new location with type
      LocationModel newLocation = LocationModel(
        id: 'saved_${DateTime.now().millisecondsSinceEpoch}',
        displayName: customName ?? location.displayName,
        fullAddress: location.fullAddress,
        neighborhood: location.neighborhood,
        locality: location.locality,
        city: location.city,
        state: location.state,
        latitude: location.latitude,
        longitude: location.longitude,
        type: type,
        savedAt: DateTime.now(),
      );

      // Remove existing location of same type (only one home/work allowed)
      if (type != LocationType.custom) {
        savedLocations.removeWhere((locationJson) {
          try {
            LocationModel existing = LocationModel.fromJson(
              json.decode(locationJson),
            );
            return existing.type == type;
          } catch (e) {
            return false;
          }
        });
      }

      savedLocations.add(json.encode(newLocation.toJson()));
      await prefs.setStringList(_savedLocationsKey, savedLocations);

      print(
        '✅ Location saved: ${newLocation.displayName} as ${type.toString()}',
      );
      return true;
    } catch (e) {
      print('❌ Error saving location: $e');
      return false;
    }
  }

  // 📋 Get all saved locations 📋
  static Future<List<LocationModel>> getSavedLocations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedLocations =
          prefs.getStringList(_savedLocationsKey) ?? [];

      List<LocationModel> locations = [];
      for (String locationJson in savedLocations) {
        try {
          locations.add(LocationModel.fromJson(json.decode(locationJson)));
        } catch (e) {
          print('Error parsing saved location: $e');
        }
      }

      // Sort: Home first, then Work, then Custom by date
      locations.sort((a, b) {
        if (a.type == LocationType.home && b.type != LocationType.home)
          return -1;
        if (b.type == LocationType.home && a.type != LocationType.home)
          return 1;
        if (a.type == LocationType.work && b.type == LocationType.custom)
          return -1;
        if (b.type == LocationType.work && a.type == LocationType.custom)
          return 1;
        return b.savedAt.compareTo(a.savedAt);
      });

      return locations;
    } catch (e) {
      print('❌ Error getting saved locations: $e');
      return [];
    }
  }

  // 🗑️ Delete saved location 🗑️
  static Future<bool> deleteLocation(String locationId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedLocations =
          prefs.getStringList(_savedLocationsKey) ?? [];

      savedLocations.removeWhere((locationJson) {
        try {
          LocationModel location = LocationModel.fromJson(
            json.decode(locationJson),
          );
          return location.id == locationId;
        } catch (e) {
          return false;
        }
      });

      await prefs.setStringList(_savedLocationsKey, savedLocations);
      print('✅ Location deleted');
      return true;
    } catch (e) {
      print('❌ Error deleting location: $e');
      return false;
    }
  }

  // 💾 Save current location privately 💾
  static Future<void> _saveCurrentLocation(LocationModel location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _currentLocationKey,
        json.encode(location.toJson()),
      );
    } catch (e) {
      print('Error saving current location: $e');
    }
  }

  // 📍 Get last known location 📍
  static Future<LocationModel?> getLastKnownLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? locationJson = prefs.getString(_currentLocationKey);
      if (locationJson != null) {
        return LocationModel.fromJson(json.decode(locationJson));
      }
    } catch (e) {
      print('Error getting last known location: $e');
    }
    return null;
  }

  // 🔄 Backward compatibility method for existing code 🔄
  static Future<Map<String, dynamic>> getCurrentLocationWithAddress() async {
    try {
      LocationModel? location = await getCurrentLocation();

      if (location != null) {
        return {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'address': location.displayName,
          'success': true,
        };
      }

      return {'address': 'Location not available', 'success': false};
    } catch (e) {
      print('Error getting location with address: $e');
      return {'address': 'Location not available', 'success': false};
    }
  }
}
