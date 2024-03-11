import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/triggers/glyph/glyph_detector.dart';
import 'package:flutter/material.dart';

class DebugPanelGlyphTrigger extends StatelessWidget {
  static const defaultGlyph = [
    DebugPanelGlyphPart.swipeUp,
    DebugPanelGlyphPart.swipeDown,
    DebugPanelGlyphPart.swipeLeft,
    DebugPanelGlyphPart.swipeRight,
  ];

  final List<DebugPanelGlyphPart> glyph;
  final DebugPanelController controller;
  final Widget child;

  const DebugPanelGlyphTrigger({
    super.key,
    this.glyph = defaultGlyph,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DebugPanelGlyphDetector(
      glyph: glyph,
      onGlyph: () => controller.open(),
      child: child,
    );
  }
}
