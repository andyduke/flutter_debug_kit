import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/pages/general_page.dart';
import 'package:debug_panel/src/pages/shared_prefs_page.dart';

abstract class DebugPanelBaseSettings {
  const DebugPanelBaseSettings();

  abstract final Set<DebugPanelBasePage> pages;

  abstract final bool buttonVisible;

  /// Keep floating button position between app restarts.
  abstract final bool keepButtonPosition;
}

class DebugPanelSettings extends DebugPanelBaseSettings {
  static final defaultPages = <DebugPanelBasePage>{
    DebugPanelGeneralPage(),
    DebugPanelSharedPrefsPage(),
  };
  static const defaultButtonVisible = true;
  static const defaultKeepButtonPosition = true;

  @override
  Set<DebugPanelBasePage> get pages => _pages ?? defaultPages;
  final Set<DebugPanelBasePage>? _pages;

  @override
  final bool buttonVisible;

  @override
  final bool keepButtonPosition;

  const DebugPanelSettings({
    Set<DebugPanelBasePage>? pages,
    this.buttonVisible = defaultButtonVisible,
    this.keepButtonPosition = defaultKeepButtonPosition,
  }) : _pages = pages;

  @override
  bool operator ==(covariant DebugPanelSettings other) {
    return (buttonVisible == other.buttonVisible) && (keepButtonPosition == other.keepButtonPosition);
  }

  @override
  int get hashCode => Object.hash(buttonVisible, keepButtonPosition);
}
