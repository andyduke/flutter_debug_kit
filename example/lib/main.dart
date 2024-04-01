import 'package:debug_kit/debug_kit.dart';
import 'package:debug_kit_example/app_debug_kit.dart';
import 'package:debug_kit_http/debug_kit_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

final themeMode = ValueNotifier(ThemeMode.light);

class MainApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, mode, child) {
        final app = MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'DebugKit Demo App',
          home: const DemoScreen(),
          themeMode: mode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          builder: (context, child) {
            return ExampleAppDebugKit(
              child: Providers(
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );

        return AnnotatedRegion(
          value: (mode == ThemeMode.light)
              ? const SystemUiOverlayStyle(
                  statusBarColor: Color(0xFFFFFFFF),
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                  systemNavigationBarColor: Color(0xFFFFFFFF),
                  systemNavigationBarIconBrightness: Brightness.dark,
                )
              : const SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF000000),
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                  systemNavigationBarColor: Color(0xFF000000),
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
          child: app,
        );
      });
}

class ApiServer with ChangeNotifier {
  int get selectedIndex => _selectedIndex;
  int _selectedIndex = 1;
  set selectedIndex(int newValue) {
    if (newValue != _selectedIndex) {
      _selectedIndex = newValue;
      notifyListeners();
    }
  }
}

class AuthState with ChangeNotifier {
  bool get isLogged => _isLogged;
  bool _isLogged = true;

  void logout() {
    _isLogged = false;
    notifyListeners();
  }
}

class ApiClient {
  final DebugKitHttpLogController? logController;
  late final http.Client client;

  ApiClient({
    required this.logController,
  }) {
    client = HttpMiddlewareClient(
      http.Client(),
      middleware: [
        if (logController != null) DebugKitHttpLogMiddleware(log: logController!),
      ],
    );
  }

  Future<http.BaseResponse> send(
    Uri url, {
    String method = 'get',
    Map<String, String> headers = const {},
    String? body,
  }) async {
    final request = http.Request(method, url);
    if (body != null) {
      request.body = body;
    }

    final response = await client.send(request);
    return response;
  }
}

class Providers extends StatelessWidget {
  final Widget child;

  const Providers({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final log = ExampleAppDebugKit.maybeOf(context)?.httpLog;
    // print('[Providers] log: $log');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApiServer>(
          create: (_) => ApiServer(),
        ),
        ChangeNotifierProvider<AuthState>(
          create: (_) => AuthState(),
        ),
        Provider<ApiClient>(
          create: (context) => ApiClient(logController: log),
        ),
      ],
      child: child,
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ApiServer>(
              builder: (context, value, child) {
                return Text('API Server: ${value.selectedIndex}');
              },
            ),

            //
            const SizedBox(height: 24),
            Consumer<AuthState>(
              builder: (context, value, child) {
                return Text('Is logged: ${value.isLogged}');
              },
            ),

            //
            const SizedBox(height: 24),

            const ThemeModeSwitch(),

            //
            const SizedBox(height: 24),

            //
            ElevatedButton(
              onPressed: () {
                DebugKitController.maybeOf(context)?.open();
              },
              child: const Text('Open Debug Panel'),
            ),

            //
            const SizedBox(height: 24),

            //
            ElevatedButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'DebugKit Demo App',
                  applicationVersion: '0.1',
                  applicationLegalese: '(C) Andy Chentsov',
                );
              },
              child: const Text('Show Dialog'),
            ),

            //
            const SizedBox(height: 24),

            //
            const HttpRequestView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'ABC'),
        ],
      ),
    );
  }
}

class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, mode, child) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Dark'),
                const SizedBox(width: 8),
                Switch(
                  value: mode == ThemeMode.light,
                  onChanged: (value) {
                    setState(() {
                      themeMode.value = value ? ThemeMode.light : ThemeMode.dark;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text('Light'),
              ],
            );
          },
        );
      },
    );
  }
}

class HttpRequestView extends StatefulWidget {
  const HttpRequestView({super.key});

  @override
  State<HttpRequestView> createState() => _HttpRequestViewState();
}

class _HttpRequestViewState extends State<HttpRequestView> {
  bool _running = false;
  http.BaseResponse? _response;

  Future<void> _send() async {
    setState(() {
      _running = true;
      _response = null;
    });

    final api = context.read<ApiClient>();
    _response = await api.send(Uri.parse('https://httpbin.org/get'));
    setState(() {
      _running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        !_running
            ? ElevatedButton(
                onPressed: () => _send(),
                child: const Text('Send request'),
              )
            : const SizedBox.square(dimension: 32, child: CircularProgressIndicator()),
        if (!_running && _response != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Response: ${_response!.statusCode}'),
            ),
          ),
      ],
    );
  }
}
