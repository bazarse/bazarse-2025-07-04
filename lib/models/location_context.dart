import 'dart:convert';

// 🚀 BAZARSE LOCATION CONTEXT - HYPERLOCAL LOCATION DATA 🚀
class LocationContext {
  final String? street;
  final String locality;
  final String city;
  final double lat;
  final double lng;
  final DateTime lastUpdated;

  LocationContext({
    this.street,
    required this.locality,
    required this.city,
    required this.lat,
    required this.lng,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  // 🏠 HOME PAGE FORMAT: 📍 17 Park Road, Freeganj, Ujjain
  String get homeDisplayFormat {
    if (street != null && street!.isNotEmpty) {
      return '📍 $street, $locality, $city';
    }
    return '📍 $locality, $city';
  }

  // 🔍 EXPLORE/AI FORMAT: Freeganj, Ujjain
  String get exploreDisplayFormat {
    return '$locality, $city';
  }

  // 🎯 DEELS FORMAT: Ujjain
  String get deelsDisplayFormat {
    return city;
  }

  // 📍 SHORT FORMAT: Freeganj
  String get shortDisplayFormat {
    return locality;
  }

  // 🌍 FULL ADDRESS FORMAT
  String get fullAddress {
    if (street != null && street!.isNotEmpty) {
      return '$street, $locality, $city';
    }
    return '$locality, $city';
  }

  // 📊 FOR API CALLS
  Map<String, dynamic> get apiFormat {
    return {
      'street': street,
      'locality': locality,
      'city': city,
      'lat': lat,
      'lng': lng,
    };
  }

  // 💾 SERIALIZATION
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'locality': locality,
      'city': city,
      'lat': lat,
      'lng': lng,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory LocationContext.fromJson(Map<String, dynamic> json) {
    return LocationContext(
      street: json['street'],
      locality: json['locality'] ?? '',
      city: json['city'] ?? '',
      lat: json['lat']?.toDouble() ?? 0.0,
      lng: json['lng']?.toDouble() ?? 0.0,
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  String toJsonString() => json.encode(toJson());

  factory LocationContext.fromJsonString(String jsonString) {
    return LocationContext.fromJson(json.decode(jsonString));
  }

  // 🔄 COPY WITH
  LocationContext copyWith({
    String? street,
    String? locality,
    String? city,
    double? lat,
    double? lng,
    DateTime? lastUpdated,
  }) {
    return LocationContext(
      street: street ?? this.street,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  // ✅ VALIDATION
  bool get isValid {
    return locality.isNotEmpty && 
           city.isNotEmpty && 
           lat != 0.0 && 
           lng != 0.0;
  }

  // 📏 DISTANCE CALCULATION
  double distanceTo(LocationContext other) {
    // Simple distance calculation (can be enhanced with proper geo calculations)
    double deltaLat = lat - other.lat;
    double deltaLng = lng - other.lng;
    return (deltaLat * deltaLat + deltaLng * deltaLng);
  }

  // 🏷️ LOCATION TYPE DETECTION
  String get locationType {
    if (street != null && street!.toLowerCase().contains('office')) {
      return 'Office';
    } else if (street != null && street!.toLowerCase().contains('home')) {
      return 'Home';
    } else if (street != null && street!.isNotEmpty) {
      return 'Custom';
    }
    return 'Area';
  }

  @override
  String toString() {
    return 'LocationContext(street: $street, locality: $locality, city: $city, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationContext &&
        other.street == street &&
        other.locality == locality &&
        other.city == city &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return street.hashCode ^
        locality.hashCode ^
        city.hashCode ^
        lat.hashCode ^
        lng.hashCode;
  }

  // 🎭 MOCK LOCATIONS FOR TESTING
  static LocationContext get mockUjjain => LocationContext(
    street: '17 Park Road',
    locality: 'Freeganj',
    city: 'Ujjain',
    lat: 23.182343,
    lng: 75.784932,
  );

  static LocationContext get mockDelhi => LocationContext(
    street: 'Connaught Place',
    locality: 'CP',
    city: 'New Delhi',
    lat: 28.6304,
    lng: 77.2177,
  );

  static LocationContext get mockMumbai => LocationContext(
    locality: 'Bandra West',
    city: 'Mumbai',
    lat: 19.0596,
    lng: 72.8295,
  );
}
