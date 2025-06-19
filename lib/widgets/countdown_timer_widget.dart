import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../constants/colors.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime expiry;
  final bool isExpired;

  const CountdownTimerWidget({
    super.key,
    required this.expiry,
    required this.isExpired,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with TickerProviderStateMixin {
  
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startTimer();
  }

  void _initializeAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    if (!widget.isExpired) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _startTimer() {
    if (widget.isExpired) return;
    
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeLeft();
      if (_timeLeft.inSeconds <= 0) {
        timer.cancel();
        _pulseController.stop();
      }
    });
  }

  void _updateTimeLeft() {
    if (mounted) {
      setState(() {
        _timeLeft = widget.expiry.difference(DateTime.now());
        if (_timeLeft.isNegative) {
          _timeLeft = Duration.zero;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isExpired || _timeLeft.inSeconds <= 0) {
      return _buildExpiredBadge();
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: _getGradientByTimeLeft(),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _getColorByTimeLeft().withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimeLeft(),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpiredBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'Expired',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientByTimeLeft() {
    if (_timeLeft.inHours >= 24) {
      // Green gradient for 24+ hours
      return const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
      );
    } else if (_timeLeft.inHours >= 6) {
      // Orange gradient for 6-24 hours
      return const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFE65100)],
      );
    } else if (_timeLeft.inHours >= 1) {
      // Red gradient for 1-6 hours
      return const LinearGradient(
        colors: [Color(0xFFFF5722), Color(0xFFD32F2F)],
      );
    } else {
      // Critical red gradient for < 1 hour
      return const LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
      );
    }
  }

  Color _getColorByTimeLeft() {
    if (_timeLeft.inHours >= 24) {
      return const Color(0xFF4CAF50);
    } else if (_timeLeft.inHours >= 6) {
      return const Color(0xFFFF9800);
    } else if (_timeLeft.inHours >= 1) {
      return const Color(0xFFFF5722);
    } else {
      return const Color(0xFFE91E63);
    }
  }

  String _formatTimeLeft() {
    if (_timeLeft.inDays > 0) {
      return '${_timeLeft.inDays}d ${_timeLeft.inHours % 24}h left';
    } else if (_timeLeft.inHours > 0) {
      return '${_timeLeft.inHours}h ${_timeLeft.inMinutes % 60}m left';
    } else if (_timeLeft.inMinutes > 0) {
      return '${_timeLeft.inMinutes}m ${_timeLeft.inSeconds % 60}s left';
    } else {
      return '${_timeLeft.inSeconds}s left';
    }
  }
}
