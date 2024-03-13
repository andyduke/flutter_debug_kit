import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/dialogs/confirm.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/pages/shared_prefs_page/edit_storage_entry_dialog.dart';
import 'package:debug_panel/src/pages/widgets/key_value_grid.dart';
import 'package:debug_panel/src/utils/string_ext.dart';
import 'package:debug_panel/src/widgets/filtered_list_view/controllers/filtered_list_controller.dart';
import 'package:debug_panel/src/widgets/filtered_list_view/filtered_list_view.dart';
import 'package:debug_panel/src/widgets/search_field.dart';
import 'package:debug_panel/src/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugPanelSharedPrefsPage extends DebugPanelBasePage {
  @override
  final String name = 'shared_prefs';

  @override
  final String title = 'Shared Prefs';

  @override
  final IconData? icon = Icons.text_snippet_rounded;

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
  final listController = FilteredListController();

  void reload() {
    setState(() {});
  }

  Future<void> _edit(SharedPreferences storage, String key, Object? value) async {
    final newValue = await EditStorageEntryDialog.show(
      context: context,
      title: 'Edit entry',
      name: key,
      value: value,
    );

    if (newValue != null) {
      switch (newValue.runtimeType) {
        case String:
          storage.setString(key, newValue as String);
          break;

        case int:
          storage.setInt(key, newValue as int);
          break;

        case double:
          storage.setDouble(key, newValue as double);
          break;

        case bool:
          storage.setBool(key, newValue as bool);
          break;

        case List:
          if (newValue is List<String>) {
            storage.setStringList(key, newValue);
          } else {
            throw Exception('Invalid value type: ${newValue.runtimeType}');
          }
          break;

        default:
          throw Exception('Invalid value type: ${newValue.runtimeType}');
      }

      reload();
    }
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
          const TextSpan(text: '\n\n'),
          TextSpan(
              text: 'Warning: This operation cannot be undone!',
              style: TextStyle(fontWeight: FontWeight.w500, color: theme.colorScheme.error)),
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

            return FilteredListView(
              controller: listController,
              filterBuilder: (context, controller) => Toolbar(
                leading: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SearchField(
                        onChange: (value) => controller.apply(search: value),
                      ),
                    ),
                  ),
                ],
                trailing: [
                  IconButton(
                    onPressed: keys.isNotEmpty ? () => _clearAll(storage) : null,
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Remove all',
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
              builder: (context, controller) {
                final gridKeys = (controller.search == null || controller.search!.isEmpty)
                    ? keys
                    : keys.where((k) => k.containsInsensitive(controller.search!));

                return KeyValueGrid(
                  entries: {for (var k in gridKeys) k: storage.get(k)},
                  onEdit: (key) => _edit(storage, key, storage.get(key)),
                  onDelete: (key) => _delete(storage, key),
                );
              },
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
