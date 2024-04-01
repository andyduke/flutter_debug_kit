import 'package:debug_kit/src/pages/http_log_page/log_entry/http_request_info.dart';
import 'package:debug_kit/src/pages/http_log_page/log_entry/http_response_info.dart';
import 'package:flutter/foundation.dart';

class DebugKitHttpLogEntry with ChangeNotifier {
  final DebugKitHttpRequestInfo request;

  DebugKitHttpResponseInfo? get response => _response;
  DebugKitHttpResponseInfo? _response;
  set response(DebugKitHttpResponseInfo? newValue) {
    if (_response != newValue) {
      _response = newValue;
      notifyListeners();
    }
  }

  DebugKitHttpLogEntry({
    required this.request,
    DebugKitHttpResponseInfo? response,
  }) : _response = response;

  @override
  bool operator ==(covariant DebugKitHttpLogEntry other) => request.hashCode == other.request.hashCode;

  @override
  int get hashCode => request.hashCode;

  @override
  String toString() => '''DebugKitHttpLogEntry:
  request: $request
  response: $response
''';
}
