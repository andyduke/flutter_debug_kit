import 'package:debug_panel/debug_panel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DemoScreen(),
      builder: (context, child) {
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
    );

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
    return Scaffold(
      body: Consumer<AuthState>(
        builder: (context, value, child) {
          return Text('Is logged: ${value.isLogged}');
        },
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
