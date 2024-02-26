import 'package:flutter/widgets.dart';

abstract class DebugPanelBaseSettings {
  const DebugPanelBaseSettings();

  abstract final bool buttonVisible;

  /// Keep floating button position between app restarts.
  abstract final bool keepButtonPosition;

  // TODO: DEBUG
  abstract final WidgetBuilder buildOverlay;
}

class DebugPanelSettings extends DebugPanelBaseSettings {
  static const defaultButtonVisible = true;
  static const defaultKeepButtonPosition = true;

  @override
  final bool buttonVisible;

  @override
  final bool keepButtonPosition;

  // TODO: DEBUG
  @override
  final WidgetBuilder buildOverlay;

  const DebugPanelSettings({
    this.buttonVisible = defaultButtonVisible,
    this.keepButtonPosition = defaultKeepButtonPosition,

    // TODO: DEBUG
    this.buildOverlay = _defaultBuildOverlay,
  });

  static Widget _defaultBuildOverlay(BuildContext context) => const Text('DebugPanel Overlay');

  @override
  bool operator ==(covariant DebugPanelSettings other) {
    return (buttonVisible == other.buttonVisible) && (keepButtonPosition == other.keepButtonPosition);
  }

  @override
  int get hashCode => Object.hash(buttonVisible, keepButtonPosition);
}
