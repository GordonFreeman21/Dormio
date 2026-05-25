import 'dart:math';
import 'package:flutter/material.dart';

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarFieldPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var star in stars) {
      final opacity = (star.baseOpacity * (0.5 + 0.5 * sin(animationValue * 2 * pi + star.offset))).clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) => true;
}

class Star {
  final double x;
  final double y;
  final double size;
  final double baseOpacity;
  final double offset;

  Star({required this.x, required this.y, required this.size, required this.baseOpacity, required this.offset});

  factory Star.random() {
    final random = Random();
    return Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 1.5 + 0.5,
      baseOpacity: random.nextDouble() * 0.7 + 0.3,
      offset: random.nextDouble() * 2 * pi,
    );
  }
}
