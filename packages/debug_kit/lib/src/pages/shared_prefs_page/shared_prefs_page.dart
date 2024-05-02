import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/dialogs/confirm.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/pages/shared_prefs_page/edit_storage_entry_dialog.dart';
import 'package:debug_kit/src/pages/widgets/key_value_grid.dart';
import 'package:debug_kit/src/utils/string_ext.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/controllers/filtered_list_controller.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/filtered_list_view.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/models/filter_data.dart';
import 'package:debug_kit/src/widgets/keyboard_dismisser.dart';
import 'package:debug_kit/src/widgets/search_field.dart';
import 'package:debug_kit/src/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugKitPanelSharedPrefsPage extends DebugKitPanelBasePage {
  static const String defaultName = 'shared_prefs';

  @override
  final String name = defaultName;

  @override
  final String title = 'Shared Prefs';

  @override
  final IconData? icon = Icons.text_snippet_rounded;

  DebugKitPanelSharedPrefsPage();

  @override
  Widget build(BuildContext context, DebugKitController controller) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        return switch (snapshot) {
          AsyncSnapshot(connectionState: ConnectionState.done, hasData: true) =>
            _SharedPrefsInspector(storage: snapshot.data!),
          AsyncSnapshot(
            connectionState: ConnectionState.done,
            hasError: true,
            error: Object error,
            stackTrace: StackTrace? stackTrace
          ) =>
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading shared preferences.\n\n$error\n\n$stackTrace',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          _ => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
        };
      },
    );
  }
}

class _SharedPrefsInspector extends StatefulWidget {
  final SharedPreferences storage;

  const _SharedPrefsInspector({
    required this.storage,
  });

  @override
  State<_SharedPrefsInspector> createState() => _SharedPrefsInspectorState();
}

class _SharedPrefsInspectorState extends State<_SharedPrefsInspector> {
  late final listController = FilteredListController<FilterData, String>(
    onFetch: (controller) async {
      final keys = widget.storage.getKeys();
      final gridKeys = (controller.search == null || controller.search!.isEmpty)
          ? keys
          : keys.where((k) => k.containsInsensitive(controller.search!));
      return gridKeys.toList();
    },
  );

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

      listController.reload();
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
        listController.reload();
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
        listController.reload();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keys = widget.storage.getKeys();

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
            onPressed: keys.isNotEmpty ? () => _clearAll(widget.storage) : null,
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Remove all',
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ],
      ),
      builder: (context, controller, list) {
        return KeyboardDismisser(
          child: KeyValueGrid(
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            entries: {for (var k in list) k: widget.storage.get(k)},
            onEdit: (key) => _edit(widget.storage, key, widget.storage.get(key)),
            onDelete: (key) => _delete(widget.storage, key),
          ),
        );
      },
    );
  }
}
