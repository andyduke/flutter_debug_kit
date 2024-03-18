import 'package:debug_panel/src/pages/http_log_page/log_entry/http_request_info.dart';
import 'package:debug_panel/src/pages/http_log_page/log_entry/http_response_info.dart';
import 'package:flutter/foundation.dart';

class DebugPanelHttpLogEntry with ChangeNotifier {
  final DebugPanelHttpRequestInfo request;

  DebugPanelHttpResponseInfo? get response => _response;
  DebugPanelHttpResponseInfo? _response;
  set response(DebugPanelHttpResponseInfo? newValue) {
    if (_response != newValue) {
      _response = newValue;
      notifyListeners();
    }
  }

  DebugPanelHttpLogEntry({
    required this.request,
    DebugPanelHttpResponseInfo? response,
  }) : _response = response;

  @override
  bool operator ==(covariant DebugPanelHttpLogEntry other) => request.hashCode == other.request.hashCode;

  @override
  int get hashCode => request.hashCode;

  @override
  String toString() => '''DebugPanelHttpLogEntry:
  request: $request
  response: $response
''';
}
