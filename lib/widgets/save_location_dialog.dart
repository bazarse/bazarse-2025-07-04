import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../models/saved_location_model.dart';
import '../services/enhanced_location_service.dart';

// 💾 SAVE LOCATION DIALOG - ZOMATO/SWIGGY STYLE LOCATION SAVING 💾
class SaveLocationDialog extends StatefulWidget {
  final SavedLocationModel location;
  final Function(SavedLocationModel) onLocationSaved;

  const SaveLocationDialog({
    super.key,
    required this.location,
    required this.onLocationSaved,
  });

  @override
  State<SaveLocationDialog> createState() => _SaveLocationDialogState();
}

class _SaveLocationDialogState extends State<SaveLocationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  SavedLocationType _selectedType = SavedLocationType.home;
  bool _isLoading = false;
  final EnhancedLocationService _locationService = EnhancedLocationService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.location.customName;
    _landmarkController.text = widget.location.landmark ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildContent(),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  // 📱 HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bookmark_add,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save Location',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Add this location to your saved places',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📝 CONTENT
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location preview
          _buildLocationPreview(),
          const SizedBox(height: 20),
          
          // Location type selection
          _buildLocationTypeSelection(),
          const SizedBox(height: 20),
          
          // Custom name input
          _buildNameInput(),
          const SizedBox(height: 16),
          
          // Landmark input
          _buildLandmarkInput(),
        ],
      ),
    );
  }

  // 📍 LOCATION PREVIEW
  Widget _buildLocationPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.gradientStart,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Selected Location',
                style: GoogleFonts.poppins(
                  color: AppColors.gradientStart,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.location.detailedAddress,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 🏷️ LOCATION TYPE SELECTION
  Widget _buildLocationTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Save as',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: SavedLocationType.values.map((type) {
            bool isSelected = _selectedType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        type.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.displayName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: Duration(milliseconds: SavedLocationType.values.indexOf(type) * 100))
               .slideX(begin: 0.3, end: 0)
               .fadeIn(),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 📝 NAME INPUT
  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location Name',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'e.g., My Home, Office, etc.',
            hintStyle: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.gradientStart,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // 🏛️ LANDMARK INPUT
  Widget _buildLandmarkInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Landmark (Optional)',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _landmarkController,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'e.g., Near Metro Station, Mall, etc.',
            hintStyle: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.gradientStart,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // 🎮 ACTIONS
  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: TextButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Save button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientStart,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Save Location',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // 💾 SAVE LOCATION
  void _saveLocation() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a location name');
      return;
    }

    setState(() => _isLoading = true);

    try {
      SavedLocationModel locationToSave = widget.location.copyWith(
        id: 'saved_${DateTime.now().millisecondsSinceEpoch}',
        customName: _nameController.text.trim(),
        landmark: _landmarkController.text.trim().isEmpty 
            ? null 
            : _landmarkController.text.trim(),
        type: _selectedType,
      );

      bool success = await _locationService.saveLocation(locationToSave);
      
      if (success) {
        widget.onLocationSaved(locationToSave);
        Navigator.pop(context);
        _showSuccessSnackBar('Location saved successfully!');
      } else {
        _showErrorSnackBar('Failed to save location');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 📱 SNACKBAR HELPERS
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }
}
