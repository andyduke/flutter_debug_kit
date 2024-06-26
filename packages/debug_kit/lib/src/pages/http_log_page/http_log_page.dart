import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/pages/http_log_page/http_log_controller.dart';
import 'package:debug_kit/src/pages/http_log_page/log_entry/http_log_entry.dart';
import 'package:debug_kit/src/utils/datetime_ext.dart';
import 'package:debug_kit/src/utils/duration_ext.dart';
import 'package:debug_kit/src/utils/string_ext.dart';
import 'package:debug_kit/src/widgets/filtered_list_scaffold/filtered_list_scaffold.dart';
import 'package:debug_kit/src/widgets/list_tile.dart';
import 'package:flutter/material.dart';

part '_http_log_viewer.dart';

class DebugKitPanelHttpPage extends DebugKitPanelBasePage {
  static const String defaultName = 'http';

  @override
  final String name = defaultName;

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
