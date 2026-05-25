import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/snore_event.dart';

class SnoreTimeline extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final List<SnoreEvent> events;

  const SnoreTimeline({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(
        painter: _TimelinePainter(
          startTime: startTime,
          endTime: endTime,
          events: events,
        ),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final DateTime startTime;
  final DateTime endTime;
  final List<SnoreEvent> events;

  _TimelinePainter({
    required this.startTime,
    required this.endTime,
    required this.events,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final totalDuration = endTime.difference(startTime).inSeconds;
    if (totalDuration <= 0) return;

    final paint = Paint()
      ..color = AppColors.snoreRed
      ..style = PaintingStyle.fill;

    for (var event in events) {
      final offsetSeconds = event.timestamp.difference(startTime).inSeconds;
      final x = (offsetSeconds / totalDuration) * size.width;

      canvas.drawCircle(
        Offset(x, size.height / 2),
        4,
        paint,
      );

      // Simple "ripple" effect circle
      canvas.drawCircle(
        Offset(x, size.height / 2),
        8,
        paint..color = AppColors.snoreRed.withOpacity(0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
