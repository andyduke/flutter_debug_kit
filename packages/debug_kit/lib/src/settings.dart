import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/pages/general_page.dart';
import 'package:debug_kit/src/pages/shared_prefs_page/shared_prefs_page.dart';

abstract class DebugKitBaseSettings {
  const DebugKitBaseSettings();

  abstract final Set<DebugKitPanelBasePage> pages;

  abstract final bool buttonVisible;

  /// Keep floating button position between app restarts.
  abstract final bool keepButtonPosition;
}

class DebugKitSettings extends DebugKitBaseSettings {
  static final defaultPages = <DebugKitPanelBasePage>{
    DebugKitPanelGeneralPage(),
    DebugKitPanelSharedPrefsPage(),
  };
  static const defaultButtonVisible = true;
  static const defaultKeepButtonPosition = true;

  @override
  Set<DebugKitPanelBasePage> get pages => _pages ?? defaultPages;
  final Set<DebugKitPanelBasePage>? _pages;

  @override
  final bool buttonVisible;

  @override
  final bool keepButtonPosition;

  const DebugKitSettings({
    Set<DebugKitPanelBasePage>? pages,
    this.buttonVisible = defaultButtonVisible,
    this.keepButtonPosition = defaultKeepButtonPosition,
  }) : _pages = pages;

  @override
  bool operator ==(covariant DebugKitSettings other) {
    return (buttonVisible == other.buttonVisible) && (keepButtonPosition == other.keepButtonPosition);
  }

  @override
  int get hashCode => Object.hash(buttonVisible, keepButtonPosition);
}
