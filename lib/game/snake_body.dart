import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:ofiouchos/util/direction.dart';
import 'package:ofiouchos/util/faces.dart';

enum HeadType {
  rectangle,
  waseda,
  keio,
}

class SnakeBody extends PositionComponent {
  static const Color eyeColor = Colors.black;
  static final Paint eyePaint = Paint()..color = eyeColor;
  static const Color patternColor = Colors.black54;
  static final Paint patternPaint = Paint()..color = patternColor;

  final double margin;
  final double radius;
  final double cellSize;
  final Direction direction;
  final int posX;
  final int posY;
  final Color color;
  late final Paint paint;
  HeadType? _headType;
  SnakeBody({
    required this.direction,
    required this.posX,
    required this.posY,
    required this.cellSize,
    this.margin = 0,
    this.radius = 0,
    HeadType? headType,
    this.color = Colors.white,
  }) {
    _headType = headType;
    anchor = Anchor.topLeft;
    position = Vector2(posX * cellSize + cellSize/2, posY * cellSize + cellSize/2);
    size = Vector2(cellSize, cellSize);
    scale = Vector2.all(0.0);
    paint = Paint()..color = color;
  }

  @override
  void onLoad() {
    super.onLoad();

    if (_headType != null) {
      CustomPainter painter;
      switch (_headType!) {
        case HeadType.rectangle:
          painter = RectFacePainter();
          break;
        case HeadType.waseda:
          painter = WasedaFacePainter();
          break;
        case HeadType.keio:
          painter = KeioFacePainter();
          break;
      }
      add(CustomPainterComponent(
        painter: painter,
        size: size,
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
        angle: direction.angle,
      ));
    }

    // effect
    final controller = EffectController(duration: 0.5, curve: Curves.easeIn);
    add(ScaleEffect.to(Vector2.all(1.0), controller));
    add(MoveEffect.to(Vector2(posX * cellSize, posY * cellSize), controller));
  }

  set headType(HeadType? headType) {
    if (headType == null) {
      removeWhere((c) => c is CustomPainterComponent);
      return;
    }
    _headType = headType;
      CustomPainter painter;
      switch (_headType!) {
        case HeadType.rectangle:
          painter = RectFacePainter();
          break;
        case HeadType.waseda:
          painter = WasedaFacePainter();
          break;
        case HeadType.keio:
          painter = KeioFacePainter();
          break;
      }
      add(CustomPainterComponent(
        painter: painter,
        size: size,
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
        angle: direction.angle,
      ));
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

    // if (isHead) {
    //   // 目を描画
    //   canvas.save();
    //   canvas.translate(size.x / 2, size.y / 2);
    //   canvas.rotate(direction.angle);
    //   if (isTriangle) {
    //   canvas.drawPath(
    //     Path()
    //       ..moveTo(size.x * -0.25, size.y * -0.25)
    //       ..lineTo(size.x * -0.125, size.y * -0.25)
    //       ..lineTo(size.x * -0.25, size.y * -0.125)
    //       ..close(),
    //     eyePaint,
    //   );
    //   canvas.drawPath(
    //     Path()
    //       ..moveTo(size.x * 0.25, size.y * -0.25)
    //       ..lineTo(size.x * 0.125, size.y * -0.25)
    //       ..lineTo(size.x * 0.25, size.y * -0.125)
    //       ..close(),
    //     eyePaint,
    //   );
    // } else {
    //   canvas.drawRect(
    //     Rect.fromLTWH(size.x * (0.25-0.5), size.y * (0.25-0.5), size.x * 0.125, size.y * 0.125),
    //     eyePaint,
    //   );
    //   canvas.drawRect(
    //     Rect.fromLTWH(size.x * (0.625-0.5), size.y * (0.25-0.5), size.x * 0.125, size.y * 0.125),
    //     eyePaint,
    //   );
    // }
    //   canvas.restore();
    // }
  }

  Future<void> purge() async {
    final controller = EffectController(duration: 0.5, curve: Curves.easeIn);

    final effectScale = SequenceEffect([
      ScaleEffect.to(
        Vector2.all(0.0),
        controller,
      ),
      RemoveEffect(),
    ]);
    add(effectScale);
    final effectMove = MoveEffect.to(position + size / 2,
      controller,
    );
    add(effectMove);
    // final effectOpacity = OpacityEffect.to(0.0, controller);
    // add(effectOpacity);
  }
}
