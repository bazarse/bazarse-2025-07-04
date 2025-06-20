import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../widgets/animated_background.dart';
import 'claim_business_success_page.dart';

class ClaimBusinessVerificationPage extends StatefulWidget {
  final Map<String, dynamic> business;

  const ClaimBusinessVerificationPage({
    super.key,
    required this.business,
  });

  @override
  State<ClaimBusinessVerificationPage> createState() => _ClaimBusinessVerificationPageState();
}

class _ClaimBusinessVerificationPageState extends State<ClaimBusinessVerificationPage>
    with TickerProviderStateMixin {
  
  int _currentStep = 0;
  
  // Controllers
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _progressController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;
  
  // State variables
  bool _isLoading = false;
  bool _gstVerified = false;
  bool _otpSent = false;
  bool _otpVerified = false;
  bool _passwordVisible = false;

  final List<String> _stepTitles = [
    'GST Verification',
    'Mobile Verification',
    'OTP Verification',
    'Account Setup',
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

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _updateProgress();
  }

  void _updateProgress() {
    _progressController.animateTo((_currentStep + 1) / _stepTitles.length);
  }

  @override
  void dispose() {
    _gstController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _progressController.dispose();
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
              
              // 🔥 PROGRESS INDICATOR 🔥
              _buildProgressIndicator(),
              
              // 🔥 STEP CONTENT 🔥
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildCurrentStep(),
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
                    'Claim Business',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.business['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gradientStart,
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

  // 🔥 PROGRESS INDICATOR 🔥
  Widget _buildProgressIndicator() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Step Title
            Text(
              _stepTitles[_currentStep],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress Bar
            AnimatedBuilder(
              animation: _progressAnimation,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              builder: (context, child) {
                return Stack(
                  children: [
                    child!,
                    FractionallySizedBox(
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradientStart.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Step Counter
            Text(
              'Step ${_currentStep + 1} of ${_stepTitles.length}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 CURRENT STEP CONTENT 🔥
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildGSTStep();
      case 1:
        return _buildMobileStep();
      case 2:
        return _buildOTPStep();
      case 3:
        return _buildAccountSetupStep();
      default:
        return Container();
    }
  }

  // 🔥 GST VERIFICATION STEP 🔥
  Widget _buildGSTStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // GST Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradientStart.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'GST Verification',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Enter your business GST number for verification',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // GST Input Field
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  AppColors.gradientMiddle.withValues(alpha: 0.2),
                  AppColors.gradientEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _gstVerified 
                    ? Colors.green 
                    : AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _gstController,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
              ],
              decoration: InputDecoration(
                hintText: 'Enter GST Number (e.g., 22AAAAA0000A1Z5)',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.receipt,
                  color: AppColors.gradientStart,
                  size: 22,
                ),
                suffixIcon: _gstVerified
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 22,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Demo Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Demo Mode: Any 15-character GST format will work',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Verify Button
          _buildActionButton(
            'Verify GST',
            _isLoading,
            _gstController.text.length >= 15,
            () => _verifyGST(),
          ),
        ],
      ),
    );
  }

  // 🔥 MOBILE VERIFICATION STEP 🔥
  Widget _buildMobileStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Mobile Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradientStart.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.phone_android,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Mobile Verification',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Enter your mobile number to receive OTP',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Mobile Input Field
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  AppColors.gradientMiddle.withValues(alpha: 0.2),
                  AppColors.gradientEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: 'Enter 10-digit mobile number',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.phone,
                  color: AppColors.gradientStart,
                  size: 22,
                ),
                prefixText: '+91 ',
                prefixStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Send OTP Button
          _buildActionButton(
            'Send OTP',
            _isLoading,
            _mobileController.text.length == 10,
            () => _sendOTP(),
          ),
        ],
      ),
    );
  }

  // 🔥 OTP VERIFICATION STEP 🔥
  Widget _buildOTPStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const SizedBox(height: 20),

          // OTP Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradientStart.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.sms,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Enter OTP',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'We sent a 6-digit code to +91 ${_mobileController.text}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // OTP Input Field
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  AppColors.gradientMiddle.withValues(alpha: 0.2),
                  AppColors.gradientEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _otpVerified
                    ? Colors.green
                    : AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 8,
                ),
                suffixIcon: _otpVerified
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 22,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Demo Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Demo Mode: Use OTP "123456" for verification',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Verify OTP Button
          _buildActionButton(
            'Verify OTP',
            _isLoading,
            _otpController.text.length == 6,
            () => _verifyOTP(),
          ),
        ],
      ),
    );
  }

  // 🔥 ACCOUNT SETUP STEP 🔥
  Widget _buildAccountSetupStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Account Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradientStart.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Account Setup',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Create your vendor account credentials',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Username Input Field
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  AppColors.gradientMiddle.withValues(alpha: 0.2),
                  AppColors.gradientEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _usernameController,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Choose a username',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: AppColors.gradientStart,
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Password Input Field
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.3),
                  AppColors.gradientMiddle.withValues(alpha: 0.2),
                  AppColors.gradientEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Create a password',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: AppColors.gradientStart,
                  size: 22,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Complete Setup Button
          _buildActionButton(
            'Complete Setup',
            _isLoading,
            _usernameController.text.isNotEmpty && _passwordController.text.length >= 6,
            () => _completeSetup(),
          ),
        ],
      ),
    );
  }

  // 🔥 ACTION BUTTON 🔥
  Widget _buildActionButton(String text, bool isLoading, bool isEnabled, VoidCallback onPressed) {
    return GestureDetector(
      onTap: isEnabled && !isLoading ? onPressed : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isEnabled && !isLoading
              ? AppColors.primaryGradient
              : LinearGradient(
                  colors: [
                    Colors.grey.shade600,
                    Colors.grey.shade700,
                  ],
                ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isEnabled && !isLoading
              ? [
                  BoxShadow(
                    color: AppColors.gradientStart.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  // 🔥 VERIFY GST 🔥
  Future<void> _verifyGST() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate GST verification delay
    await Future.delayed(const Duration(seconds: 2));

    // Demo: Any 15-character GST format is valid
    if (_gstController.text.length >= 15) {
      setState(() {
        _gstVerified = true;
        _isLoading = false;
      });

      // Show success message
      _showSuccessSnackBar('GST verified successfully!');

      // Move to next step after delay
      await Future.delayed(const Duration(milliseconds: 1500));
      _nextStep();
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Invalid GST number format');
    }
  }

  // 🔥 SEND OTP 🔥
  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate OTP sending delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _otpSent = true;
      _isLoading = false;
    });

    _showSuccessSnackBar('OTP sent to +91 ${_mobileController.text}');

    // Move to next step
    await Future.delayed(const Duration(milliseconds: 1000));
    _nextStep();
  }

  // 🔥 VERIFY OTP 🔥
  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate OTP verification delay
    await Future.delayed(const Duration(seconds: 1));

    // Demo: OTP "123456" is valid
    if (_otpController.text == '123456') {
      setState(() {
        _otpVerified = true;
        _isLoading = false;
      });

      _showSuccessSnackBar('OTP verified successfully!');

      // Move to next step after delay
      await Future.delayed(const Duration(milliseconds: 1500));
      _nextStep();
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Invalid OTP. Use 123456 for demo');
    }
  }

  // 🔥 COMPLETE SETUP 🔥
  Future<void> _completeSetup() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate account creation delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Navigate to success page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ClaimBusinessSuccessPage(
          business: widget.business,
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      ),
    );
  }

  // 🔥 NEXT STEP 🔥
  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _updateProgress();

      // Reset slide animation for new step
      _slideController.reset();
      _slideController.forward();
    }
  }

  // 🔥 SUCCESS SNACKBAR 🔥
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
