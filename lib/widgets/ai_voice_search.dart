import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../constants/colors.dart';

class AIVoiceSearch extends StatefulWidget {
  final Function(String) onSearchResult;
  final VoidCallback? onClose;

  const AIVoiceSearch({super.key, required this.onSearchResult, this.onClose});

  @override
  State<AIVoiceSearch> createState() => _AIVoiceSearchState();
}

class _AIVoiceSearchState extends State<AIVoiceSearch>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  bool _isListening = false;
  bool _isProcessing = false;
  String _currentText = '';
  final List<String> _suggestions = [
    'iPhone 15 Pro Max dhund rahe ho?',
    'Kya chahiye aapko bazarse mein?',
    'Latest fashion trends dekho',
    'Electronics mein kya naya hai?',
    'Best deals kahan milenge?',
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_waveController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
      _currentText = '';
    });

    _pulseController.repeat();
    _waveController.repeat();

    // Mock voice recognition - In real app, use speech_to_text package
    await Future.delayed(const Duration(seconds: 3));

    // Simulate voice input
    final mockResults = [
      'iPhone 15 Pro Max',
      'Nike shoes under 5000',
      'Best laptop for gaming',
      'Organic food items',
      'Latest fashion trends',
    ];

    final result = mockResults[math.Random().nextInt(mockResults.length)];

    setState(() {
      _currentText = result;
      _isListening = false;
      _isProcessing = true;
    });

    _pulseController.stop();
    _waveController.stop();

    // Process the result
    await Future.delayed(const Duration(seconds: 1));

    widget.onSearchResult(result);

    setState(() {
      _isProcessing = false;
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _isProcessing = false;
    });
    _pulseController.stop();
    _waveController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'AI Voice Search',
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Central AI Orb
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _pulseController,
                    _waveController,
                  ]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.gradientStart.withOpacity(0.8),
                              AppColors.gradientMiddle.withOpacity(0.6),
                              AppColors.gradientEnd.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradientStart.withOpacity(0.5),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: AppColors.gradientEnd.withOpacity(0.3),
                              blurRadius: 80,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Ring
                            if (_isListening)
                              Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .scale(
                                    begin: const Offset(0.8, 0.8),
                                    end: const Offset(1.2, 1.2),
                                    duration: const Duration(seconds: 2),
                                  )
                                  .fadeOut(
                                    duration: const Duration(seconds: 2),
                                  ),

                            // Inner Orb
                            GestureDetector(
                              onTap: _isListening
                                  ? _stopListening
                                  : _startListening,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.gradientStart,
                                      AppColors.gradientMiddle,
                                      AppColors.gradientEnd,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  _isListening
                                      ? Icons.mic_rounded
                                      : _isProcessing
                                      ? Icons.auto_awesome_rounded
                                      : Icons.mic_none_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            // Wave Animation
                            if (_isListening)
                              ...List.generate(3, (index) {
                                return Container(
                                      width: 140 + (index * 20),
                                      height: 140 + (index * 20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(
                                            0.2 - (index * 0.05),
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .scale(
                                      begin: const Offset(0.5, 0.5),
                                      end: const Offset(1.5, 1.5),
                                      duration: Duration(
                                        milliseconds: 2000 + (index * 200),
                                      ),
                                    )
                                    .fadeOut(
                                      duration: Duration(
                                        milliseconds: 2000 + (index * 200),
                                      ),
                                    );
                              }),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Status Text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _isListening
                        ? 'Suniye... Aap kya dhund rahe hain?'
                        : _isProcessing
                        ? 'AI samajh raha hai...'
                        : _currentText.isNotEmpty
                        ? '"$_currentText"'
                        : 'Mic button dabayiye aur boliye',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Suggestions
                if (!_isListening && !_isProcessing && _currentText.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kuch aise try kariye:',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(_suggestions.length, (index) {
                          return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: GestureDetector(
                                  onTap: () => widget.onSearchResult(
                                    _suggestions[index],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      _suggestions[index],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: Duration(milliseconds: index * 100),
                                duration: const Duration(milliseconds: 400),
                              )
                              .slideX(
                                begin: -0.3,
                                end: 0,
                                delay: Duration(milliseconds: index * 100),
                                duration: const Duration(milliseconds: 500),
                              );
                        }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles = [];

  ParticlesPainter(this.animationValue) {
    // Generate particles
    for (int i = 0; i < 50; i++) {
      particles.add(Particle());
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = (particle.x + animationValue * particle.speedX) % size.width;
      final y = (particle.y + animationValue * particle.speedY) % size.height;

      paint.color = particle.color.withOpacity(
        (math.sin(animationValue * 2 * math.pi + particle.phase) + 1) / 2 * 0.3,
      );

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double speedX;
  final double speedY;
  final double size;
  final Color color;
  final double phase;

  Particle()
    : x = math.Random().nextDouble() * 400,
      y = math.Random().nextDouble() * 800,
      speedX = (math.Random().nextDouble() - 0.5) * 100,
      speedY = (math.Random().nextDouble() - 0.5) * 100,
      size = math.Random().nextDouble() * 3 + 1,
      color = [
        AppColors.gradientStart,
        AppColors.gradientMiddle,
        AppColors.gradientEnd,
      ][math.Random().nextInt(3)],
      phase = math.Random().nextDouble() * 2 * math.pi;
}
