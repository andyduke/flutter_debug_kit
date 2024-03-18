import 'package:flutter/material.dart';

enum DebugPanelGlyphPart {
  swipeUp,
  swipeDown,
  swipeLeft,
  swipeRight,
  tap,
  longPress,
}

class DebugPanelGlyphDetector extends StatefulWidget {
  static const defaultGlyphTimeout = Duration(seconds: 2);

  final List<DebugPanelGlyphPart> glyph;
  final Duration glyphTimeout;
  final Widget child;
  final VoidCallback onGlyph;

  const DebugPanelGlyphDetector({
    super.key,
    required this.glyph,
    this.glyphTimeout = defaultGlyphTimeout,
    required this.child,
    required this.onGlyph,
  });

  @override
  State<DebugPanelGlyphDetector> createState() => _DebugPanelGlyphDetectorState();
}

class _DebugPanelGlyphDetectorState extends State<DebugPanelGlyphDetector> {
  ///
  /// The last date where a gesture have been detected on the given child
  ///
  DateTime? lastCodeDate;

  ///
  /// The maximum delay between two gestures
  ///
  late final Duration _lastCodeExpiration = widget.glyphTimeout;

  ///
  /// The getter to find out if the last gesture is older than the maximum delay
  ///
  bool get isLastCodeExpired =>
      lastCodeDate == null || DateTime.now().difference(lastCodeDate!).compareTo(_lastCodeExpiration) > 0;

  ///
  /// Last vertical gesture detected
  ///
  DebugPanelGlyphPart? _lastVerticalDrag;

  ///
  /// Last vertical gesture starting ordinate
  ///
  late double _lastVerticalDragStart;

  ///
  /// Last horizontal gesture detected
  ///
  DebugPanelGlyphPart? _lastHorizontalDrag;

  ///
  /// Last horizontal gesture starting abscissas
  ///
  late double _lastHorizontalDragStart;

  ///
  /// Current list of non expired gestures
  ///
  List<DebugPanelGlyphPart?> _currentCodes = [];

  ///
  /// Called when a vertical gesture is starting
  ///
  void onVerticalDragStart(DragStartDetails details) {
    _lastVerticalDragStart = details.globalPosition.dy;
  }

  ///
  /// Called when a vertical gesture is in progress
  ///
  void onVerticalDragUpdate(DragUpdateDetails details) {
    _lastVerticalDrag = details.globalPosition.dy > _lastVerticalDragStart
        ? DebugPanelGlyphPart.swipeDown
        : DebugPanelGlyphPart.swipeUp;
  }

  ///
  /// Called when a vertical gesture is stopped
  ///
  void onVerticalDragEnd(DragEndDetails details) => onGesture(_lastVerticalDrag);

  ///
  /// Called when a horizontal gesture is starting
  ///
  void onHorizontalDragStart(DragStartDetails details) {
    _lastHorizontalDragStart = details.globalPosition.dx;
  }

  ///
  /// Called when a horizontal gesture is in progress
  ///
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    _lastHorizontalDrag = details.globalPosition.dx > _lastHorizontalDragStart
        ? DebugPanelGlyphPart.swipeRight
        : DebugPanelGlyphPart.swipeLeft;
  }

  ///
  /// Called when a horizontal gesture is stopped
  ///
  void onHorizontalDragEnd(DragEndDetails details) => onGesture(_lastHorizontalDrag);

  ///
  /// Called when a gesture is detected
  ///
  void onGesture(DebugPanelGlyphPart? code) {
    if (isLastCodeExpired) _currentCodes = [];
    lastCodeDate = DateTime.now();

    _currentCodes.add(code);
    if (_currentCodes.length >= widget.glyph.length) {
      int i = 0;
      bool isGlyph = true;
      List<DebugPanelGlyphPart?> lastCodes =
          [..._currentCodes].getRange(_currentCodes.length - widget.glyph.length, _currentCodes.length).toList();

      for (var code in lastCodes) {
        isGlyph = isGlyph && code == widget.glyph[i];
        i++;
      }

      if (isGlyph) {
        _glyphDetected();
      }
    }
  }

  void _glyphDetected() {
    widget.onGlyph.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onTap: () => onGesture(DebugPanelGlyphPart.tap),
      onLongPress: () => onGesture(DebugPanelGlyphPart.longPress),
      child: widget.child,
    );
  }
}
