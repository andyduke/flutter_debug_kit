import 'package:flutter/foundation.dart';

class DebugKitHttpResponseInfo {
  final int requestId;

  /// The HTTP status code for this response.
  final int statusCode;

  /// The reason phrase associated with the status code.
  final String? reasonPhrase;

  /// The size of the response body, in bytes.
  ///
  /// If the size of the request is not known in advance, this is `null`.
  final int? contentLength;

  /// The HTTP headers returned by the server.
  final Map<String, String> headers;

  final bool isRedirect;

  /// The bytes comprising the body of this response.
  final Uint8List? bodyBytes;

  /// Date and time when the response was received.
  final DateTime timestamp;

  DebugKitHttpResponseInfo({
    required this.requestId,
    required this.statusCode,
    required this.reasonPhrase,
    required this.contentLength,
    this.headers = const {},
    this.isRedirect = false,
    this.bodyBytes,
  }) : timestamp = DateTime.now();
}
