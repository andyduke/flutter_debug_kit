import 'package:debug_kit/debug_kit.dart';
import 'package:debug_kit_example/main.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class ExampleAppDebugKit extends StatefulWidget {
  final Widget? child;

  const ExampleAppDebugKit({
    super.key,
    required this.child,
  });

  @override
  State<ExampleAppDebugKit> createState() => ExampleAppDebugKitState();

  static ExampleAppDebugKitState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AppDebugPanelScope>()?.state;
  }
}

class ExampleAppDebugKitState extends State<ExampleAppDebugKit> {
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
    // final theme = Theme.of(context);

    return MultiProvider(
      providers: [
        Provider<Logger>.value(
          value: logger,
        ),
        Provider<DebugKitLogController>.value(
          value: log,
        ),
        ChangeNotifierProvider<DebugKitHttpLogController>.value(
          value: httpLog,
        ),
      ],
      child: DebugKit(
        // enabled: kDebugMode,
        navigatorKey: MainApp.navigatorKey,
        settings: DebugKitSettings(
          // buttonVisible: kDebugMode,
          buttonVisible: true,
          pages: {
            DebugKitPanelCustomPage(
              name: 'listTest',
              title: 'List test',
              builder: (context) => const ListTest1(),
            ),

            //
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
                          value: context.watch<ApiServer>().selectedIndex,
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
                          onChanged: (value) {
                            // TODO: Set server
                            context.read<ApiServer>().selectedIndex = value ?? 0;
                            context.read<AuthState>().logout();
                          },
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
                  title: 'Theme',
                  builder: (context, controller) {
                    return const ThemeModeSwitch();
                  },
                ),

                // Floating button visibility
                DebugKitPanelPageSection(
                  name: 'button_visibility',
                  title: 'Floating Button Visibility',
                  builder: (context, controller) {
                    return ListenableBuilder(
                      listenable: controller,
                      builder: (context, child) => StatefulBuilder(
                        builder: (context, setState) {
                          return Row(
                            children: [
                              Switch.adaptive(
                                value: controller.buttonVisible,
                                onChanged: (newValue) => setState(() {
                                  controller.buttonVisible = newValue;
                                }),
                              ),
                              const SizedBox(width: 8),
                              const Text('Visible'),
                            ],
                          );
                        },
                      ),
                    );
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
            ...DebugKitSettings.defaultPages,
          },
        ),
        child: _AppDebugPanelScope(
          state: this,
          child: widget.child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _AppDebugPanelScope extends InheritedWidget {
  final ExampleAppDebugKitState state;

  const _AppDebugPanelScope({
    required super.child,
    required this.state,
  });

  @override
  bool updateShouldNotify(covariant _AppDebugPanelScope oldWidget) => false;
}

// ---

class ListTest1 extends StatefulWidget {
  const ListTest1({super.key});

  @override
  State<ListTest1> createState() => _ListTest1State();
}

class _ListTest1State extends State<ListTest1> {
  final List<
      ({
        bool finished,
        bool success,
        String status,
        String elapsedTime,
        String timestamp,
        String method,
        String url
      })> entries = [
    (
      finished: false,
      success: true,
      status: '200 OK',
      elapsedTime: '1.57 s',
      timestamp: '14:53:18.543',
      method: 'GET',
      url: 'https://official-joke-api.appspot.com/random_joke?id=7',
    ),
    (
      finished: true,
      success: false,
      status: '500 Fail',
      elapsedTime: '274 ms',
      timestamp: '14:53:18.531',
      method: 'GET',
      url: 'https://official-joke-api.appspot.com/random_joke?id=7',
    ),
    (
      finished: true,
      success: true,
      status: '200 OK',
      elapsedTime: '481 ms',
      timestamp: '14:53:18.511',
      method: 'GET',
      url: 'https://httpbin.org/get',
    ),
    (
      finished: true,
      success: true,
      status: '200 OK',
      elapsedTime: '481 ms',
      timestamp: '14:53:18.498',
      method: 'HEAD',
      url: 'https://httpbin.org/get',
    ),
    (
      finished: true,
      success: false,
      status: '481 Fail',
      elapsedTime: '481 ms',
      timestamp: '14:53:18.437',
      method: 'DELETE',
      url: 'https://httpbin.org/get',
    ),
    (
      finished: true,
      success: true,
      status: '200 OK',
      elapsedTime: '481 ms',
      timestamp: '14:53:18.368',
      method: 'POST',
      url: 'https://httpbin.org/get',
    ),
    (
      finished: true,
      success: true,
      status: '200 OK',
      elapsedTime: '481 ms',
      timestamp: '14:53:18.347',
      method: 'POST',
      url: 'https://httpbin.org/get',
    ),
    (
      finished: true,
      success: true,
      status: '200 OK',
      elapsedTime: '481 ms',
      timestamp: '14:53:18.304',
      method: 'POST',
      url: 'https://httpbin.org/get',
    ),
  ];

  bool filterVisible = false;
  int filterSelected = 0;
  List<String> filters = [
    'All',
    'Success',
    'Error',
  ];

  void _applyFilter(int index) {
    setState(() {
      filterSelected = index;
    });
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: MaterialLocalizations.of(context).searchFieldLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    filled: true,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: IconButton(
                            onPressed: () {},
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            icon: const Icon(Icons.clear, size: 24),
                          ),
                        ),

                        //
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                filterVisible = !filterVisible;
                              });
                            },
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(46, 42),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              foregroundColor: filterVisible
                                  ? theme.colorScheme.onSecondaryContainer
                                  : theme.colorScheme.onSecondaryContainer,
                              backgroundColor: filterVisible
                                  ? theme.colorScheme.primary.withOpacity(0.5)
                                  : theme.colorScheme.secondaryContainer.withOpacity(0.8),
                            ),
                            child: const Icon(Icons.filter_alt),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              //
              /*
              IconButton(
                onPressed: () {
                  setState(() {
                    filterVisible = !filterVisible;
                  });
                },
                icon: const Icon(Icons.filter_alt),
                tooltip: 'Toggle filters',
                style: TextButton.styleFrom(
                  foregroundColor: filterVisible ? theme.colorScheme.primary : null,
                ),
              ),
              const SizedBox(width: 4),
              */

              //
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Remove all',
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),

