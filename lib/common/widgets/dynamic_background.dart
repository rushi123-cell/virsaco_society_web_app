import 'dart:math';
import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class DynamicBackground extends StatefulWidget {
  final Widget child;
  const DynamicBackground({super.key, required this.child});

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
        return Stack(
          children: [
            // Background Base
            Container(color: AppColors.background),
            
            // Animated Gradients/Shapes
            Positioned.fill(
              child: CustomPaint(
                painter: _BackgroundPainter(_controller.value),
              ),
            ),
            
            // Blur effect for glassmorphism feel
            Positioned.fill(
              child: BackdropFilter(
                filter: ColorFilter.mode(
                  AppColors.background.withOpacity(0.4),
                  BlendMode.srcOver,
                ),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double animationValue;
  _BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Deep Teal Blob
    final center1 = Offset(
      size.width * (0.2 + 0.1 * sin(animationValue * 2 * pi)),
      size.height * (0.3 + 0.1 * cos(animationValue * 2 * pi)),
    );
    paint.color = AppColors.primary.withOpacity(0.12);
    canvas.drawCircle(center1, size.width * 0.4, paint);

    // Light Teal Blob
    final center2 = Offset(
      size.width * (0.8 + 0.1 * cos(animationValue * 2 * pi)),
      size.height * (0.7 + 0.1 * sin(animationValue * 2 * pi)),
    );
    paint.color = AppColors.primary.withOpacity(0.1);
    canvas.drawCircle(center2, size.width * 0.35, paint);
    
    // Navy Soft Blob
    final center3 = Offset(
      size.width * (0.5 + 0.1 * sin(animationValue * 4 * pi)),
      size.height * (0.5 + 0.1 * cos(animationValue * 4 * pi)),
    );
    paint.color = AppColors.secondary.withOpacity(0.05);
    canvas.drawCircle(center3, size.width * 0.3, paint);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) => true;
}
