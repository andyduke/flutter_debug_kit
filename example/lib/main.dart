import 'package:debug_panel/debug_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

final themeMode = ValueNotifier(ThemeMode.light);

class MainApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeMode,
        builder: (context, mode, child) {
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
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              home: const DemoScreen(),
              themeMode: mode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              builder: (context, child) {
                return AppDebugPanelScope(
                  child: Providers(
                    child: AppDebugPanel(
                      child: child,
                    ),
                  ),
                );

                /*
              return DebugPanel(
                settings: DebugPanelSettings(
                  buttonVisible: kDebugMode,
                  // pages: [
                  //   DebugPanelAppPage(),
                  //   ...DebugPanelSettings.defaultPages,
                  // ],
                  buildOverlay: (context) {
                    return TextButton(
                      onPressed: () {
                        context.read<AuthState>().logout();
                      },
                      child: const Text('Logout'),
                    );
                  },
                ),
                // builder: (context, child) => Providers(child: child),
                // child: child,
                    
                builder: (context, debugBuilder) => Providers(child: debugBuilder(child)),
                // builder: (context, debugBuilder) => Providers(child: child ?? const SizedBox.shrink()),
              );
              */

                /*
              return Providers(
                child: DebugPanelPageBuilder(
                  id: 'app-page',
                  title: 'App Page',
                  builder: (context) => TextButton(
                    onPressed: () => context.read<AuthState>().logout(),
                    child: const Text('Custom 1'),
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
              */
              },
            ),
          );
        });

    /*
    final app = MaterialApp(
      home: const DemoScreen(),
      builder: (context, child) {
        return Providers(
          child: DebugPanelPageBuilder(
            id: 'app-page',
            title: 'App Page',
            builder: (context) => TextButton(
              onPressed: () => context.read<AuthState>().logout(),
              child: const Text('Custom 1'),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );

    if (kDebugMode) {
      return DebugPanel(
        settings: const DebugPanelSettings(
          buttonVisible: kDebugMode,
          // pages: [
          //   DebugPanelAppPage(),
          //   ...DebugPanelSettings.defaultPages,
          // ],
        ),
        child: app,
      );
    } else {
      return app;
    }
    */
  }
}

class HttpLogMiddleware {}

class AppDebugPanelScope extends StatelessWidget {
  final Widget? child;

  const AppDebugPanelScope({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HttpLogMiddleware>(
          create: (context) => HttpLogMiddleware(),
        ),
      ],
      child: child,
    );
  }
}

class AppDebugPanel extends StatelessWidget {
  final Widget? child;

  const AppDebugPanel({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DebugPanel(
      // navigatorKey: MainApp.navigatorKey,
      settings: DebugPanelSettings(
        // buttonVisible: kDebugMode,
        buttonVisible: true,
        pages: {
          DebugPanelGeneralPage(
            sections: [
              DebugPanelGeneralPageSection(
                title: 'Server',
                note: 'Choose API server', // optional
                collapsed: false, // optional
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Server dropdown'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthState>().logout();
                        },
                        child: const Text('Switch'),
                      ),

                      //
                      const SizedBox(height: 24),

                      //
                      const ThemeModeSwitch(text: 'Main App Light Mode?'),
                    ],
                  );
                },
              ),
            ],
          ),

          DebugPanelCustomPage(
            name: 'log',
            title: 'Log',
            icon: Icons.history,
            builder: (context) => const Text('Log'),
          ),

          DebugPanelCustomPage(
            name: 'network',
            title: 'Network',
            icon: Icons.network_check,
            builder: (context) => const Text('Network'),
          ),

          DebugPanelCustomPage(
            name: 'sharedPrefs',
            title: 'Shared Preferences',
            icon: Icons.history,
            builder: (context) => const Text('Shared Prefs Inspector'),
          ),

          DebugPanelPage(
            name: 'sectionsTest',
            title: 'Sections Test',
            sections: {
              DebugPanelPageSection(
                collapsed: false,
                name: 'section1',
                title: 'Section 1',
                note:
                    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed dapibus, ante ultricies adipiscing pulvinar.',
                builder: (context) => const Text('Section 1'),
              ),
              DebugPanelPageSection(
                name: 'section2',
                title: 'Section 2',
                builder: (context) => const Text('Section 2'),
              ),
              DebugPanelPageSection(
                name: 'section3',
                title: 'Section 3',
                builder: (context) => Container(color: Colors.blue.shade800, height: 1000),
              ),
            },
          ),

          DebugPanelCustomPage(
            name: 'test',
            title: 'Test Page 1',
            builder: (context) => const Text('Test'),
          ),

          DebugPanelCustomPage(
            name: 'test2',
            title: 'Test Page 2',
            builder: (context) => const Text('Test'),
          ),
          DebugPanelCustomPage(
            name: 'test3',
            title: 'Test Page 3',
            builder: (context) => const Text('Test'),
          ),
          DebugPanelCustomPage(
            name: 'test4',
            title: 'Test Page 4',
            builder: (context) => const Text('Test'),
          ),

          //
          // DebugPanelLogPage(logger: ...),
          ...DebugPanelSettings.defaultPages,
        },
        /*
        buildOverlay: (context) {
          final log = context.read<HttpLogMiddleware>();
          print('[Overlay] log: $log');

          return TextButton(
            onPressed: () {
              context.read<AuthState>().logout();
            },
            child: const Text('Logout'),
          );
        },
        */
      ),
      child: child,
    );
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

class Providers extends StatelessWidget {
  final Widget child;

  const Providers({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final log = context.read<HttpLogMiddleware>();
    print('[Providers] log: $log');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(
          create: (_) => AuthState(),
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Demo'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  DebugPanelController.maybeOf(context)?.open();
                },
                child: const Text('Open DebugPanel'),
              ),
            ],
          ),
        ),
      ),
    );
    /*
    return const DebugPanelCustomize(
      items: [
        / *
        // TODO: !!!
        DebugPanelPageInfo(
          before: 'general',
          replace: true,
          page: DebugPanelPage(
            id: 'custom1',
            title: 'Custom 1',
            builder: (context) => TextButton(
              onPressed: () => context.read<AuthState>().logout(),
              child: Text('Custom 1'),
            ),
          ),
        ),
        * /
      ],
      child: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
    */
  }
}

class ThemeModeSwitch extends StatelessWidget {
  final String text;

  const ThemeModeSwitch({
    super.key,
    this.text = 'Light mode?',
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
                Switch(
                  value: mode == ThemeMode.light,
                  onChanged: (value) {
                    setState(() {
                      themeMode.value = value ? ThemeMode.light : ThemeMode.dark;
                    });
                  },
                ),
                const SizedBox(width: 8),
                child!,
              ],
            );
          },
        );
      },
      child: Text(text),
    );
  }
}
