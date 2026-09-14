import 'package:flutter/material.dart';

import '../models/unit_type.dart';

/// Mała ikona żołnierza (portret) - port rysunku canvas z artefaktu
/// "Wygląd żołnierzy - Koszary" na Flutter CustomPainter, w wybranej przez
/// gracza kolorystyce (patrz UnitType.palette).
class UnitPortrait extends StatelessWidget {
  final UnitType type;
  final double size;

  const UnitPortrait({super.key, required this.type, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.2,
      child: CustomPaint(painter: _UnitPortraitPainter(type)),
    );
  }
}

class _UnitPortraitPainter extends CustomPainter {
  static const double _w = 200;
  static const double _h = 240;

  final UnitType type;

  _UnitPortraitPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _w, size.height / _h);

    final p = type.palette;
    const skin = Color(0xFFE8B48C);
    const ink = Color(0xFF2B1D12);
    const cx = _w / 2;
    const groundY = _h - 26;

    // cień
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx, groundY + 6), width: 72, height: 18),
      Paint()..color = Colors.black.withValues(alpha: 0.16),
    );

    // peleryna
    if (p.cloak != null) {
      final cloakPath = Path()
        ..moveTo(cx - 24, groundY - 96)
        ..quadraticBezierTo(cx - 42, groundY - 40, cx - 18, groundY - 16)
        ..lineTo(cx + 18, groundY - 16)
        ..quadraticBezierTo(cx + 42, groundY - 40, cx + 24, groundY - 96)
        ..close();
      canvas.drawPath(cloakPath, Paint()..color = p.cloak!);
    }

    // nogi / buty
    final bootPaint = Paint()..color = const Color(0xFF4A3423);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 19, groundY - 30, 15, 30), const Radius.circular(4)),
      bootPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx + 4, groundY - 30, 15, 30), const Radius.circular(4)),
      bootPaint,
    );

    // tors / tunika
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 25, groundY - 96, 50, 68),
      const Radius.circular(13),
    );
    canvas.drawRRect(bodyRect, Paint()..color = p.tunic);
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = p.tunicDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // pas
    canvas.drawRect(
      Rect.fromLTWH(cx - 25, groundY - 42, 50, 8),
      Paint()..color = p.metalDark,
    );

    // napierśnik (zbrojny)
    if (type == UnitType.warrior) {
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(cx, groundY - 72), width: 46, height: 54),
        Paint()..color = p.metal,
      );
      final linePaint = Paint()
        ..color = p.metalDark
        ..strokeWidth = 2;
      for (final dx in [-14.0, 0.0, 14.0]) {
        canvas.drawLine(Offset(cx + dx, groundY - 84), Offset(cx + dx, groundY - 50), linePaint);
      }
    }

    // kołczan (łucznik)
    if (type == UnitType.archer) {
      canvas.save();
      canvas.translate(cx + 16, groundY - 88);
      canvas.rotate(0.35);
      final quiverRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-8, -26, 16, 42),
        const Radius.circular(4),
      );
      canvas.drawRRect(quiverRect, Paint()..color = p.metalDark);
      canvas.drawRRect(
        quiverRect,
        Paint()
          ..color = p.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.restore();
    }

    // głowa
    canvas.drawCircle(const Offset(cx, groundY - 108), 17, Paint()..color = skin);

    // nakrycie głowy
    if (type == UnitType.warrior) {
      final helmetPath = Path()
        ..addArc(
          Rect.fromCenter(center: const Offset(cx, groundY - 110), width: 38, height: 38),
          3.14159,
          3.14159,
        );
      canvas.drawPath(helmetPath, Paint()..color = p.metal);
      canvas.drawRect(Rect.fromLTWH(cx - 19, groundY - 110, 38, 7), Paint()..color = p.metal);
      final visorPaint = Paint()
        ..color = p.metalDark
        ..strokeWidth = 2;
      canvas.drawLine(Offset(cx - 6, groundY - 106), Offset(cx - 6, groundY - 97), visorPaint);
      canvas.drawLine(Offset(cx + 6, groundY - 106), Offset(cx + 6, groundY - 97), visorPaint);

      final plumePath = Path()
        ..moveTo(cx, groundY - 129)
        ..quadraticBezierTo(cx + 16, groundY - 146, cx + 3, groundY - 158)
        ..quadraticBezierTo(cx - 6, groundY - 142, cx, groundY - 129)
        ..close();
      canvas.drawPath(plumePath, Paint()..color = p.accent);
    } else if (type == UnitType.archer) {
      final hoodPath = Path()
        ..moveTo(cx - 19, groundY - 106)
        ..quadraticBezierTo(cx, groundY - 144, cx + 19, groundY - 106)
        ..quadraticBezierTo(cx, groundY - 120, cx - 19, groundY - 106)
        ..close();
      canvas.drawPath(hoodPath, Paint()..color = p.tunicDark);
    } else {
      final capPath = Path()
        ..addArc(
          Rect.fromCenter(center: const Offset(cx, groundY - 114), width: 36, height: 36),
          3.14159,
          3.14159,
        );
      canvas.drawPath(capPath, Paint()..color = p.metalDark);
    }

    // twarz
    final facePaint = Paint()..color = ink;
    canvas.drawCircle(Offset(cx - 5, groundY - 107), 1.7, facePaint);
    canvas.drawCircle(Offset(cx + 5, groundY - 107), 1.7, facePaint);

    // broń / ekwipunek
    if (type == UnitType.spearman) {
      final shaftPaint = Paint()
        ..color = const Color(0xFF6B4A2B)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(cx + 24, groundY - 8), Offset(cx + 38, groundY - 178), shaftPaint);
      final tipPath = Path()
        ..moveTo(cx + 38, groundY - 178)
        ..lineTo(cx + 30, groundY - 156)
        ..lineTo(cx + 44, groundY - 156)
        ..close();
      canvas.drawPath(tipPath, Paint()..color = p.metal);
      canvas.drawPath(
        tipPath,
        Paint()
          ..color = p.metalDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      canvas.drawCircle(Offset(cx - 32, groundY - 62), 14, Paint()..color = p.accent);
      canvas.drawCircle(
        Offset(cx - 32, groundY - 62),
        14,
        Paint()
          ..color = p.metalDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    } else if (type == UnitType.archer) {
      final bowPaint = Paint()
        ..color = const Color(0xFF6B4A2B)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(center: const Offset(cx - 36, groundY - 70), width: 84, height: 84),
        -0.85,
        1.7,
        false,
        bowPaint,
      );
    } else {
      final bladePaint = Paint()
        ..color = p.metal
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(cx + 22, groundY - 8), Offset(cx + 34, groundY - 116), bladePaint);
      final guardPaint = Paint()
        ..color = p.metalDark
        ..strokeWidth = 3;
      canvas.drawLine(Offset(cx + 18, groundY - 60), Offset(cx + 42, groundY - 60), guardPaint);
      final shieldRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 44, groundY - 86, 25, 42),
        const Radius.circular(6),
      );
      canvas.drawRRect(shieldRect, Paint()..color = p.accent);
      canvas.drawRRect(
        shieldRect,
        Paint()
          ..color = p.metalDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _UnitPortraitPainter oldDelegate) => oldDelegate.type != type;
}
