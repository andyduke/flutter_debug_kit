import 'package:debug_panel/debug_panel.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:http/http.dart' as http;

class DebugPanelHttpLogMiddleware extends HttpMiddleware {
  final DebugPanelHttpLogController log;

  DebugPanelHttpLogMiddleware({
    required this.log,
  });

  @override
  Future<http.BaseRequest> onRequest(http.BaseRequest request) async {
    log.addRequest(
      DebugPanelHttpRequestInfo(
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
      DebugPanelHttpResponseInfo(
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
