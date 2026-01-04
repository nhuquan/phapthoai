import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool isDark;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.4),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: onTap,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
