import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/pages/http_log_page/http_log_controller.dart';
import 'package:debug_kit/src/pages/http_log_page/log_entry/http_log_entry.dart';
import 'package:debug_kit/src/utils/string_ext.dart';
import 'package:debug_kit/src/widgets/log_view_scaffold/log_view_scaffold.dart';
import 'package:flutter/material.dart';

part '_http_log_viewer.dart';

class DebugKitPanelHttpPage extends DebugKitPanelBasePage {
  @override
  final String name = 'http';

  @override
  late final String title = _customTitle ?? 'Network';
  final String? _customTitle;

  @override
  late final IconData? icon = _customIcon ?? Icons.network_check;
  final IconData? _customIcon;

  final DebugKitHttpLogController httpLogController;

  DebugKitPanelHttpPage({
    String? title,
    IconData? icon,
    required this.httpLogController,
  })  : _customTitle = title,
        _customIcon = icon;

  @override
  Widget build(BuildContext context, DebugKitController controller) {
    return _HttpLogViewer(controller: httpLogController);
  }
}
