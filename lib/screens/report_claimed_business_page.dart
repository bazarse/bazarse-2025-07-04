import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';

class ReportClaimedBusinessPage extends StatefulWidget {
  final Map<String, dynamic> business;

  const ReportClaimedBusinessPage({
    super.key,
    required this.business,
  });

  @override
  State<ReportClaimedBusinessPage> createState() => _ReportClaimedBusinessPageState();
}

class _ReportClaimedBusinessPageState extends State<ReportClaimedBusinessPage>
    with TickerProviderStateMixin {
  
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  
  String _selectedReason = '';
  bool _isSubmitting = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _reportReasons = [
    {
      'title': 'Incorrect Business Information',
      'subtitle': 'Wrong name, address, or contact details',
      'icon': Icons.info_outline,
    },
    {
      'title': 'Business is Closed/Not Operating',
      'subtitle': 'This business is permanently closed',
      'icon': Icons.store_mall_directory_outlined,
    },
    {
      'title': 'Fraudulent Claim',
      'subtitle': 'Someone falsely claimed this business',
      'icon': Icons.report_problem_outlined,
    },
    {
      'title': 'I am the Real Owner',
      'subtitle': 'I own this business and want to claim it',
      'icon': Icons.person_outline,
    },
    {
      'title': 'Duplicate Listing',
      'subtitle': 'This business is listed multiple times',
      'icon': Icons.content_copy_outlined,
    },
    {
      'title': 'Other Issue',
      'subtitle': 'Something else is wrong with this listing',
      'icon': Icons.help_outline,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _detailsController.dispose();
    _contactController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 🔥 HEADER 🔥
              _buildHeader(),
              
              // 🔥 CONTENT 🔥
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildBusinessCard(),
                      const SizedBox(height: 24),
                      _buildReportReasons(),
                      if (_selectedReason.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildDetailsForm(),
                        const SizedBox(height: 24),
                        _buildSubmitButton(),
                      ],
                      const SizedBox(height: 20),
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

  // 🔥 HEADER 🔥
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Business',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Help us maintain accurate listings',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 BUSINESS CARD 🔥
  Widget _buildBusinessCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.withValues(alpha: 0.2),
              Colors.orange.withValues(alpha: 0.1),
              Colors.red.withValues(alpha: 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Business Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getBusinessIcon(widget.business['category']),
                color: Colors.white,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Business Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.business['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Claimed',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    widget.business['category'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    widget.business['address'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  if (widget.business['claimed_by'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Claimed by: ${widget.business['claimed_by']['owner_name']}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 REPORT REASONS 🔥
  Widget _buildReportReasons() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why are you reporting this business?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...List.generate(_reportReasons.length, (index) {
            final reason = _reportReasons[index];
            final isSelected = _selectedReason == reason['title'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedReason = reason['title'];
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.gradientStart.withValues(alpha: 0.3),
                            AppColors.gradientMiddle.withValues(alpha: 0.2),
                            AppColors.gradientEnd.withValues(alpha: 0.3),
                          ],
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.gradientStart.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      reason['icon'],
                      color: isSelected ? AppColors.gradientStart : Colors.white.withValues(alpha: 0.7),
                      size: 24,
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reason['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reason['subtitle'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.gradientStart,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // 🔥 DETAILS FORM 🔥
  Widget _buildDetailsForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Details',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Details Text Area
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  AppColors.gradientMiddle.withValues(alpha: 0.2),
                  AppColors.gradientEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _detailsController,
              maxLines: 4,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Please provide more details about the issue...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Contact Information
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  AppColors.gradientMiddle.withValues(alpha: 0.2),
                  AppColors.gradientEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _contactController,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Your contact number (optional)',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.phone,
                  color: AppColors.gradientStart,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 SUBMIT BUTTON 🔥
  Widget _buildSubmitButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: _isSubmitting ? null : _submitReport,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: _isSubmitting
                ? LinearGradient(
                    colors: [
                      Colors.grey.shade600,
                      Colors.grey.shade700,
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.red.shade600,
                      Colors.red.shade700,
                      Colors.red.shade800,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: _isSubmitting
                ? null
                : [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
          ),
          child: Center(
            child: _isSubmitting
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.report,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Submit Report',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // 🔥 GET BUSINESS ICON 🔥
  IconData _getBusinessIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mobile & electronics':
      case 'mobile shop':
        return Icons.phone_android;
      case 'electronics store':
        return Icons.electrical_services;
      case 'restaurant':
        return Icons.restaurant;
      case 'grocery':
        return Icons.local_grocery_store;
      default:
        return Icons.business;
    }
  }

  // 🔥 SUBMIT REPORT 🔥
  Future<void> _submitReport() async {
    if (_selectedReason.isEmpty) {
      _showErrorSnackBar('Please select a reason for reporting');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    // Show success message
    _showSuccessDialog();
  }

  // 🔥 SUCCESS DIALOG 🔥
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.green.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Report Submitted',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Thank you for your report. Our team will review this business listing and take appropriate action within 24-48 hours.',
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 ERROR SNACKBAR 🔥
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
