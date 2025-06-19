// Vinu Bhaisahab's Permission Screen 🔐
// Outstanding permission request screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../services/permission_service.dart';
import 'onboarding_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _isLoading = false;

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request all permissions
      final results = await PermissionService.requestAllPermissions();

      // Navigate to onboarding regardless of permission results
      // User can still use the app with limited functionality
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      print('Permission request error: $e');
      // Still navigate to onboarding
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                const SizedBox(height: 40),
                // Icon
                Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientMiddle,
                            AppColors.gradientEnd,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.security,
                        size: 60,
                        color: Colors.white,
                      ),
                    )
                    .animate()
                    .scale(duration: const Duration(milliseconds: 800))
                    .fadeIn(),

                const SizedBox(height: 20),

                // Title
                Text(
                      'Permissions Required',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200))
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 20),

                // Description
                Text(
                      'To provide you the best experience, we need access to:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 400))
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 24),

                // Permission items
                _buildPermissionItem(
                  Icons.location_on,
                  'Location',
                  'To show nearby stores and delivery options',
                  0,
                ),

                const SizedBox(height: 20),

                _buildPermissionItem(
                  Icons.notifications,
                  'Notifications',
                  'To keep you updated about orders and offers',
                  1,
                ),

                const SizedBox(height: 32),

                // Allow button
                SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _requestPermissions,
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  width: 2,
                                  color: Colors.transparent,
                                ),
                              ),
                            ).copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.gradientStart,
                                AppColors.gradientMiddle,
                                AppColors.gradientEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Allow Permissions',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 800))
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    IconData icon,
    String title,
    String description,
    int index,
  ) {
    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gradientStart.withOpacity(0.3),
                      AppColors.gradientMiddle.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 600 + (index * 200)))
        .slideX(begin: 0.3, end: 0);
  }
}
