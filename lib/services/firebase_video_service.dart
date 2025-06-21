import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'firebase_service.dart';

// 🔥 FIREBASE VIDEO SERVICE - VINU BHAISAHAB KA EXTRAORDINARY VIDEO SOLUTION 🔥
class FirebaseVideoService {
  static final FirebaseStorage _storage = FirebaseService.storage;
  static const String _videosPath = 'Homescreen Trending videos';
  
  // 🎬 GET TRENDING VIDEOS FROM FIREBASE STORAGE 🎬
  static Future<List<String>> getTrendingVideos() async {
    try {
      print('🔍 Fetching trending videos from Firebase Storage...');
      
      // Get reference to the videos folder
      final ListResult result = await _storage.ref(_videosPath).listAll();
      
      List<String> videoUrls = [];
      
      // Get download URLs for all videos
      for (Reference ref in result.items) {
        try {
          // Only process video files
          if (_isVideoFile(ref.name)) {
            String downloadUrl = await ref.getDownloadURL();
            videoUrls.add(downloadUrl);
            print('✅ Found video: ${ref.name}');
          }
        } catch (e) {
          print('❌ Error getting URL for ${ref.name}: $e');
        }
      }
      
      if (videoUrls.isEmpty) {
        print('⚠️ No videos found, using fallback videos');
        return _getFallbackVideos();
      }
      
      // Shuffle videos for random order
      videoUrls.shuffle();
      
      print('🎉 Successfully fetched ${videoUrls.length} trending videos');
      return videoUrls;
      
    } catch (e) {
      print('❌ Error fetching videos from Firebase Storage: $e');
      await FirebaseService.logError(e, StackTrace.current);
      return _getFallbackVideos();
    }
  }
  
  // 🎲 GET RANDOM VIDEO 🎲
  static Future<String?> getRandomVideo() async {
    try {
      final videos = await getTrendingVideos();
      if (videos.isNotEmpty) {
        final random = Random();
        return videos[random.nextInt(videos.length)];
      }
      return null;
    } catch (e) {
      print('❌ Error getting random video: $e');
      return null;
    }
  }
  
  // 📱 GET VIDEOS BATCH 📱
  static Future<List<String>> getVideosBatch({int limit = 5}) async {
    try {
      final allVideos = await getTrendingVideos();
      if (allVideos.length <= limit) {
        return allVideos;
      }
      
      // Return random batch
      final random = Random();
      final shuffled = List<String>.from(allVideos)..shuffle(random);
      return shuffled.take(limit).toList();
      
    } catch (e) {
      print('❌ Error getting videos batch: $e');
      return _getFallbackVideos().take(limit).toList();
    }
  }
  
  // 🔍 CHECK IF FILE IS VIDEO 🔍
  static bool _isVideoFile(String fileName) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v'];
    final lowerFileName = fileName.toLowerCase();
    return videoExtensions.any((ext) => lowerFileName.endsWith(ext));
  }
  
  // 🆘 FALLBACK VIDEOS 🆘
  static List<String> _getFallbackVideos() {
    return [
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    ];
  }
  
  // 📊 GET VIDEO METADATA 📊
  static Future<Map<String, dynamic>?> getVideoMetadata(String videoPath) async {
    try {
      final ref = _storage.ref('$_videosPath/$videoPath');
      final metadata = await ref.getMetadata();
      
      return {
        'name': metadata.name,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'timeCreated': metadata.timeCreated,
        'updated': metadata.updated,
        'downloadUrl': await ref.getDownloadURL(),
      };
    } catch (e) {
      print('❌ Error getting video metadata: $e');
      return null;
    }
  }
  
  // 🔄 REFRESH VIDEO CACHE 🔄
  static Future<void> refreshVideoCache() async {
    try {
      print('🔄 Refreshing video cache...');
      // Force refresh by clearing any cached data
      await getTrendingVideos();
      print('✅ Video cache refreshed');
    } catch (e) {
      print('❌ Error refreshing video cache: $e');
    }
  }
  
  // 📈 LOG VIDEO VIEW 📈
  static Future<void> logVideoView(String videoUrl) async {
    try {
      await FirebaseService.logEvent('video_viewed', {
        'video_url': videoUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'source': 'homescreen_trending',
      });
    } catch (e) {
      print('❌ Error logging video view: $e');
    }
  }
  
  // 🎯 LOG VIDEO INTERACTION 🎯
  static Future<void> logVideoInteraction(String videoUrl, String action) async {
    try {
      await FirebaseService.logEvent('video_interaction', {
        'video_url': videoUrl,
        'action': action, // play, pause, mute, unmute, swipe
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'source': 'homescreen_trending',
      });
    } catch (e) {
      print('❌ Error logging video interaction: $e');
    }
  }
}
