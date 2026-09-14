import 'dart:math';

import 'package:flutter/material.dart';

import '../models/season.dart';

/// Dekoracyjna nakładka na tło planszy zbiorów (płatki wiosną, deszcz
/// jesienią, śnieg zimą) - rysowana raz na porę roku, nie odświeża się przy
/// każdym repaincie rodzica.
class SeasonBackground extends StatelessWidget {
  final Season season;

  const SeasonBackground({super.key, required this.season});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _SeasonBackgroundPainter(season)),
      ),
    );
  }
}

class _SeasonBackgroundPainter extends CustomPainter {
  final Season season;

  _SeasonBackgroundPainter(this.season);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(season.index);
    switch (season.boardOverlay) {
      case SeasonBoardOverlay.none:
        break;
      case SeasonBoardOverlay.petals:
        _drawPetals(canvas, size, random);
      case SeasonBoardOverlay.rain:
        _drawRain(canvas, size, random);
      case SeasonBoardOverlay.snow:
        _drawSnow(canvas, size, random);
    }
  }

  void _drawPetals(Canvas canvas, Size size, Random random) {
    final paint = Paint()..color = const Color(0xFFF7D9E3);
    for (var i = 0; i < 10; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height * 0.3;
      final r = 5 + random.nextDouble() * 4;
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(random.nextDouble() * 6);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: r * 2, height: r * 2 * 0.55), paint);
      canvas.restore();
    }
  }

  void _drawRain(Canvas canvas, Size size, Random random) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    for (var i = 0; i < 22; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawLine(Offset(x, y), Offset(x - 6, y + 16), paint);
    }
  }

  void _drawSnow(Canvas canvas, Size size, Random random) {
    final paint = Paint()
      ..color = const Color(0xFF78A0BE).withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 16; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final r = 5 + random.nextDouble() * 4;
      _drawSnowflake(canvas, Offset(x, y), r, paint);
    }
  }

  void _drawSnowflake(Canvas canvas, Offset center, double r, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.rotate((i / 3) * pi);
      canvas.drawLine(Offset(-r, 0), Offset(r, 0), paint);
      canvas.drawLine(Offset(-r * 0.5, -r * 0.35), Offset(-r * 0.75, 0), paint);
      canvas.drawLine(Offset(-r * 0.75, 0), Offset(-r * 0.5, r * 0.35), paint);
      canvas.drawLine(Offset(r * 0.5, -r * 0.35), Offset(r * 0.75, 0), paint);
      canvas.drawLine(Offset(r * 0.75, 0), Offset(r * 0.5, r * 0.35), paint);
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SeasonBackgroundPainter oldDelegate) => oldDelegate.season != season;
}
