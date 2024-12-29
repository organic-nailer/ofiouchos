import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Apple extends PositionComponent {
  static const Color color = Colors.white;
  static final Paint paint = Paint()..color = color;

  final double cellSize;
  final int posX;
  final int posY;
  Apple({required this.cellSize, required this.posX, required this.posY}) {
    anchor = Anchor.topLeft;
    position = Vector2(posX * cellSize, posY * cellSize);
    size = Vector2(cellSize, cellSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    canvas.drawOval(
      Rect.fromLTRB(size.x * 0.25, size.y * 0.25, size.x * 0.75, size.y * 0.75),
      paint,
    );
  }
  
  void purge() {
    removeFromParent();
  }
}