        // Filter bar
        if (filterVisible)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: ChipTheme(
              data: ChipThemeData(
                shape: const StadiumBorder(),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),

                //
                labelStyle: TextStyle(
                  color: MaterialStateColor.resolveWith((states) => switch (states) {
                        Set() when states.contains(MaterialState.selected) => theme.colorScheme.onSecondaryContainer,
                        _ => theme.colorScheme.primary.withOpacity(0.9),
                      }),
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
                // side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.6)),
                side: MaterialStateBorderSide.resolveWith((states) => switch (states) {
                      Set() when states.contains(MaterialState.selected) => BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.01),
                        ),
                      _ => BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                    }),
                backgroundColor: theme.scaffoldBackgroundColor,
                selectedColor: theme.colorScheme.primary.withOpacity(0.5),

                /*
                labelStyle: TextStyle(
                  color: MaterialStateColor.resolveWith((states) => switch (states) {
                        Set() when states.contains(MaterialState.selected) => theme.colorScheme.onSecondaryContainer,
                        _ => theme.colorScheme.primary,
                      }),
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(color: theme.colorScheme.primary),
                backgroundColor: theme.scaffoldBackgroundColor,
                selectedColor: theme.colorScheme.secondaryContainer,
                */
                /*
                labelStyle: TextStyle(
                  color: MaterialStateColor.resolveWith((states) => switch (states) {
                        Set() when states.contains(MaterialState.selected) => theme.colorScheme.onSecondaryContainer,
                        _ => theme.colorScheme.onSecondaryContainer.withOpacity(0.7),
                      }),
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
                side: const BorderSide(color: Colors.transparent),
                backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.7),
                selectedColor: theme.colorScheme.secondary.withOpacity(0.7),
                */
              ),
              child: SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    FilterChip(
                        label: Text(filters.first), selected: filterSelected == 0, onSelected: (_) => _applyFilter(0)),
                    const SizedBox(width: 10),
                    // VerticalDivider(color: theme.dividerColor.withOpacity(0.7), indent: 5, endIndent: 5),
                    VerticalDivider(color: theme.dividerColor.withOpacity(0.7), indent: 12, endIndent: 12),
                    const SizedBox(width: 10),
                    ...filters.skip(1).mapIndexed(
                          (i, f) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: FilterChip(
                                label: Text(f),
                                selected: filterSelected == (i + 1),
                                onSelected: (_) => _applyFilter(i + 1)),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),

        // List title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16) + const EdgeInsets.only(top: 16, bottom: 4),
          child: Text(
            'Requests  •  ${entries.length}'.toUpperCase(),
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeader(context);
        }

        final entry = entries[index - 1];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Material(
            child: Ink(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Meta info
                      DefaultTextStyle(
                        style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Status icon
                            !entry.finished
                                ? const SizedBox.square(dimension: 12, child: CircularProgressIndicator(strokeWidth: 2))
                                : Badge(
                                    backgroundColor: entry.success ? Colors.teal.shade300 : Colors.pink, smallSize: 10),
                            const SizedBox(width: 10),

                            // Status code
                            if (entry.finished) Text('${entry.status}  •  '),

                            // HTTP Method
                            Text(entry.method),

                            // Time
                            const SizedBox(width: 16),
                            if (entry.finished)
                              Expanded(
                                child: Text(
                                  '${entry.elapsedTime} • ${entry.timestamp}',
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),

                      //
                      const SizedBox(height: 6),
                      DefaultTextStyle(
                        style: const TextStyle(fontSize: 17),
                        child: Text(entry.url, maxLines: 3, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      /*
      itemBuilder: (context, index) => ListTile(
        title: Text('Item ${index + 1}'),
        subtitle: const Text('subtitle'),
      ),
      */
    );
  }
}
