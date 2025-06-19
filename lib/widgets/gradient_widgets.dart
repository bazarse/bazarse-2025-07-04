import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const GradientText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

class GradientContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const GradientContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientMiddle.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GradientBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const GradientBorder({
    super.key,
    required this.child,
    this.borderWidth = 2,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}

class AnimatedGradientIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Duration duration;

  const AnimatedGradientIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedGradientIcon> createState() => _AnimatedGradientIconState();
}

class _AnimatedGradientIconState extends State<AnimatedGradientIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                AppColors.gradientStart,
                AppColors.gradientMiddle,
                AppColors.gradientEnd,
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: Icon(
            widget.icon,
            size: widget.size,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class PulsingGradientContainer extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double? width;
  final double? height;

  const PulsingGradientContainer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: child,
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: duration,
          color: AppColors.gradientMiddle.withOpacity(0.3),
        )
        .scale(
          begin: const Offset(0.98, 0.98),
          end: const Offset(1.02, 1.02),
          duration: duration,
        );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 50,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientMiddle.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
