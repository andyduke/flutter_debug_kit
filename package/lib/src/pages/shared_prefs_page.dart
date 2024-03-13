import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/dialogs/confirm.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/pages/widgets/key_value_grid.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugPanelSharedPrefsPage extends DebugPanelBasePage {
  @override
  final String name = 'shared_prefs';

  @override
  final String title = 'Shared Prefs';

  @override
  final IconData? icon = Icons.history;

  DebugPanelSharedPrefsPage();

  @override
  Widget build(BuildContext context, DebugPanelController controller) {
    return const _SharedPrefsInspector();
  }
}

class _SharedPrefsInspector extends StatefulWidget {
  const _SharedPrefsInspector();

  @override
  State<_SharedPrefsInspector> createState() => _SharedPrefsInspectorState();
}

class _SharedPrefsInspectorState extends State<_SharedPrefsInspector> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  void reload() {
    setState(() {});
  }

  Future<void> _delete(SharedPreferences storage, String key) async {
    final theme = Theme.of(context);

    showConfirmation(
      context: context,
      title: 'Remove entry',
      text: Text.rich(TextSpan(
        children: [
          const TextSpan(text: 'Are you sure you want to remove the '),
          TextSpan(text: key, style: TextStyle(fontWeight: FontWeight.w500, color: theme.colorScheme.error)),
          const TextSpan(text: ' value?'),
        ],
      )),
      yesText: 'Remove',
      noText: 'Cancel',
      yesColor: theme.colorScheme.error,
    ).then((result) {
      if (result) {
        storage.remove(key);
        reload();
      }
    });
  }

  Future<void> _clearAll(SharedPreferences storage) async {
    final theme = Theme.of(context);

    showConfirmation(
      context: context,
      title: 'Remove all',
      text: Text.rich(TextSpan(
        children: [
          const TextSpan(text: 'Are you sure you want to remove '),
          TextSpan(text: 'all entries', style: TextStyle(fontWeight: FontWeight.w500, color: theme.colorScheme.error)),
          const TextSpan(text: ' from Shared Preferences?'),
        ],
      )),
      yesText: 'Remove all',
      noText: 'Cancel',
      yesColor: theme.colorScheme.error,
    ).then((result) {
      if (result) {
        storage.clear();
        reload();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefs,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (!snapshot.hasError) {
            final theme = Theme.of(context);
            final storage = snapshot.data!;
            final keys = storage.getKeys();

            return Column(
              children: [
                // Toolbar
                _Toolbar(
                  leading: [
                    Text('${keys.length} items', style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                  trailing: [
                    TextButton.icon(
                      onPressed: keys.isNotEmpty ? () => _clearAll(storage) : null,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Remove all'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),

                // Grid
                Expanded(
                  child: KeyValueGrid(
                    entries: {for (var k in keys) k: storage.get(k)},
                    onDelete: (key) => _delete(storage, key),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading shared preferences.\n\n${snapshot.error}\n\n${snapshot.stackTrace}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            );
          }
        }
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  final List<Widget> leading;
  final List<Widget> trailing;

  const _Toolbar({
    required this.leading,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: theme.dividerTheme.color ?? theme.dividerColor)),
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ...leading,
          const Spacer(),
          ...trailing,
        ],
      ),
    );
  }
}
