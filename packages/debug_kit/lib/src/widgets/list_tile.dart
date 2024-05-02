import 'package:debug_kit/src/theme/extensions/list_tile_theme.dart';
import 'package:flutter/material.dart';

class DebugKitListTile extends StatelessWidget {
  final Widget? supertitle;
  final Widget? subtitle;
  final Widget title;
  final VoidCallback? onTap;

  const DebugKitListTile({
    super.key,
    this.supertitle,
    this.subtitle,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listTileTheme = theme.extension<DebugKitListTileTheme>();

    return Container(
      margin: listTileTheme?.margin,
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
              padding: listTileTheme?.padding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (supertitle != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: listTileTheme?.titleSpacing ?? 0.0),
                      child: DefaultTextStyle(
                        style: listTileTheme?.supertitleTextStyle ?? const TextStyle(),
                        child: supertitle!,
                      ),
                    ),

                  //
                  DefaultTextStyle(
                    style: listTileTheme?.titleTextStyle ?? const TextStyle(),
                    child: title,
                  ),

                  if (subtitle != null)
                    Padding(
                      padding: EdgeInsets.only(top: listTileTheme?.titleSpacing ?? 0.0),
                      child: DefaultTextStyle(
                        style: listTileTheme?.subtitleTextStyle ?? const TextStyle(),
                        child: subtitle!,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
