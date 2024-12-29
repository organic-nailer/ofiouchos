import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Controller extends PositionComponent {
  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  Controller({required super.position, required super.size});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    // ジョイスティックを追加
    add(JoystickComponent(
      knob: CircleComponent(
        paint: Paint()..color = Colors.blue,
        radius: size.y * 0.25,
      ),
      background: CircleComponent(
        paint: Paint()..color = Colors.blue.withAlpha(100),
        radius: size.y * 0.45,
      ),
    )
      ..position = Vector2(size.y * 0.5, size.y * 0.5)
      ..anchor = Anchor.center);

    // 三角形の顔を追加
    add(_TriFace(
      position: Vector2(size.y, size.y * 0.05), 
      height: size.y * 0.45,
      )..anchor = Anchor.topLeft);

    // キーキャップを追加
    final keyCapSize = Vector2(size.y * 0.2, size.y * 0.2);
    final keyCapA = KeyCap(
      position: Vector2(size.y, size.y * 0.5 + keyCapSize.y), 
      size: keyCapSize,
      label: 'A',
    );
    keyCapA.anchor = Anchor.topLeft;
    add(keyCapA);
    final keyCapW = KeyCap(
      position: Vector2(size.y + keyCapSize.x, size.y * 0.5), 
      size: keyCapSize,
      label: 'W',
    );
    keyCapW.anchor = Anchor.topLeft;
    add(keyCapW);
    final keyCapS = KeyCap(
      position: Vector2(size.y + keyCapSize.x, size.y * 0.5 + keyCapSize.y), 
      size: keyCapSize,
      label: 'S',
    );
    keyCapS.anchor = Anchor.topLeft;
    add(keyCapS);
    final keyCapD = KeyCap(
      position: Vector2(size.y + keyCapSize.x * 2, size.y * 0.5 + keyCapSize.y), 
      size: keyCapSize,
      label: 'D',
    );
    keyCapD.anchor = Anchor.topLeft;
    add(keyCapD);
  }
}

class _TriFace extends PositionComponent {
  static const Color eyeColor = Colors.black;
  static final Paint eyePaint = Paint()..color = eyeColor;
  final double height;
  _TriFace({required super.position, required this.height}) {
    size = Vector2(height * 2, height);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          0, 
          0, 
          size.x, 
          size.y,
        ), 
        Radius.circular(height * 0.25),
      ),
      Paint()..color = Colors.white,
    );
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.drawPath(
        Path()
          ..moveTo(size.x * -0.25, size.y * -0.25)
          ..lineTo(size.x * -0.125, size.y * -0.25)
          ..lineTo(size.x * -0.25, size.y * -0.125)
          ..close(),
        eyePaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(size.x * 0.25, size.y * -0.25)
          ..lineTo(size.x * 0.125, size.y * -0.25)
          ..lineTo(size.x * 0.25, size.y * -0.125)
          ..close(),
        eyePaint,
      );
      canvas.restore();
  }
}

class KeyCap extends PositionComponent {
  final String label;

  KeyCap({required super.position, required Vector2 size, required this.label}) {
    this.size = Vector2(100, 100);
    scale = Vector2(size.x / this.size.x, size.y / this.size.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.x, size.y), 
        Radius.circular(16),
      ),
      Paint()..color = Colors.white,
    );

    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 75,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas, 
      Offset(
        (size.x - textPainter.width) / 2, 
        (size.y - textPainter.height) / 2,
      ),
    );
  }
}