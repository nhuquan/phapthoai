import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final Widget child;
  final bool isFirst;
  final bool isLast;
  final bool isDark;

  const TimelineItem({
    super.key,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: CustomPaint(
              painter: _TimelinePainter(
                isFirst: isFirst,
                isLast: isLast,
                color: isDark ? Colors.greenAccent : Colors.green,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;

  _TimelinePainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.5)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final dotPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw top line
    if (!isFirst) {
      canvas.drawLine(Offset(size.width / 2, 0), center, paint);
    }

    // Draw bottom line
    if (!isLast) {
      canvas.drawLine(center, Offset(size.width / 2, size.height), paint);
    }

    // Draw dot
    canvas.drawCircle(center, 6, dotPaint);

    // Draw dot border/glow
    final glowPaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 10, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
