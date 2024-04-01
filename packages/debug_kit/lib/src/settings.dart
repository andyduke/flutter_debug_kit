import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/pages/general_page.dart';
import 'package:debug_kit/src/pages/shared_prefs_page/shared_prefs_page.dart';
import 'package:debug_kit/src/triggers/floating_button/floating_button_trigger.dart';
import 'package:debug_kit/src/triggers/glyph/glyph_trigger.dart';
import 'package:debug_kit/src/triggers/shortcut_trigger.dart';
import 'package:debug_kit/src/triggers/trigger.dart';
import 'package:flutter/foundation.dart';

abstract class DebugKitBaseSettings {
  const DebugKitBaseSettings();

  abstract final Set<DebugKitTrigger> triggers;

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

  static final defaultTriggers = <DebugKitTrigger>{
    DebugKitFloatingButtonTrigger.setup(),
    DebugKitShortcutTrigger.setup(),
    DebugKitGlyphTrigger.setup(),
  };

  static const defaultButtonVisible = true;
  static const defaultKeepButtonPosition = true;

  @override
  Set<DebugKitTrigger> get triggers => _triggers ?? defaultTriggers;
  final Set<DebugKitTrigger>? _triggers;

  @override
  Set<DebugKitPanelBasePage> get pages => _pages ?? defaultPages;
  final Set<DebugKitPanelBasePage>? _pages;

  // TODO: Add Set<DebugKitInspector> inspectors

  @override
  final bool buttonVisible;

  @override
  final bool keepButtonPosition;

  const DebugKitSettings({
    Set<DebugKitTrigger>? triggers,
    Set<DebugKitPanelBasePage>? pages,
    this.buttonVisible = defaultButtonVisible,
    this.keepButtonPosition = defaultKeepButtonPosition,
  })  : _triggers = triggers,
        _pages = pages;

  @override
  bool operator ==(covariant DebugKitSettings other) {
    return (buttonVisible == other.buttonVisible) &&
        (keepButtonPosition == other.keepButtonPosition) &&
        setEquals(triggers, other.triggers) &&
        setEquals(pages, other.pages);
  }

  @override
  int get hashCode => Object.hash(buttonVisible, keepButtonPosition, triggers, pages);
}
