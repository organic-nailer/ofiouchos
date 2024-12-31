import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ofiouchos/util/direction.dart';
import 'package:ofiouchos/game/snake_body.dart';

class Snake extends Component {
  final double margin;
  final double radius;
  final double cellSize;
  final HeadType headType;
  final Color color;
  Direction lastMovedDirection;
  Direction currentDirection;

  /// 1マスの移動速度(マス/秒)
  double velocity = 1;
  bool firstVelocity = true;
  List<SnakeBody> bodies = [];
  bool shouldNextGrow = false;

  Snake({
    required Direction initialDirection,
    required int initialPosX,
    required int initialPosY,
    required int length,
    required this.cellSize,
    required this.headType,
    this.margin = 0,
    this.radius = 0,
    this.color = Colors.white,
  }): lastMovedDirection = initialDirection,
      currentDirection = initialDirection {
    generateBodies(length, initialDirection, initialPosX, initialPosY, color);
  }

  int get posX => bodies.first.posX;
  int get posY => bodies.first.posY;

  void generateBodies(int length, Direction direction, int posX, int posY, Color color) {
    final int dx;
    final int dy;
    switch (direction) {
      case Direction.up:
        dx = 0;
        dy = 1;
        break;
      case Direction.right:
        dx = -1;
        dy = 0;
        break;
      case Direction.down:
        dx = 0;
        dy = -1;
        break;
      case Direction.left:
        dx = 1;
        dy = 0;
        break;
      case Direction.none:
        dx = 0;
        dy = 0;
        break;
    }

    for (var i = 0; i < length; i++) {
      bodies.add(SnakeBody(
        direction: direction,
        posX: posX + dx * i,
        posY: posY + dy * i,
        cellSize: cellSize,
        margin: margin,
        radius: radius,
        color: color,
      ));
    }
    bodies.first.headType = HeadType.rectangle;
    addAll(bodies);
  }

  void move() {
    int newPosX = posX;
    int newPosY = posY;
    switch (currentDirection) {
      case Direction.up:
        newPosY--;
        break;
      case Direction.right:
        newPosX++;
        break;
      case Direction.down:
        newPosY++;
        break;
      case Direction.left:
        newPosX--;
        break;
      case Direction.none:
        break;
    }
    // print("move from ($posX, $posY) to ($newPosX, $newPosY)");
    _moveTo(newPosX, newPosY);
  }

  void _moveTo(int x, int y) {
    final head = bodies.first;
    head.headType = null;
    final newHead = SnakeBody(
      direction: currentDirection,
      posX: x,
      posY: y,
      cellSize: cellSize,
      margin: margin,
      radius: radius,
      headType: headType,
      color: color,
    );
    add(newHead);
    bodies.insert(0, newHead);
    if (shouldNextGrow) {
      shouldNextGrow = false;
    } else {
      final tail = bodies.removeLast();
      tail.purge();
    }

    lastMovedDirection = currentDirection;
  }

  void changeDirection(Direction newDirection) {
    if (lastMovedDirection == Direction.none) {
      currentDirection = newDirection;
    } else if (lastMovedDirection == Direction.up && newDirection != Direction.down ||
               lastMovedDirection == Direction.right && newDirection != Direction.left ||
               lastMovedDirection == Direction.down && newDirection != Direction.up ||
               lastMovedDirection == Direction.left && newDirection != Direction.right) {
      currentDirection = newDirection;
    }
  }
}
