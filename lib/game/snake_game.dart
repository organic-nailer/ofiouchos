import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:ofiouchos/game/apple.dart';
import 'package:ofiouchos/game/cell.dart';
import 'package:ofiouchos/game/crash_cell.dart';
import 'package:ofiouchos/game/snake_body.dart';
import 'package:ofiouchos/util/direction.dart';
import 'package:ofiouchos/game/external_wall.dart';
import 'package:ofiouchos/game/snake.dart';

abstract class SnakeGameInterface extends FlameGame {
  int get score;

  void requestControl(int snakeIndex, Direction direction);
  void setOnGameOverCallback(VoidCallback callback);
  void setOnUpgradeCallback(VoidCallback callback);
}

class SnakeGame extends FlameGame implements SnakeGameInterface {
  static const double cellSize = 96;
  static const double margin = 8;
  static const double radius = 16;
  static const int rows = 15;
  static const int cols = 15;

  final bool isKeioMode;
  SnakeGame({this.isKeioMode = false});

  VoidCallback? onGameOverCallback;
  VoidCallback? onUpgradeCallback;

  Snake? snakeA;
  Snake? snakeB;
  final List<Apple> apples = [];

  int _score = 0;
  @override
  int get score => _score;

  @override
  void requestControl(int snakeIndex, Direction direction) {
    if (snakeIndex == 0) {
      snakeA?.changeDirection(direction);
    } else if (snakeIndex == 1) {
      snakeB?.changeDirection(direction);
    }
  }

  @override
  void setOnGameOverCallback(VoidCallback callback) {
    onGameOverCallback = callback;
  }

  @override
  void setOnUpgradeCallback(VoidCallback callback) {
    onUpgradeCallback = callback;
  }

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm.mp3', volume: 0.5);
    // 背景セルの生成
    final List<Component> cells = [];
    for (var i = -1; i <= rows; i++) {
      for (var j = -1; j <= cols; j++) {
        if (i == -1 || i == rows || j == -1 || j == cols) {
          cells.add(ExternalWall(
            cellSize: cellSize,
            posX: j,
            posY: i,
            margin: margin,
            radius: radius,
          ));
          continue;
        }
        cells.add(Cell(
          cellSize: cellSize,
          posX: j,
          posY: i,
          margin: margin,
          radius: radius,
        ));
      }
    }
    world.addAll(cells);

    // スネークの生成
    final x = Random().nextInt(cols ~/ 2 - 3) + 3;
    final y = Random().nextInt(rows);
    snakeA = Snake(
      initialDirection: Direction.right,
      initialPosX: x,
      initialPosY: y,
      cellSize: cellSize,
      margin: margin,
      radius: radius,
      length: 3,
      headType: isKeioMode ? HeadType.keio : HeadType.waseda,
    );
    world.add(snakeA!);

    addThrottedTimerEvent(snakeA!.velocity, moveSnakeA);

    final x2 = Random().nextInt(cols ~/ 2 - 3) + cols ~/ 2;
    final int y2;
    if (y < rows ~/ 2) {
      y2 = Random().nextInt(rows ~/ 2) + rows ~/ 2;
    } else {
      y2 = Random().nextInt(rows ~/ 2);
    }
    
    snakeB = Snake(
      initialDirection: Direction.left,
      initialPosX: x2,
      initialPosY: y2,
      cellSize: cellSize,
      margin: margin,
      radius: radius,
      length: 3,
      headType: HeadType.rectangle,
    );
    world.add(snakeB!);

    addThrottedTimerEvent(snakeB!.velocity, moveSnakeB);

    // りんごの生成
    addApple();
    addApple();

    // ジョイスティックの生成
    // final topMenuHeight = 100;
    // final bottomMenuHeight = 200.0;
    // final controller = Controller(
    //   position: Vector2(cols * cellSize / 2, rows * cellSize + topMenuHeight), 
    //   size: Vector2((cols + 2) * cellSize, bottomMenuHeight),
    // );
    // controller.anchor = Anchor.topCenter;
    // world.add(controller);
    // final joystick = JoystickComponent(
    //   knob: CircleComponent(
    //     radius: bottomMenuHeight * 0.2, 
    //     paint: Paint()..color = Colors.white70,
    //   ),
    //   background: CircleComponent(
    //     radius: bottomMenuHeight * 0.4, 
    //     paint: Paint()..color = Colors.white30,
    //   ),
    //   // margin: const EdgeInsets.only(left: 16, bottom: 16),
    // );
    // joystick.position = Vector2(cols * cellSize / 2, rows * cellSize / 2 + topMenuHeight);
    // joystick.anchor = Anchor.topLeft;
    // add(joystick);

