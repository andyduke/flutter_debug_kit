import 'dart:async';
import 'package:debug_kit/src/theme/theme_data.dart';
import 'package:debug_kit/src/theme/utils/color_set.dart';
import 'package:debug_kit/src/theme/utils/state_property.dart';
import 'package:flutter/material.dart';

enum DebugKitFloatingButtonState {
  hovered,
  pressed,
}

class DebugKitFloatingButton extends StatefulWidget {
  static const double buttonSize = 48.0;

  final VoidCallback onPressed;

  const DebugKitFloatingButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<DebugKitFloatingButton> createState() => _DebugKitFloatingButtonState();
}

class _DebugKitFloatingButtonState extends State<DebugKitFloatingButton> {
  Brightness? brightness;
  ColorScheme colorScheme = DebugKitThemeData.darkScheme;

  _FloatingButtonStateProperty<ColorSet> get colors {
    return _colors ??= _FloatingButtonStateProperty<ColorSet>(
      ColorSet(foreground: colorScheme.primary, background: colorScheme.background),
      hovered: ColorSet(foreground: colorScheme.primary, background: colorScheme.surfaceVariant),
      pressed: ColorSet(foreground: colorScheme.onPrimary, background: colorScheme.primary),
    );
  }

  _FloatingButtonStateProperty<ColorSet>? _colors;

  final Set<DebugKitFloatingButtonState> _states = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final themeBrightness = Theme.of(context).brightness;
    if (themeBrightness != brightness) {
      brightness = themeBrightness;
      colorScheme = (brightness == Brightness.light) ? DebugKitThemeData.darkScheme : DebugKitThemeData.lightScheme;
      _colors = null;
    }
  }

  void _stopPressing() {
    _states.remove(DebugKitFloatingButtonState.pressed);
    if (mounted) {
      setState(() {});
    }
  }

  void _onTap() {
    Future.delayed(const Duration(milliseconds: 300), _stopPressing);

    widget.onPressed.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => setState(() => _states.add(DebugKitFloatingButtonState.pressed)),
      onTap: () => _onTap(),
      onTapCancel: () => _stopPressing(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() => _states.add(DebugKitFloatingButtonState.hovered)),
        onExit: (event) => setState(() => _states.remove(DebugKitFloatingButtonState.hovered)),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: colors.resolve(_states).background,
            shadows: const [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 12,
                color: Color(0x44000000),
              ),
            ],
          ),
          child: SizedBox.square(
            dimension: DebugKitFloatingButton.buttonSize,
            child: Center(
              child: Icon(
                Icons.bug_report,
                color: colors.resolve(_states).foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingButtonStateProperty<T> extends StateProperty<T, DebugKitFloatingButtonState> {
  final T normal;
  final T? hovered;
  final T? pressed;

  _FloatingButtonStateProperty(
    this.normal, {
    required this.hovered,
    required this.pressed,
  });

  @override
  T resolve(Set<DebugKitFloatingButtonState> states) {
    if (states.contains(DebugKitFloatingButtonState.pressed)) {
      return pressed ?? normal;
    }
    if (states.contains(DebugKitFloatingButtonState.hovered)) {
      return hovered ?? normal;
    }
    return normal;
  }

  /*
  static _FloatingButtonStateProperty<T>? lerp<T>(
    _FloatingButtonStateProperty<T>? a,
    _FloatingButtonStateProperty<T>? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
  ) {
    return StateProperty.lerp<_FloatingButtonStateProperty<T>, T, DebugKitFloatingButtonState>(a, b, t, lerpFunction);
  }
  */
}
