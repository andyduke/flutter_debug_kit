import 'package:collection/collection.dart';
import 'package:debug_panel/src/pages/http_log_page/log_entry/http_log_entry.dart';
import 'package:debug_panel/src/pages/http_log_page/log_entry/http_request_info.dart';
import 'package:debug_panel/src/pages/http_log_page/log_entry/http_response_info.dart';
import 'package:flutter/foundation.dart';

class DebugPanelHttpLogController with ChangeNotifier {
  static const defaultMaxLength = 200;

  final Set<DebugPanelHttpLogEntry> _log = {};
  final int maxLength;

  DebugPanelHttpLogController({
    this.maxLength = defaultMaxLength,
  });

  Set<DebugPanelHttpLogEntry> get log => UnmodifiableSetView(_log);

  void addRequest(DebugPanelHttpRequestInfo request) {
    _log.add(DebugPanelHttpLogEntry(request: request));
    _trimLimit();
    notifyListeners();
  }

  void addResponse(DebugPanelHttpResponseInfo response) {
    final request = _log.firstWhereOrNull((info) => info.request.id == response.requestId);
    if (request != null) {
      request.response = response;
      notifyListeners();
    } else {
      throw Exception('[DebugPanelHttpLogController] Request "${response.requestId}" for response not found.');
    }
  }

  void clear() {
    _log.clear();
    notifyListeners();
  }

  void _trimLimit() {
    if ((maxLength > 0) && (_log.length > maxLength)) {
      _log.remove(_log.skip(_log.length - maxLength));
    }
  }
}
