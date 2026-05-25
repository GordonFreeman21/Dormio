import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class WaveformVisualizer extends StatelessWidget {
  final List<double> amplitudeSamples;
  final bool isLive;

  const WaveformVisualizer({
    super.key,
    required this.amplitudeSamples,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 100),
      painter: _WaveformPainter(
        samples: amplitudeSamples,
        isLive: isLive,
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> samples;
  final bool isLive;

  _WaveformPainter({required this.samples, required this.isLive});

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.moonGlow
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;
    final spacing = size.width / (samples.length - 1);

    for (int i = 0; i < samples.length; i++) {
      final x = i * spacing;
      final normalizedValue = samples[i].clamp(0.0, 100.0) / 100.0;
      final barHeight = normalizedValue * size.height;

      canvas.drawLine(
        Offset(x, midY - barHeight / 2),
        Offset(x, midY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
