import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/enhanced_location_model.dart';

// 🚀 ADVANCED LOCATION SERVICE - DELIVERY APP LEVEL 🚀
class AdvancedLocationService {
  static const String _googleApiKey = 'AIzaSyDexYes91JK03iFpCtLIE65J0FoUEYlFRI';
  static const String _placesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';
  static const String _geocodingBaseUrl =
      'https://maps.googleapis.com/maps/api/geocode';

  // 🎯 GET ULTRA PRECISE CURRENT LOCATION 🎯
  static Future<LocationModel?> getUltraPreciseLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      // Get high accuracy position with new API
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      ).timeout(const Duration(seconds: 15));

      // Get detailed address using reverse geocoding
      final detailedLocation = await _getDetailedAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return detailedLocation;
    } catch (e) {
      print('Error getting ultra precise location: $e');
      return null;
    }
  }

  // 🏠 GET DETAILED ADDRESS FROM COORDINATES 🏠
  static Future<LocationModel?> _getDetailedAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      final url =
          '$_geocodingBaseUrl/json?latlng=$lat,$lng&key=$_googleApiKey&result_type=street_address|premise|subpremise';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final components = result['address_components'] as List;

          // Extract detailed address components
          String streetNumber = '';
          String route = '';
          String sublocality = '';
          String locality = '';
          String administrativeArea = '';
          String postalCode = '';
          String country = '';

          for (var component in components) {
            final types = component['types'] as List;

            if (types.contains('street_number')) {
              streetNumber = component['long_name'];
            } else if (types.contains('route')) {
              route = component['long_name'];
            } else if (types.contains('sublocality_level_1') ||
                types.contains('sublocality')) {
              sublocality = component['long_name'];
            } else if (types.contains('locality')) {
              locality = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              administrativeArea = component['long_name'];
            } else if (types.contains('postal_code')) {
              postalCode = component['long_name'];
            } else if (types.contains('country')) {
              country = component['long_name'];
            }
          }

          // Build street address
          String streetAddress = '';
          if (streetNumber.isNotEmpty && route.isNotEmpty) {
            streetAddress = '$streetNumber $route';
          } else if (route.isNotEmpty) {
            streetAddress = route;
          }

          // Build display name (short version)
          String displayName = sublocality.isNotEmpty ? sublocality : locality;
          if (displayName.isEmpty) displayName = 'Current Location';

          // Build full address
          List<String> addressParts = [];
          if (streetAddress.isNotEmpty) addressParts.add(streetAddress);
          if (sublocality.isNotEmpty) addressParts.add(sublocality);
          if (locality.isNotEmpty) addressParts.add(locality);
          if (administrativeArea.isNotEmpty)
            addressParts.add(administrativeArea);
          if (postalCode.isNotEmpty) addressParts.add(postalCode);

          String fullAddress = addressParts.join(', ');

          return LocationModel(
            id: 'current_${DateTime.now().millisecondsSinceEpoch}',
            displayName: displayName,
            fullAddress: fullAddress,
            streetAddress: streetAddress,
            sublocality: sublocality,
            locality: locality,
            administrativeArea: administrativeArea,
            postalCode: postalCode,
            country: country,
            latitude: lat,
            longitude: lng,
            type: LocationType.current,
          );
        }
      }

      return null;
    } catch (e) {
      print('Error getting detailed address: $e');
      return null;
    }
  }

  // 🔍 ENHANCED SEARCH WITH ALL LOCATION TYPES 🔍
  static Future<List<LocationModel>> searchLocationsWithAutocomplete(
    String query,
  ) async {
    try {
      if (query.trim().isEmpty) return [];

      // Enhanced search with multiple types for better results
      final types = [
        'establishment',
        'geocode',
        'address',
        '(regions)',
        '(cities)',
      ];

      List<LocationModel> allResults = [];

      // Search with different types to get comprehensive results
      for (String type in types) {
        final url =
            '$_placesBaseUrl/autocomplete/json?input=${Uri.encodeComponent(query)}&key=$_googleApiKey&components=country:in&types=$type&language=en';

        try {
          final response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data['status'] == 'OK' && data['predictions'] != null) {
              for (var prediction in data['predictions']) {
                final placeId = prediction['place_id'];

                // Avoid duplicates
                if (!allResults.any((loc) => loc.id == placeId)) {
                  final detailedLocation = await _getPlaceDetails(placeId);

                  if (detailedLocation != null) {
                    allResults.add(detailedLocation);
                  }
                }

                // Limit total results for performance
                if (allResults.length >= 15) break;
              }
            }
          }
        } catch (e) {
          print('Error with type $type: $e');
          continue; // Continue with next type
        }

        if (allResults.length >= 15) break;
      }

      // Sort by relevance (exact matches first, then by length)
      allResults.sort((a, b) {
        final queryLower = query.toLowerCase();
        final aName = a.displayName.toLowerCase();
        final bName = b.displayName.toLowerCase();

        // Exact matches first
        if (aName.startsWith(queryLower) && !bName.startsWith(queryLower))
          return -1;
        if (!aName.startsWith(queryLower) && bName.startsWith(queryLower))
          return 1;

        // Then by length (shorter names first)
        return aName.length.compareTo(bName.length);
      });

      return allResults.take(10).toList(); // Return top 10 results
    } catch (e) {
      print('Error searching locations: $e');
      return [];
    }
  }

  // 🏢 GET PLACE DETAILS 🏢
  static Future<LocationModel?> _getPlaceDetails(String placeId) async {
    try {
      final url =
          '$_placesBaseUrl/details/json?place_id=$placeId&key=$_googleApiKey&fields=geometry,address_components,formatted_address,name';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final result = data['result'];
          final geometry = result['geometry']['location'];
          final components = result['address_components'] as List;

          // Extract detailed components
          String streetNumber = '';
          String route = '';
          String sublocality = '';
          String locality = '';
          String administrativeArea = '';
          String postalCode = '';
          String country = '';

          for (var component in components) {
            final types = component['types'] as List;

            if (types.contains('street_number')) {
              streetNumber = component['long_name'];
            } else if (types.contains('route')) {
              route = component['long_name'];
            } else if (types.contains('sublocality_level_1') ||
                types.contains('sublocality')) {
              sublocality = component['long_name'];
            } else if (types.contains('locality')) {
              locality = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              administrativeArea = component['long_name'];
            } else if (types.contains('postal_code')) {
              postalCode = component['long_name'];
            } else if (types.contains('country')) {
              country = component['long_name'];
            }
          }

          // Build street address
          String streetAddress = '';
          if (streetNumber.isNotEmpty && route.isNotEmpty) {
            streetAddress = '$streetNumber $route';
          } else if (route.isNotEmpty) {
            streetAddress = route;
          }

          // Build display name
          String displayName = result['name'] ?? sublocality;
          if (displayName.isEmpty) displayName = locality;
          if (displayName.isEmpty) displayName = 'Location';

          return LocationModel(
            id: placeId,
            displayName: displayName,
            fullAddress: result['formatted_address'] ?? '',
            streetAddress: streetAddress,
            sublocality: sublocality,
            locality: locality,
            administrativeArea: administrativeArea,
            postalCode: postalCode,
            country: country,
            latitude: geometry['lat'].toDouble(),
            longitude: geometry['lng'].toDouble(),
            type: LocationType.custom,
          );
        }
      }

      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }

  // 📍 GET NEARBY LANDMARKS 📍
  static Future<List<LocationModel>> getNearbyLandmarks(
    double lat,
    double lng,
  ) async {
    try {
      final url =
          '$_placesBaseUrl/nearbysearch/json?location=$lat,$lng&radius=500&type=point_of_interest&key=$_googleApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          List<LocationModel> landmarks = [];

          for (var place in data['results']) {
            landmarks.add(
              LocationModel(
                id: place['place_id'],
                displayName: place['name'],
                fullAddress: place['vicinity'] ?? '',
                latitude: place['geometry']['location']['lat'].toDouble(),
                longitude: place['geometry']['location']['lng'].toDouble(),
                type: LocationType.landmark,
              ),
            );

            // Limit to 10 landmarks
            if (landmarks.length >= 10) break;
          }

          return landmarks;
        }
      }

      return [];
    } catch (e) {
      print('Error getting nearby landmarks: $e');
      return [];
    }
  }
}
