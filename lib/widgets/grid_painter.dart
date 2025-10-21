// lib/widgets/grid_painter.dart
// Draws grid background on canvas

import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double gridSize;
  final Color gridColor;

  GridPainter({this.gridSize = 20, this.gridColor = const Color(0xFFD0D0D0)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
