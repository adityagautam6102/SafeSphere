import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

class AnimatedCityscapeBackground extends StatefulWidget {
  const AnimatedCityscapeBackground({super.key});

  @override
  State<AnimatedCityscapeBackground> createState() =>
      _AnimatedCityscapeBackgroundState();
}

class _AnimatedCityscapeBackgroundState extends State<AnimatedCityscapeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
        return CustomPaint(
          painter: _AnimatedCityscapePainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _PinSpec {
  final double xFrac;
  final double yFrac;
  final Color color;
  final double phaseOffset;

  const _PinSpec(this.xFrac, this.yFrac, this.color, this.phaseOffset);
}

class _AnimatedCityscapePainter extends CustomPainter {
  final double t;

  _AnimatedCityscapePainter(this.t);

  static const pins = [
    _PinSpec(0.12, 0.28, Color(0xFF3B82F6), 0.0),
    _PinSpec(0.80, 0.16, Color(0xFF22C55E), 0.35),
    _PinSpec(0.88, 0.42, Color(0xFFEF4444), 0.65),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.55);

    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF0D1220), AppTheme.background],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    _paintBuildings(canvas, size);
    _paintDriftingCircuitLines(canvas, size);
    _paintPulsingPins(canvas, size);
  }

  void _paintBuildings(Canvas canvas, Size size) {
    final buildingPaint = Paint()..color = const Color(0xFF161B2E);
    final positions = [0.04, 0.10, 0.16, 0.22, 0.28, 0.34, 0.66, 0.72, 0.78, 0.84, 0.90, 0.96];

    for (int i = 0; i < positions.length; i++) {
      final x = positions[i] * size.width;
      final h = (0.14 + (i % 3) * 0.06) * size.height;
      final w = size.width * 0.018;
      canvas.drawRect(Rect.fromLTWH(x, size.height * 0.34 - h, w, h), buildingPaint);

      final phase = (t * 2 * pi) + i * 1.3;
      final twinkle = (sin(phase) + 1) / 2;
      final windowPaint = Paint()
        ..color = AppTheme.primary.withOpacity(0.12 + twinkle * 0.28);

      for (double y = size.height * 0.34 - h + 6; y < size.height * 0.34; y += 8) {
        canvas.drawCircle(Offset(x + w / 2, y), 1, windowPaint);
      }
    }
  }

  void _paintDriftingCircuitLines(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);
    for (int i = 0; i < 14; i++) {
      final baseX = i * (size.width / 14);
      final localT = (t + i * 0.07) % 1.0;
      final start = Offset(baseX, size.height * 0.12);
      final end = Offset.lerp(start, center, localT)!;
      final opacity = (1 - localT) * 0.12;

      final linePaint = Paint()
        ..color = AppTheme.primary.withOpacity(opacity)
        ..strokeWidth = 1;
      canvas.drawLine(start, end, linePaint);
    }
  }

  void _paintPulsingPins(Canvas canvas, Size size) {
    for (final pin in pins) {
      final center = Offset(pin.xFrac * size.width, pin.yFrac * size.height);
      final localT = (t + pin.phaseOffset) % 1.0;

      final ringRadius = 6 + localT * 34;
      final ringOpacity = (1 - localT).clamp(0.0, 1.0) * 0.5;
      final ringPaint = Paint()
        ..color = pin.color.withOpacity(ringOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, ringRadius, ringPaint);

      final localT2 = (t + pin.phaseOffset + 0.5) % 1.0;
      final ringRadius2 = 6 + localT2 * 34;
      final ringOpacity2 = (1 - localT2).clamp(0.0, 1.0) * 0.5;
      canvas.drawCircle(
        center,
        ringRadius2,
        Paint()
          ..color = pin.color.withOpacity(ringOpacity2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      canvas.drawCircle(
        center,
        4,
        Paint()
          ..color = pin.color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(center, 3, Paint()..color = pin.color);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedCityscapePainter oldDelegate) =>
      oldDelegate.t != t;
}
