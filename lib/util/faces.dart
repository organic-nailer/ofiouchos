import 'package:flutter/widgets.dart';

class RectFacePainter extends CustomPainter {
  static const Color color = Color(0xAA000000);
  static final Paint forePaint = Paint()..color = color;
  static final Size canvasSize = Size(96, 96);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // scale
    final double scaleX = size.width / canvasSize.width;
    final double scaleY = size.height / canvasSize.height;
    canvas.scale(scaleX, scaleY);
    // draw
    canvas.drawRect(
      Rect.fromLTWH(24, 12, 12, 12),
      forePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(60, 12, 12, 12),
      forePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TriFacePainter extends CustomPainter {
  static const Color color = Color(0xAA000000);
  static final Paint forePaint = Paint()..color = color;
  static final Size canvasSize = Size(96, 96);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // scale
    final double scaleX = size.width / canvasSize.width;
    final double scaleY = size.height / canvasSize.height;
    canvas.scale(scaleX, scaleY);
    // draw
    canvas.drawPath(
      Path()
        ..moveTo(24, 12)
        ..lineTo(24, 24)
        ..lineTo(36, 12)
        ..close(),
      forePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(72, 12)
        ..lineTo(72, 24)
        ..lineTo(60, 12)
        ..close(),
      forePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WasedaFacePainter extends CustomPainter {
  static const Color color = Color(0xAA000000);
  static final Paint forePaint = Paint()..color = color;
  static final Size canvasSize = Size(96, 96);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // scale
    final double scaleX = size.width / canvasSize.width;
    final double scaleY = size.height / canvasSize.height;
    canvas.scale(scaleX, scaleY);
    // draw
    canvas.drawPath(
      Path()
        ..moveTo(24, 12)
        ..lineTo(12, 24)
        ..lineTo(24, 36)
        ..lineTo(36, 24)
        ..close(),
      forePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(72, 12)
        ..lineTo(84, 24)
        ..lineTo(72, 36)
        ..lineTo(60, 24)
        ..close(),
      forePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class KeioFacePainter extends CustomPainter {
  static const Color color = Color(0xAA000000);
  static final Paint forePaint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  static final Size canvasSize = Size(96, 96);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // scale
    final double scaleX = size.width / canvasSize.width;
    final double scaleY = size.height / canvasSize.height;
    canvas.scale(scaleX, scaleY);
    // draw
    canvas.drawLine(
      Offset(24, 12),
      Offset(36, 24),
      forePaint,
    );
    canvas.drawLine(
      Offset(36, 12),
      Offset(24, 24),
      forePaint,
    );
    canvas.drawLine(
      Offset(60, 12),
      Offset(72, 24),
      forePaint,
    );
    canvas.drawLine(
      Offset(72, 12),
      Offset(60, 24),
      forePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}