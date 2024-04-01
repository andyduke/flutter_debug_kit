import 'package:debug_kit/debug_kit.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:http/http.dart' as http;

class DebugKitHttpLogMiddleware extends HttpMiddleware {
  final DebugKitHttpLogController log;

  DebugKitHttpLogMiddleware({
    required this.log,
  });

  @override
  Future<http.BaseRequest> onRequest(http.BaseRequest request) async {
    log.addRequest(
      DebugKitHttpRequestInfo(
        id: request.hashCode,
        method: request.method,
        url: request.url,
        headers: request.headers,
      ),
    );
    return request;
  }

  @override
  Future<http.StreamedResponse> onResponse(http.StreamedResponse response) async {
    log.addResponse(
      DebugKitHttpResponseInfo(
        requestId: response.request.hashCode,
        statusCode: response.statusCode,
        reasonPhrase: response.reasonPhrase,
        contentLength: response.contentLength,
        headers: response.headers,
        isRedirect: response.isRedirect,
        bodyBytes: await response.stream.toBytes(),
      ),
    );
    return response;
  }
}
