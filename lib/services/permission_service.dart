// Vinu Bhaisahab's Permission Service 🔐
// Outstanding permission handling for Bazar Se app

import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionService {
  // Request location permission
  static Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Open app settings
        await Geolocator.openAppSettings();
        return false;
      }
      
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      print('Location permission error: $e');
      return false;
    }
  }
  
  // Request notification permission
  static Future<bool> requestNotificationPermission() async {
    try {
      PermissionStatus status = await Permission.notification.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      print('Notification permission error: $e');
      return false;
    }
  }
  
  // Request all required permissions
  static Future<Map<String, bool>> requestAllPermissions() async {
    final results = <String, bool>{};
    
    // Request location permission
    results['location'] = await requestLocationPermission();
    
    // Request notification permission  
    results['notification'] = await requestNotificationPermission();
    
    return results;
  }
  
  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
