import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ExternalWall extends PositionComponent {
  static const Color color = Colors.white;
  static final Paint paint = Paint()..color = color;

  final double cellSize;
  final int posX;
  final int posY;
  final double margin;
  final double radius;
  ExternalWall({
    required this.cellSize,
    required this.posX,
    required this.posY, this.margin = 0, this.radius = 0}) {
    anchor = Anchor.topLeft;
    position = Vector2(posX * cellSize, posY * cellSize);
    size = Vector2(cellSize, cellSize);
    priority = 1000;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(margin, margin, size.x - margin, size.y - margin), 
        Radius.circular(radius),
      ),
      paint,
    );
  }
}