    // カメラの設定
    camera.viewfinder.visibleGameSize = Vector2((cols + 2) * cellSize, (rows + 2) * cellSize);
    camera.viewfinder.position = Vector2(cols * cellSize / 2, rows * cellSize / 2);
    camera.viewfinder.anchor = Anchor.center;
  }

  void moveSnakeA(double dt) {
    if (snakeA == null) {
      return;
    }
    double timeDiff;
    if (snakeA!.firstVelocity) {
      snakeA!.firstVelocity = false;
      timeDiff = 0;
    }
    else {
      // timeDiff = dt - snake!.velocity;
      timeDiff = 0;
    }
    snakeA!.move();
    addThrottedTimerEvent(snakeA!.velocity - timeDiff, moveSnakeA);
  }

  void moveSnakeB(double dt) {
    if (snakeB == null) {
      return;
    }
    double timeDiff;
    if (snakeB!.firstVelocity) {
      snakeB!.firstVelocity = false;
      timeDiff = 0;
    }
    else {
      // timeDiff = dt - snake!.velocity;
      timeDiff = 0;
    }
    snakeB!.move();
    addThrottedTimerEvent(snakeB!.velocity - timeDiff, moveSnakeB);
  }

  final List<ThrottedTimerEvent> _throttedTimerEvents = [];

  void addThrottedTimerEvent(double durationSec, void Function(double) callback) {
    _throttedTimerEvents.add(ThrottedTimerEvent(
      durationSec: durationSec,
      startSec: currentTime(),
      callback: callback,
    ));
  }

  @override
  void update(double dt) {
    final currentTimeSec = currentTime();
    final expiredEvents = _throttedTimerEvents.where((e) => e.startSec + e.durationSec < currentTimeSec).toList();
    for (final event in expiredEvents) {
      event.callback(currentTimeSec - event.startSec);
      _throttedTimerEvents.remove(event);
    }
    if (expiredEvents.isNotEmpty) {
      processCollision();
      processUpgrade();
    }
    super.update(dt);
  }

  void processCollision() {
    if (snakeA != null) {
      final head = snakeA!.bodies.first;
      if (head.posX < 0 || head.posX >= cols || head.posY < 0 || head.posY >= rows) {
            onCrash(head.posX, head.posY);
        return;
      }
      for (var i = 1; i < snakeA!.bodies.length; i++) {
        final body = snakeA!.bodies[i];
        if (head.posX == body.posX && head.posY == body.posY) {
            onCrash(head.posX, head.posY);
          return;
        }
      }
      if (snakeB != null) {
        for (var i = 0; i < snakeB!.bodies.length; i++) {
          final body = snakeB!.bodies[i];
          if (head.posX == body.posX && head.posY == body.posY) {
            onCrash(head.posX, head.posY);
            return;
          }
        }
      }
    }
    if (snakeB != null) {
      final head = snakeB!.bodies.first;
      if (head.posX < 0 || head.posX >= cols || head.posY < 0 || head.posY >= rows) {
            onCrash(head.posX, head.posY);
        return;
      }
      for (var i = 1; i < snakeB!.bodies.length; i++) {
        final body = snakeB!.bodies[i];
        if (head.posX == body.posX && head.posY == body.posY) {
            onCrash(head.posX, head.posY);
          return;
        }
      }
      if (snakeA != null) {
        for (var i = 0; i < snakeA!.bodies.length; i++) {
          final body = snakeA!.bodies[i];
          if (head.posX == body.posX && head.posY == body.posY) {
            onCrash(head.posX, head.posY);
            return;
          }
        }
      }
    }
  }

  void onCrash(int posX, int posY) {
    FlameAudio.play('collision.mp3');
    world.add(CrashCell(cellSize: cellSize, posX: posX, posY: posY, margin: margin, radius: radius));
    onGameOver();
  }

  /// スネークがりんごを食べたかどうかの判断
  void processUpgrade() {
    if (apples.isEmpty) {
      return;
    }
    final shouldRemove = <Apple>[];
    for (var apple in apples) {
      if (snakeA != null) {
        if (snakeA!.posX == apple.posX && snakeA!.posY == apple.posY) {
          snakeA!.shouldNextGrow = true;
          snakeA!.velocity = 1 / (snakeA!.bodies.length * 0.3 + 0.5);
          shouldRemove.add(apple);
        }
      }
      if (snakeB != null) {
        if (snakeB!.posX == apple.posX && snakeB!.posY == apple.posY) {
          snakeB!.shouldNextGrow = true;
          snakeB!.velocity = 1 / (snakeB!.bodies.length * 0.3 + 0.5);
          shouldRemove.add(apple);
        }
      }
    }
    for (var apple in shouldRemove) {
      _score += 2;
      onUpgradeCallback?.call();
      FlameAudio.play('upgrade.mp3');
      apples.remove(apple);
      apple.purge();

      addApple();
    }
  }

  void addApple() {
    final random = Random();
    final posX = random.nextInt(cols);
    final posY = random.nextInt(rows);
    if (apples.any((apple) => apple.posX == posX && apple.posY == posY)
    || (snakeA?.bodies[0].posX == posX && snakeA?.bodies[0].posY == posY)
    || (snakeB?.bodies[0].posX == posX && snakeB?.bodies[0].posY == posY)) {
      addApple();
      return;
    }
    final apple = Apple(
      cellSize: cellSize,
      posX: posX,
      posY: posY,
    );
    apples.add(apple);
    world.add(apple);
  }

  void onGameOver() {
    FlameAudio.bgm.stop();
    pauseEngine();
    print('Game Over');
    onGameOverCallback?.call();
  }
}

class ThrottedTimerEvent {
  final double durationSec;
  final double startSec;
  final void Function(double dt) callback;
  const ThrottedTimerEvent({
    required this.durationSec,
    required this.startSec,
    required this.callback,
  });
}
