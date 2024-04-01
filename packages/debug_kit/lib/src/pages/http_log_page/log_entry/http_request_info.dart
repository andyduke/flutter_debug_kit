class DebugKitHttpRequestInfo {
  /// HTTP request id.
  final int id;

  /// The HTTP method of the request.
  ///
  /// Most commonly "GET" or "POST", less commonly "HEAD", "PUT", or "DELETE".
  /// Non-standard method names are also supported.
  final String method;

  /// The URL to which the request will be sent.
  final Uri url;

  /// HTTP request headers.
  final Map<String, String> headers;

  DebugKitHttpRequestInfo({
    required this.id,
    required this.method,
    required this.url,
    this.headers = const {},
  });

  @override
  bool operator ==(covariant DebugKitHttpRequestInfo other) => id == other.id;

  @override
  int get hashCode => id;

  @override
  String toString() => '$method $url';
}
