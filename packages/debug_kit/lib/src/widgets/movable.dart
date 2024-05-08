import 'package:flutter/material.dart';

typedef MovableCallback = void Function(Offset position);

class Movable extends StatefulWidget {
  // static const defaultLongPressToMove = true;

  final bool enabled;
  final Offset position;

  /// Movable size
  final Size size;

  /// Viewport bounds
  final Rect bounds;

  final Widget child;
  final Widget movable;
  // final bool longPressToMove;
  final VoidCallback? onPressed;
  // final MovableCallback? onMoveStart;
  // final MovableCallback? onMoveUpdate;
  final MovableCallback? onMoveEnd;
  // final VoidCallback? onMoveCancel;

  const Movable({
    super.key,
    this.enabled = true,
    this.position = Offset.zero,
    required this.size,
    required this.bounds,
    required this.child,
    required this.movable,
    // this.longPressToMove = defaultLongPressToMove,
    this.onPressed,
    // this.onMoveStart,
    // this.onMoveUpdate,
    this.onMoveEnd,
    // this.onMoveCancel,
  });

  @override
  State<Movable> createState() => _MovableState();
}

class _MovableState extends State<Movable> {
  late double x = 0;
  late double y = 0;

  double startX = 0;
  double startY = 0;

  bool moved = false;

  @override
  void initState() {
    super.initState();

    _updatePosition(widget.position.dx, widget.position.dy);
  }

  @override
  void didUpdateWidget(covariant Movable oldWidget) {
    super.didUpdateWidget(oldWidget);

    double newX = x;
    double newY = y;

    if (!moved && (widget.position != oldWidget.position)) {
      newX = widget.position.dx;
      newY = widget.position.dy;
    }

    if ((widget.bounds != oldWidget.bounds) || (widget.size != oldWidget.size)) {
      _updatePosition(newX, newY);
    }
  }

  void _updatePosition(double dx, double dy) {
    var width = widget.bounds.width - widget.size.width;
    var height = widget.bounds.height - widget.size.height;

    if (dx.floor() >= 0 && dx <= width) {
      x = dx.floorToDouble();
    }
    if (dx < widget.bounds.left) {
      x = widget.bounds.left;
    }
    if (dx > width) {
      x = width.floorToDouble();
    }

    if (dy.floor() >= 0 && dy <= height) {
      y = dy.floorToDouble();
    }
    if (dy < widget.bounds.top) {
      y = widget.bounds.top;
    }
    if (dy > height) {
      y = height;
    }
  }

  /*
  void _moveStart(double x, double y) {
    setState(() {
      startX = x;
      startY = y;
    });

    widget.onMoveStart?.call(Offset(startX, startY));
  }

  void _moveCancel() {
    widget.onMoveCancel?.call();
  }

  void _moveEnd() {
    widget.onMoveEnd?.call(Offset(x, y));
  }
  */

  void _moveUpdate(double x, double y) {
    var yDelta = y - startY;
    var xDelta = x - startX;

    moved = true;

    _updatePosition(xDelta, yDelta);
    setState(() {});
  }

  void _moveComplete(double x, double y) {
    _moveUpdate(x, y);

    widget.onMoveEnd?.call(Offset(x, y));
  }

  /*
  Widget _buildGestureDetector() {
    late Widget gestureDetector;

    if (widget.longPressToMove) {
      gestureDetector = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onPressed,
        onLongPressStart: (details) => _moveStart(details.localPosition.dx, details.localPosition.dy),
        onLongPressCancel: _moveCancel,
        onLongPressEnd: (details) => _moveEnd(),
        onLongPressMoveUpdate: (details) => _moveUpdate(details.globalPosition.dx, details.globalPosition.dy),
        child: widget.movable,
      );
    } else {
      gestureDetector = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: widget.onPressed,
        onPanStart: (details) => _moveStart(details.localPosition.dx, details.localPosition.dy),
        onPanCancel: _moveCancel,
        onPanEnd: (details) => _moveEnd(),
        onPanUpdate: (details) => _moveUpdate(details.globalPosition.dx, details.globalPosition.dy),
        child: widget.movable,
      );
    }

    return gestureDetector;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Movable
        Positioned(
          left: x,
          top: y,
          child: widget.enabled ? _buildGestureDetector() : widget.movable,
        ),
      ],
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Button
        Overlay.wrap(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: x,
                top: y,
                child: widget.enabled
                    ? Draggable(
                        onDragEnd: (details) => _moveComplete(details.offset.dx, details.offset.dy),
                        feedback: widget.movable,
                        childWhenDragging: const SizedBox.shrink(),
                        child: widget.movable,
                      )
                    : widget.movable,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
