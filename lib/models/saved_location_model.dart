import 'dart:convert';

// 🏠 SAVED LOCATION MODEL - ZOMATO/SWIGGY STYLE LOCATION MANAGEMENT 🏠
enum SavedLocationType {
  home,
  work,
  other;

  String get displayName {
    switch (this) {
      case SavedLocationType.home:
        return 'Home';
      case SavedLocationType.work:
        return 'Work';
      case SavedLocationType.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case SavedLocationType.home:
        return '🏠';
      case SavedLocationType.work:
        return '🏢';
      case SavedLocationType.other:
        return '📍';
    }
  }
}

class SavedLocationModel {
  final String id;
  final String customName;
  final String fullAddress;
  final String? streetAddress;
  final String? landmark;
  final String locality;
  final String city;
  final String state;
  final String? postalCode;
  final double latitude;
  final double longitude;
  final SavedLocationType type;
  final DateTime createdAt;
  final DateTime lastUsed;

  SavedLocationModel({
    required this.id,
    required this.customName,
    required this.fullAddress,
    this.streetAddress,
    this.landmark,
    required this.locality,
    required this.city,
    required this.state,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.type,
    DateTime? createdAt,
    DateTime? lastUsed,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastUsed = lastUsed ?? DateTime.now();

  // 🏷️ DISPLAY FORMATS
  String get displayTitle {
    return '${type.emoji} $customName';
  }

  String get shortAddress {
    if (streetAddress != null && streetAddress!.isNotEmpty) {
      return streetAddress!;
    }
    return locality;
  }

  String get detailedAddress {
    List<String> parts = [];
    if (streetAddress != null && streetAddress!.isNotEmpty) {
      parts.add(streetAddress!);
    }
    if (landmark != null && landmark!.isNotEmpty) {
      parts.add('Near $landmark');
    }
    parts.add(locality);
    parts.add(city);
    return parts.join(', ');
  }

  // 🔄 COPY WITH
  SavedLocationModel copyWith({
    String? id,
    String? customName,
    String? fullAddress,
    String? streetAddress,
    String? landmark,
    String? locality,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    SavedLocationType? type,
    DateTime? createdAt,
    DateTime? lastUsed,
  }) {
    return SavedLocationModel(
      id: id ?? this.id,
      customName: customName ?? this.customName,
      fullAddress: fullAddress ?? this.fullAddress,
      streetAddress: streetAddress ?? this.streetAddress,
      landmark: landmark ?? this.landmark,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  // 💾 JSON SERIALIZATION
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customName': customName,
      'fullAddress': fullAddress,
      'streetAddress': streetAddress,
      'landmark': landmark,
      'locality': locality,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed.toIso8601String(),
    };
  }

  factory SavedLocationModel.fromJson(Map<String, dynamic> json) {
    return SavedLocationModel(
      id: json['id'],
      customName: json['customName'],
      fullAddress: json['fullAddress'],
      streetAddress: json['streetAddress'],
      landmark: json['landmark'],
      locality: json['locality'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      type: SavedLocationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SavedLocationType.other,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lastUsed: DateTime.parse(json['lastUsed']),
    );
  }

  String toJsonString() => jsonEncode(toJson());
  
  factory SavedLocationModel.fromJsonString(String jsonString) =>
      SavedLocationModel.fromJson(jsonDecode(jsonString));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedLocationModel &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => id.hashCode ^ latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'SavedLocationModel(id: $id, customName: $customName, type: $type, locality: $locality, city: $city)';
  }
}
