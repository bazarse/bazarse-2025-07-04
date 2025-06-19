enum LocationType { home, work, current, custom, landmark }

class LocationModel {
  final String id;
  final String displayName;
  final String fullAddress;
  final String? streetAddress;
  final String? sublocality;
  final String? locality;
  final String? administrativeArea;
  final String? postalCode;
  final String? country;
  final double latitude;
  final double longitude;
  final LocationType type;

  LocationModel({
    required this.id,
    required this.displayName,
    required this.fullAddress,
    this.streetAddress,
    this.sublocality,
    this.locality,
    this.administrativeArea,
    this.postalCode,
    this.country,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  // Get short address for display
  String get shortAddress {
    if (streetAddress != null && streetAddress!.isNotEmpty) {
      return streetAddress!;
    }
    if (sublocality != null && sublocality!.isNotEmpty) {
      return sublocality!;
    }
    if (locality != null && locality!.isNotEmpty) {
      return locality!;
    }
    return displayName;
  }

  // Get area name
  String get areaName {
    if (sublocality != null && sublocality!.isNotEmpty) {
      return sublocality!;
    }
    if (locality != null && locality!.isNotEmpty) {
      return locality!;
    }
    return displayName;
  }

  // Get delivery address format
  String get deliveryAddress {
    List<String> parts = [];
    if (streetAddress != null && streetAddress!.isNotEmpty) {
      parts.add(streetAddress!);
    }
    if (sublocality != null && sublocality!.isNotEmpty) {
      parts.add(sublocality!);
    }
    if (locality != null && locality!.isNotEmpty) {
      parts.add(locality!);
    }
    if (postalCode != null && postalCode!.isNotEmpty) {
      parts.add(postalCode!);
    }
    return parts.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'fullAddress': fullAddress,
      'streetAddress': streetAddress,
      'sublocality': sublocality,
      'locality': locality,
      'administrativeArea': administrativeArea,
      'postalCode': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.toString(),
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      displayName: json['displayName'],
      fullAddress: json['fullAddress'],
      streetAddress: json['streetAddress'],
      sublocality: json['sublocality'],
      locality: json['locality'],
      administrativeArea: json['administrativeArea'],
      postalCode: json['postalCode'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: LocationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => LocationType.custom,
      ),
    );
  }
}
