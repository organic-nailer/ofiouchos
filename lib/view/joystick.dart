import 'package:flutter/material.dart';
import 'package:ofiouchos/util/direction.dart';

class Joystick extends StatefulWidget {
  final void Function(Direction) onControl;
  final double size;
  final double knobSize;
  final Widget? background;
  final Widget? knob;
  const Joystick({super.key, required this.onControl, this.size = 200, this.knobSize = 100, this.background, this.knob});

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset _knobOffset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _knobOffset = details.localPosition - Offset(widget.size / 2, widget.size / 2);
                  _knobOffset = Offset(
                    _knobOffset.dx.clamp(-widget.size / 2, widget.size / 2),
                    _knobOffset.dy.clamp(-widget.size / 2, widget.size / 2),
                  );
                });
                // Direction direction;
                // if (_knobOffset.distance < widget.size / 8) {
                //   direction = Direction.none;
                // } else {
                //   final radian = (_knobOffset - Offset.zero).direction;
                //   if (radian >= -3 * 3.14 / 4 && radian < -3.14 / 4) {
                //     direction = Direction.up;
                //   } else if (radian >= -3.14 / 4 && radian < 3.14 / 4) {
                //     direction = Direction.right;
                //   } else if (radian >= 3.14 / 4 && radian < 3 * 3.14 / 4) {
                //     direction = Direction.down;
                //   } else {
                //     direction = Direction.left;
                //   }
                // }
                // widget.onControl(direction);
              },
              onPanUpdate: (details) {
                setState(() {
                  _knobOffset = details.localPosition - Offset(widget.size / 2, widget.size / 2);
                  _knobOffset = Offset(
                    _knobOffset.dx.clamp(-widget.size / 2, widget.size / 2),
                    _knobOffset.dy.clamp(-widget.size / 2, widget.size / 2),
                  );
                });
                // Direction direction;
                // if (_knobOffset.distance < widget.size / 8) {
                //   direction = Direction.none;
                // } else {
                //   final radian = (_knobOffset - Offset.zero).direction;
                //   if (radian >= -3 * 3.14 / 4 && radian < -3.14 / 4) {
                //     direction = Direction.up;
                //   } else if (radian >= -3.14 / 4 && radian < 3.14 / 4) {
                //     direction = Direction.right;
                //   } else if (radian >= 3.14 / 4 && radian < 3 * 3.14 / 4) {
                //     direction = Direction.down;
                //   } else {
                //     direction = Direction.left;
                //   }
                // }
                // widget.onControl(direction);
              },
              onPanEnd: (details) {
                Direction direction;
                if (_knobOffset.distance < widget.size / 8) {
                  direction = Direction.none;
                } else {
                  final radian = (_knobOffset - Offset.zero).direction;
                  if (radian >= -3 * 3.14 / 4 && radian < -3.14 / 4) {
                    direction = Direction.up;
                  } else if (radian >= -3.14 / 4 && radian < 3.14 / 4) {
                    direction = Direction.right;
                  } else if (radian >= 3.14 / 4 && radian < 3 * 3.14 / 4) {
                    direction = Direction.down;
                  } else {
                    direction = Direction.left;
                  }
                }
                widget.onControl(direction);
                setState(() {
                  _knobOffset = Offset.zero;
                });
              },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: widget.background ?? Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: _knobOffset.dx + widget.size / 2 - widget.knobSize / 2,
              top: _knobOffset.dy + widget.size / 2 - widget.knobSize / 2,
              child: SizedBox(
                  width: widget.knobSize,
                  height: widget.knobSize,
                child: widget.knob ?? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}