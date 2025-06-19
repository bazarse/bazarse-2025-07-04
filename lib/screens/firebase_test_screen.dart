import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/firebase_deels_service.dart';
import '../models/deel_model.dart';

// 🔥 FIREBASE TEST SCREEN - VINU BHAISAHAB KA TESTING ZONE 🔥
class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  bool _isLoading = false;
  String _status = 'Ready to test Firebase';
  List<DeelModel> _testDeels = [];

  // 🧪 TEST FIREBASE CONNECTION 🧪
  Future<void> _testFirebaseConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing Firebase connection...';
    });

    try {
      // Test Firestore connection
      await FirebaseService.firestore.collection('test').doc('connection').set({
        'timestamp': DateTime.now().toIso8601String(),
        'message': 'Firebase connection test successful!',
        'user': 'Vinu Bhaisahab',
      });

      // Test Analytics
      await FirebaseService.logEvent('firebase_test', {
        'test_type': 'connection',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      setState(() {
        _status = '✅ Firebase connection successful!';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Firebase connection failed: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 📱 TEST DEELS CRUD 📱
  Future<void> _testDeelsCRUD() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing Deels CRUD operations...';
    });

    try {
      // Create test deel
      DeelModel testDeel = DeelModel(
        id: '',
        store: 'Test Store - Firebase',
        offer: 'Firebase Integration Test Offer',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        thumbnailUrl: 'https://via.placeholder.com/300x400',
        likes: 0,
        comments: 0,
        shares: 0,
        isTrending: true,
        category: 'Technology',
        expiry: DateTime.now().add(Duration(days: 7)),
        city: 'Ujjain',
        originalPrice: 1000.0,
        discountedPrice: 500.0,
        description: 'Firebase integration test deal',
        storeAddress: 'Test Address, Ujjain',
        storePhone: '+91 9876543210',
        tags: ['firebase', 'test', 'integration'],
        isActive: true,
        stockLeft: 10,
        claimInstructions: 'Test claim instructions',
      );

      // Save to Firebase
      String? deelId = await FirebaseDeelsService.saveDeel(testDeel);
      
      if (deelId != null) {
        // Fetch deels from Firebase
        List<DeelModel> deels = await FirebaseDeelsService.getDeels(
          city: 'Ujjain',
          limit: 5,
        );

        setState(() {
          _testDeels = deels;
          _status = '✅ Deels CRUD test successful! Created deel with ID: $deelId';
        });
      } else {
        setState(() {
          _status = '❌ Failed to create test deel';
        });
      }
    } catch (e) {
      setState(() {
        _status = '❌ Deels CRUD test failed: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Firebase Test',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0070FF).withOpacity(0.1),
              Color(0xFF7D30F5).withOpacity(0.1),
              Color(0xFFFF2EB4).withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _status.contains('✅') ? Icons.check_circle : 
                      _status.contains('❌') ? Icons.error : Icons.info,
                      color: _status.contains('✅') ? Colors.green : 
                             _status.contains('❌') ? Colors.red : Colors.blue,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isLoading) ...[
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              // Test Buttons
              _buildTestButton(
                'Test Firebase Connection',
                Icons.cloud,
                _testFirebaseConnection,
              ),
              
              SizedBox(height: 15),
              
              _buildTestButton(
                'Test Deels CRUD',
                Icons.video_library,
                _testDeelsCRUD,
              ),
              
              SizedBox(height: 30),
              
              // Test Results
              if (_testDeels.isNotEmpty) ...[
                Text(
                  'Test Deels from Firebase:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: _testDeels.length,
                    itemBuilder: (context, index) {
                      DeelModel deel = _testDeels[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deel.store,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              deel.offer,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  '${deel.likes}',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                SizedBox(width: 15),
                                Icon(Icons.location_on, color: Colors.blue, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  deel.city,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestButton(String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
