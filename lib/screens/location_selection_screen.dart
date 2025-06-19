// Vinu Bhaisahab's Location Selection Screen 📍
// Outstanding location selection like Zomato

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import '../services/location_service.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _currentLocation = 'Getting location...';
  List<String> _savedAddresses = [
    'Home - Koramangala, Bengaluru',
    'Work - Whitefield, Bengaluru',
    'Other - MG Road, Bengaluru',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final locationData =
          await LocationService.getCurrentLocationWithAddress();
      if (locationData['success']) {
        setState(() {
          _currentLocation = locationData['address'];
        });
      } else {
        setState(() {
          _currentLocation = 'Location not available';
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = 'Location not available';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _selectLocation(String location) {
    Navigator.of(context).pop(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Select Location',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search for area, street name...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 200))
                  .slideY(begin: -0.3, end: 0),

              const SizedBox(height: 24),

              // Current Location
              Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: _isLoading
                          ? null
                          : () => _selectLocation(_currentLocation),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.gradientStart.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.gradientStart,
                                    AppColors.gradientMiddle,
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Location',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColors.gradientStart,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white60,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          _currentLocation,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white60,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 400))
                  .slideX(begin: -0.3, end: 0),

              const SizedBox(height: 24),

              // Saved Addresses
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                            'Saved Addresses',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 600))
                          .slideX(begin: -0.3, end: 0),

                      const SizedBox(height: 16),

                      Expanded(
                        child: ListView.builder(
                          itemCount: _savedAddresses.length,
                          itemBuilder: (context, index) {
                            final address = _savedAddresses[index];
                            final parts = address.split(' - ');
                            final label = parts[0];
                            final location = parts[1];

                            return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () => _selectLocation(location),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                            ),
                                            child: Icon(
                                              label == 'Home'
                                                  ? Icons.home
                                                  : label == 'Work'
                                                  ? Icons.work
                                                  : Icons.location_on,
                                              color: Colors.white70,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  label,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  location,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white60,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(
                                  delay: Duration(
                                    milliseconds: 800 + (index * 100),
                                  ),
                                )
                                .slideX(begin: 0.3, end: 0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
