import 'package:debug_kit/debug_kit.dart';
import 'package:debug_kit_example/main.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDebugPanel extends StatefulWidget {
  final Widget? child;

  const AppDebugPanel({
    super.key,
    required this.child,
  });

  @override
  State<AppDebugPanel> createState() => AppDebugPanelState();

  static AppDebugPanelState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AppDebugPanelScope>()?.state;
  }
}

class AppDebugPanelState extends State<AppDebugPanel> {
  final log = DebugKitLogController(/*maxLength: 10*/);
  final logger = Logger('test');
  final httpLog = DebugKitHttpLogController();

  DebugKitLogLevel _loggerLevelToDebugPanel(Level level) {
    switch (level) {
      case Level.FINEST:
      case Level.FINER:
      case Level.FINE:
      case Level.CONFIG:
      case Level.INFO:
        return DebugKitLogLevel.info;

      case Level.WARNING:
        return DebugKitLogLevel.warning;

      case Level.SEVERE:
        return DebugKitLogLevel.error;

      case Level.SHOUT:
        return DebugKitLogLevel.debug;

      default:
        return DebugKitLogLevel.debug;
    }
  }

  @override
  void initState() {
    super.initState();

    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');

      log.add(DebugKitLogRecord(
        level: _loggerLevelToDebugPanel(record.level),
        message: record.message,
        time: record.time,
        error: record.error,
        stackTrace: record.stackTrace,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DebugKit(
      // enabled: kDebugMode,
      navigatorKey: MainApp.navigatorKey,
      settings: DebugKitSettings(
        // buttonVisible: kDebugMode,
        buttonVisible: true,
        pages: {
          DebugKitPanelGeneralPage(
            sections: {
              DebugKitPanelPageSection(
                name: 'server',
                title: 'API Server',
                subtitle: 'Choose API server', // optional
                footnote: 'Footnote', // optional
                collapsed: false, // optional
                builder: (context, controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Server dropdown emulation
                      const Text('Server dropdown'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthState>().logout();
                          controller.close();
                        },
                        child: const Text('Switch'),
                      ),

                      // Dropdown styling test
                      const SizedBox(height: 24),
                      DebugKitPanelDropdownButton<int>(
                        itemHeight: 60,

                        //
                        value: 2,
                        items: [
                          const DropdownMenuItem(
                            value: 1,
                            child: Text('Item 1'),
                          ),
                          const DropdownMenuItem(
                            value: 2,
                            child: Text('Item 2'),
                          ),
                          const DropdownMenuItem(
                            value: 3,
                            child: Text('Item 3'),
                          ),

                          //
                          DropdownMenuItem(
                            value: 4,
                            alignment: Alignment.centerLeft,
                            child: Builder(builder: (context) {
                              final theme = Theme.of(context);

                              return OverflowBox(
                                alignment: Alignment.centerLeft,
                                maxWidth: 320,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints.tightFor(
                                          height: ((theme.textTheme.titleLarge?.fontSize ?? 32) * 0.9).clamp(18, 36) *
                                              (theme.textTheme.titleLarge?.height ?? 1.0),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: (/*is selected */ false)
                                                ? Padding(
                                                    padding: const EdgeInsets.only(top: 3),
                                                    child:
                                                        Icon(Icons.circle, color: theme.colorScheme.primary, size: 8),
                                                  )
                                                : const SizedBox(width: 8),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Item 5',
                                            style: theme.textTheme.titleLarge?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  ((theme.textTheme.titleLarge?.fontSize ?? 32) * 0.9).clamp(18, 36),
                                            ),
                                          ),
                                          Text('subtitle', style: theme.textTheme.titleSmall),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                      /*
                      DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          // itemHeight: 60,
                          borderRadius: BorderRadius.circular(5),
                          icon: const Icon(Icons.expand_more),
                          // dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
                          // focusColor: Theme.of(context).colorScheme.secondaryContainer,
                          // dropdownColor: Theme.of(context).cardColor,
                          // focusColor: Theme.of(context).colorScheme.secondaryContainer,
                          dropdownColor: Theme.of(context).colorScheme.surfaceVariant,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),

                          //
                          value: 2,
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Item 1'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('Item 2'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('Item 3'),
                            ),
                          ],
                          onChanged: (v) {},
                        ),
                      ),
                      */

                      //
                      const SizedBox(height: 24),

                      // Dialog test
                      ElevatedButton(
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'DebugPanel Demo App',
                            applicationVersion: '0.1',
                            applicationLegalese: '(C) Andy Chentsov',
                          );
                        },
                        child: const Text('Show Dialog'),
                      ),

                      //
                      const SizedBox(height: 24),

                      //
                      ElevatedButton(
                        onPressed: () async {
                          final sharedPrefs = await SharedPreferences.getInstance();
                          sharedPrefs.setString('test_string', 'String 1');
                          sharedPrefs.setBool('test_bool', true);
                          sharedPrefs.setInt('test_int', 77);
                          sharedPrefs.setDouble('test_double', 77.1);
                          sharedPrefs.setStringList('test_string_list', ['String 1', 'String 2']);
                        },
                        child: const Text('Fill SharedPrefs'),
                      ),
                      //
                      const SizedBox(height: 24),

                      //
                      ElevatedButton(
                        onPressed: () async {
                          logger.info('Info test');
                          logger.severe('Error test', UnimplementedError(), StackTrace.current);

                          log.debug('Debug msg', tag: 'test');
                          log.criticalError('Critical err', UnimplementedError(), tag: 'test');
                          log.error('Err', UnimplementedError(), tag: 'test');
                          log.warning('Warn', tag: 'test');
                          log.debug('Dbg', tag: 'test');
                          log.debug('Dbg 2', tag: 'tagged');
                        },
                        child: const Text('Log entry'),
                      ),
                    ],
                  );
                },
              ),
              DebugKitPanelPageSection(
                name: 'theme_switch',
                title: 'Theme Mode',
                builder: (context, controller) {
                  return const ThemeModeSwitch(text: 'Main App Light Mode?');
                },
              ),

              /*
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

                      //
                      const SizedBox(height: 24),

                      //
                      ElevatedButton(
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'DebugPanel Demo App',
                            applicationVersion: '0.1',
                            applicationLegalese: '(C) Andy Chentsov',
                          );
                        },
                        child: const Text('Show Dialog'),
                      ),
                    ],
                  );
                },
              ),
              */
            },
          ),

          DebugKitPanelSharedPrefsPage(),

          DebugKitPanelLogPage(
            log: log,
          ),

          DebugKitPanelHttpPage(
            httpLogController: httpLog,
          ),

          DebugKitPanelCustomPage(
            name: 'log',
            title: 'Log',
            icon: Icons.history,
            builder: (context) => const Text('Log'),
          ),

          DebugKitPanelCustomPage(
            name: 'network',
            title: 'Network',
            icon: Icons.network_check,
            builder: (context) => const Text('Network'),
          ),

          /*
          DebugPanelCustomPage(
            name: 'sharedPrefs',
            title: 'Shared Preferences',
            icon: Icons.history,
            builder: (context) => const Text('Shared Prefs Inspector'),
          ),
          */

          DebugKitPanelPage(
            name: 'sectionsTest',
            title: 'Sections Test',
            sections: {
              DebugKitPanelPageSection(
                collapsed: false,
                name: 'section1',
                title: 'Section 1',
                footnote:
                    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed dapibus, ante ultricies adipiscing pulvinar.',
                builder: (context, controller) => const Text('Section 1'),
              ),
              DebugKitPanelPageSection(
                name: 'section2',
                title: 'Section 2',
                builder: (context, controller) => const Text('Section 2'),
              ),
              DebugKitPanelPageSection(
                name: 'section3',
                title: 'Section 3',
                builder: (context, controller) => Container(color: Colors.blue.shade800, height: 1000),
              ),
            },
          ),

          DebugKitPanelCustomPage(
            name: 'test',
            title: 'Test Page 1',
            builder: (context) => const Text('Test'),
          ),

          DebugKitPanelCustomPage(
            name: 'test2',
            title: 'Test Page 2',
            builder: (context) => const Text('Test'),
          ),
          DebugKitPanelCustomPage(
            name: 'test3',
            title: 'Test Page 3',
            builder: (context) => const Text('Test'),
          ),
          DebugKitPanelCustomPage(
            name: 'test4',
            title: 'Test Page 4',
            builder: (context) => const Text('Test'),
          ),

          //
          // DebugPanelLogPage(logger: ...),
          ...DebugKitSettings.defaultPages,
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
      child: _AppDebugPanelScope(
        state: this,
        child: widget.child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _AppDebugPanelScope extends InheritedWidget {
  final AppDebugPanelState state;

  const _AppDebugPanelScope({
    required super.child,
    required this.state,
  });

  @override
  bool updateShouldNotify(covariant _AppDebugPanelScope oldWidget) => false;
}
