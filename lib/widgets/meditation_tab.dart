import 'dart:math';
import 'package:flutter/material.dart';

class MeditationTab extends StatelessWidget {
  const MeditationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: 700,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 5 phút - Top Left
                    Positioned(
                      top: 0,
                      left: 60,
                      child: _SessionBlob(
                        duration: '5 phút',
                        color: const Color(0xFFB1BCAD),
                        size: 140,
                        rotation: -0.2,
                        onTap: () {},
                      ),
                    ),
                    // 10 phút - Top Right
                    Positioned(
                      top: 80,
                      right: 40,
                      child: _SessionBlob(
                        duration: '10 phút',
                        color: const Color(0xFFD6C1A8),
                        size: 150,
                        rotation: 0.1,
                        onTap: () {},
                      ),
                    ),
                    // 15 phút - Center (Active with ripples)
                    Positioned(
                      top: 220,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _SessionBlob(
                          duration: '15 phút',
                          color: const Color(0xFF748392),
                          size: 180,
                          isActive: true,
                          onTap: () {},
                        ),
                      ),
                    ),
                    // 20 phút - Middle Left
                    Positioned(
                      top: 400,
                      left: 40,
                      child: _SessionBlob(
                        duration: '20 phút',
                        color: const Color(0xFFB1BCAD),
                        size: 160,
                        rotation: 0.3,
                        onTap: () {},
                      ),
                    ),
                    // 30 phút - Middle Right
                    Positioned(
                      top: 480,
                      right: 60,
                      child: _SessionBlob(
                        duration: '30 phút',
                        color: const Color(0xFFD6C1A8),
                        size: 150,
                        rotation: -0.1,
                        onTap: () {},
                      ),
                    ),
                    // 45 phút - Bottom Left-ish
                    Positioned(
                      top: 580,
                      left: 100,
                      child: _SessionBlob(
                        duration: '45 phút',
                        color: const Color(0xFFB1BCAD),
                        size: 140,
                        rotation: 0.15,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Space for player
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionBlob extends StatelessWidget {
  final String duration;
  final Color color;
  final double size;
  final double rotation;
  final bool isActive;
  final VoidCallback onTap;

  const _SessionBlob({
    required this.duration,
    required this.color,
    required this.size,
    this.rotation = 0,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isActive) ...[
            _RippleAnimation(size: size * 1.5, color: color),
          ],
          Transform.rotate(
            angle: rotation,
            child: CustomPaint(
              size: Size(size, size),
              painter: _BlobPainter(color: color),
              child: SizedBox(
                width: size,
                height: size,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2E333A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.play_circle_filled,
                        size: 24,
                        color: const Color(0xFF2E333A).withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final Color color;

  _BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Organic blob shape using Bezier curves
    path.moveTo(w * 0.2, h * 0.2);
    path.quadraticBezierTo(w * 0.5, h * 0, w * 0.9, h * 0.1);
    path.quadraticBezierTo(w * 1.1, h * 0.4, w * 1.0, h * 0.7);
    path.quadraticBezierTo(w * 0.8, h * 1.0, w * 0.4, h * 0.9);
    path.quadraticBezierTo(w * 0.1, h * 0.9, w * 0.0, h * 0.6);
    path.quadraticBezierTo(w * 0.0, h * 0.3, w * 0.2, h * 0.2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RippleAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const _RippleAnimation({required this.size, required this.color});

  @override
  _RippleAnimationState createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<_RippleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
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
          alignment: Alignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              _RippleCircle(
                delay: i * 0.33,
                animationValue: _controller.value,
                maxSize: widget.size,
                color: widget.color,
              ),
          ],
        );
      },
    );
  }
}

class _RippleCircle extends StatelessWidget {
  final double delay;
  final double animationValue;
  final double maxSize;
  final Color color;

  const _RippleCircle({
    required this.delay,
    required this.animationValue,
    required this.maxSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double value = (animationValue + delay) % 1.0;
    double currentSize = maxSize * (0.6 + 0.4 * value);
    double opacity = (1.0 - value) * 0.2;

    return Container(
      width: currentSize,
      height: currentSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(opacity),
          width: 1.5,
        ),
      ),
    );
  }
}
