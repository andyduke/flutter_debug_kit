import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/triggers/glyph/glyph_detector.dart';
import 'package:debug_kit/src/triggers/trigger.dart';
import 'package:flutter/material.dart';

class DebugKitGlyphTrigger extends StatelessWidget {
  static const name = 'debug_kit_glyph';

  static DebugKitTrigger setup({List<DebugKitGlyphPart> glyph = defaultGlyph}) {
    return DebugKitTrigger(
      name: name,
      builder: (context, controller, child) => DebugKitGlyphTrigger(
        glyph: glyph,
        controller: controller,
        child: child,
      ),
    );
  }

  static const defaultGlyph = [
    DebugKitGlyphPart.swipeUp,
    DebugKitGlyphPart.swipeDown,
    DebugKitGlyphPart.swipeLeft,
    DebugKitGlyphPart.swipeRight,
  ];

  final List<DebugKitGlyphPart> glyph;
  final DebugKitController controller;
  final Widget child;

  const DebugKitGlyphTrigger({
    super.key,
    this.glyph = defaultGlyph,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DebugKitGlyphDetector(
      glyph: glyph,
      onGlyph: () => controller.open(),
      child: child,
    );
  }
}
