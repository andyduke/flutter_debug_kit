import 'package:debug_panel/src/pages/base_page.dart';

abstract class DebugPanelBaseSettings {
  const DebugPanelBaseSettings();

  abstract final Set<DebugPanelBasePage> pages;

  abstract final bool buttonVisible;

  /// Keep floating button position between app restarts.
  abstract final bool keepButtonPosition;
}

class DebugPanelSettings extends DebugPanelBaseSettings {
  static const defaultPages = <DebugPanelBasePage>{};
  static const defaultButtonVisible = true;
  static const defaultKeepButtonPosition = true;

  @override
  final Set<DebugPanelBasePage> pages;

  @override
  final bool buttonVisible;

  @override
  final bool keepButtonPosition;

  const DebugPanelSettings({
    this.pages = defaultPages,
    this.buttonVisible = defaultButtonVisible,
    this.keepButtonPosition = defaultKeepButtonPosition,
  });

  @override
  bool operator ==(covariant DebugPanelSettings other) {
    return (buttonVisible == other.buttonVisible) && (keepButtonPosition == other.keepButtonPosition);
  }

  @override
  int get hashCode => Object.hash(buttonVisible, keepButtonPosition);
}
