import 'dart:math';

enum Direction {
  up,
  down,
  left,
  right,
  none,
  ;

  double get angle {
    switch (this) {
      case Direction.up:
        return 0;
      case Direction.right:
        return 90 * pi / 180;
      case Direction.down:
        return 180 * pi / 180;
      case Direction.left:
        return 270 * pi / 180;
      case Direction.none:
        return 0;
    }
  }
}
