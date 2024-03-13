# DebugPanel

- Panels
  - General (App version info, ???)
  - Log (integrate simplytics logger)
  - Http Log (through http_interceptor?)
    - Optional: save requests/responses to disk to see the log after
      the application crashes, clear old records on disk when viewing the log
  - SharedPrefs (view, remove entry, clear)

## HttpClientMiddleware

### Prototype 1

```dart
class HttpClientMiddleware implements http.Client {
  final http.Client http;
  final List<HttpClientInterceptor> interceptors;

  HttpClientMiddleware(
    this.http, {
    this.interceptors = [],
  });

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _handle(
      HttpRequest(
        method: HttpMethod.get,
        url: url,
        headers: headers,
      ),
      () => http.get(url, headers: headers),
    );
  }

  // head
  // delete
  // ...

  @override
  void close() => http.close();

  // ---

  Future<O> _handle<O>(HttpRequest request, Future<O> Function operation) async {
    for (var interceptor in interceptors) {
      interceptor.interceptRequest(request);
    }

    final response = await operation();

    for (var interceptor in interceptors) {
      interceptor.interceptResponse(response);
    }

    return response;
  }
}
```

### Prototype 2

// See https://github.com/syedmurtaza108/chucker-flutter/blob/master/lib/src/http/chucker_http_client.dart

Tip: use `request.hashCode` as network log entry id;

```dart
abstract class HttpMiddleware {

  Future<BaseRequest> onRequest(BaseRequest request);

  Future<BaseResponse> onResponse(BaseResponse response);

}

class HttpMiddlewareClient extends http.Client {
  final http.Client http;
  final List<HttpMiddleware> middleware;

  HttpMiddlewareClient(
    this.http, {
    this.middleware = [],
  });

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (middleware.isEmpty) {
      return send(request);
    } else {
      BaseRequest _request = request;

      for (var handler in middleware) {
        _request = await handler.onRequest(_request);
      }

      BaseResponse response = await http.send(_request);

      for (var handler in middleware) {
        response = await handler.onResponse(response);
      }

      return response;
    }
  }

}
```

### Usage

```dart
final client = HttpClientMiddleware(
  http.Client(),
  interceptors: [
    ...
  ],
);
```


## Arch v2

```dart
// DebugPanelController.of() - if controller not found in context, then return DebugPanelController._default ??= DebugPanelController()

final controller = DebugPanelController();

controller.open();
controller.close();

// Dont: controller.page['http'].log(request, response);

// Set<DebugPanelPage> DebugPanel.pages

return MaterialApp(
  home: const DemoScreen(),
  builder: (context, child) => Providers(
    child: DebugPanel(
      controller: controller,
      /*
      pages: DebugPanelDefaultPages(
        // optional
        log: DebugPanelLogPageOptions(
          logger: simplyticsDebugPanelLogger,
        ),

        // optional
        http: DebugPanelHttpPageOptions(
          middleware: ...,
          maxRequests: 1000,
          storeOnDisk: false,
        ),
      ),
      */
      // or
      pages: {
        DebugPanelLogPage(logger: ...),
        ...DebugPanelPage.defaultPages,
      },
      // or
      pages: {
        DebugPanelGeneralPage(),
        DebugPanelLogPage(logger: ...),
        DebugPanelHttpPage(middleware: ..., maxRequests: 1000, storeOnDisk: false),
        DebugPanelSharedPrefsPage(),
      },
      // or
      pages: {
        DebugPanelGeneralPage(
          // showVersionSection: false,
          sections: [
            DebugPanelPageSection(
              title: 'Server',
              note: 'Choose API server', // optional
              collapsed: false, // optional
              builder: (context) => DropdownMenu(...),
            ),
          ],
        ),
        DebugPanelLogPage(logger: ...),
        DebugPanelHttpPage(middleware: ...),
        DebugPanelSharedPrefsPage(),
      },
      child: child,
    ),
  ),
);

// ---

return DebugPanelDefaultController(
  // controller: controller, // optional
  child: MaterialApp(
    home: const DemoScreen(),
    builder: (context, child) => Providers(
      child: DebugPanel(
        // controller: DebugPanelController.of(context), // <!-- if controller is not passed, use DebugPanelController.of(context)
        child: child,
      ),
    ),
  ),
);
```

# DebugPanel.pages as set

Because pages is a Set, then you can override certain pages among the standard ones.

```dart
abstract class Base {
  abstract final int id;
  
  @override
  bool operator ==(covariant Base other) {
    return (id == other.id);
  }

  @override
  int get hashCode => id.hashCode;
}

class A extends Base {
  @override
  final int id = 1;
}
class B extends Base {
  @override
  final int id = 2;
}
class C extends Base {
  @override
  final int id = 3;
}

void main() {
  final Set classes = {A(), B(), C()};
  
  final Set newClasses = {
    A(),
    ...classes,
  };
  
  print('$newClasses');
}
```


# Design references

- [S8](https://www.setproduct.com/templates/s8)
- [Material-X](https://www.setproduct.com/templates/material-x)
- [S8 dark preview](https://dribbble.com/shots/9836296-Mobile-filters-dark-S8-Figma-UI-kit)
- [Teal light preview](https://dribbble.com/shots/21791516-Mobile-APP-Filters)
