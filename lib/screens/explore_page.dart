import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/modern_bottom_nav.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🚀 COMING SOON ICON 🚀
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0070FF).withValues(alpha: 0.3),
                        Color(0xFF7D30F5).withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: Icon(Icons.explore, size: 80, color: Colors.white),
                ),
                SizedBox(height: 30),

                // 🎯 EXPLORE TITLE 🎯
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFF0070FF), Color(0xFF7D30F5)],
                  ).createShader(bounds),
                  child: Text(
                    'Explore Bazar',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // 🔥 COMING SOON MESSAGE 🔥
                Text(
                  'Coming Soon! 🚀',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 15),

                Text(
                  'Amazing features are on the way...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  'Stay tuned for the best shopping experience!',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const ModernBottomNav(currentIndex: 1),
    );
  }
}
