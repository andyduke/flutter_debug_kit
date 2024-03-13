import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/dialogs/confirm.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/pages/log_page/models/log_controller.dart';
import 'package:debug_panel/src/pages/log_page/models/log_history.dart';
import 'package:debug_panel/src/utils/string_ext.dart';
import 'package:debug_panel/src/widgets/filtered_list_view/controllers/filtered_list_controller.dart';
import 'package:debug_panel/src/widgets/filtered_list_view/filtered_list_view.dart';
import 'package:debug_panel/src/widgets/floating_bottom_bar.dart';
import 'package:debug_panel/src/widgets/search_field.dart';
import 'package:debug_panel/src/widgets/toolbar.dart';
import 'package:flutter/material.dart';

class DebugPanelLogPage extends DebugPanelBasePage {
  @override
  final String name = 'log';

  @override
  final String title = 'Log';

  @override
  final IconData? icon = Icons.history_rounded;

  final DebugPanelLogController log;

  DebugPanelLogPage({
    required this.log,
  });

  @override
  Widget build(BuildContext context, DebugPanelController controller) {
    return _LogViewer(log: log.history);
  }
}

class _LogViewer extends StatefulWidget {
  final DebugPanelLogHistory log;

  const _LogViewer({
    required this.log,
  });

  @override
  State<_LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<_LogViewer> {
  final listController = FilteredListController();
  bool selectionMode = false;

  Future<void> _clear() async {
    final theme = Theme.of(context);

    final result = await showConfirmation(
      context: context,
      title: 'Clear log',
      text: const Text('Are you sure you want to clear the log?'),
      yesText: 'Clear',
      noText: 'Cancel',
      yesColor: theme.colorScheme.error,
    );

    if (result == true) {
      widget.log.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.log,
      builder: (context, child) {
        final logReversed = widget.log.reversed;

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
                onPressed: _clear,
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Remove all',
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          builder: (context, controller) {
            final filteredLog = (controller.search != null && controller.search!.isNotEmpty)
                ? logReversed.where((e) =>
                    e.message.containsInsensitive(controller.search!) ||
                    (e.tag?.containsInsensitive(controller.search!) ?? false))
                : logReversed;

            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: FloatingBottomBar.kFloatingBarHeight + FloatingBottomBar.kFloatingBarOffset + 8),
                  itemCount: filteredLog.length,
                  itemBuilder: (context, index) {
                    final record = filteredLog.elementAt(index);

                    return ListTile(
                      onLongPress: () {
                        setState(() {
                          selectionMode = !selectionMode;
                        });
                      },
                      title: Text('${record.tag} | ${record.message}'),
                      subtitle: Text('${record.time}'),
                    );
                  },
                ),

                // Floating bottom bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingBottomBar(
                      highlighted: selectionMode,
                      children: [
                        if (selectionMode)
                          const Padding(
                            padding: EdgeInsets.only(left: 16, right: 8),
                            child: Text('(1)', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),

                        //
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          label: const Text('Export'),
                        ),

                        //
                        if (selectionMode)
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.delete),
                            label: const Text('Remove'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
