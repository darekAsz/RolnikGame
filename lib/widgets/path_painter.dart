import 'package:flutter/material.dart';

import '../models/grid_position.dart';

class PathPainter extends CustomPainter {
  final List<GridPosition> path;
  final double cellSize;
  final Color? color;

  PathPainter({required this.path, required this.cellSize, required this.color});

  Offset _center(GridPosition p) =>
      Offset(p.col * cellSize + cellSize / 2, p.row * cellSize + cellSize / 2);

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2 || color == null) return;

    final linePaint = Paint()
      ..color = color!.withValues(alpha: 0.85)
      ..strokeWidth = cellSize * 0.18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final points = path.map(_center).toList();
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    for (final point in points) {
      canvas.drawCircle(point, cellSize * 0.07, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.color != color;
  }
}
