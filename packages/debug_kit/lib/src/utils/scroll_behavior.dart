import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugKitScrollBehavior extends MaterialScrollBehavior {
  bool isDesktop([BuildContext? context]) {
    final platform = (context != null) ? getPlatform(context) : TargetPlatform;
    return kIsWeb ||
        (platform == TargetPlatform.linux) ||
        (platform == TargetPlatform.macOS) ||
        (platform == TargetPlatform.windows);
  }

  /*
  @override
  Set<PointerDeviceKind> get dragDevices => isDesktop()
      ? {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.invertedStylus,
          PointerDeviceKind.trackpad,
          // The VoiceAccess sends pointer events with unknown type when scrolling
          // scrollables.
          PointerDeviceKind.unknown,
        }
      : super.dragDevices;
  */

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // When modifying this function, consider modifying the implementation in
    // the base class ScrollBehavior as well.
    switch (axisDirectionToAxis(details.direction)) {
      case Axis.horizontal:
        return child;

      //
      case Axis.vertical:
        // assert(details.controller != null);

        return (details.controller?.hasClients ?? false)
            ? child
            : Scrollbar(
                thumbVisibility: isDesktop(context),
                controller: details.controller,
                child: child,
              );

      /*
        if (kIsWeb) {
          assert(details.controller != null);
          return Scrollbar(
            thumbVisibility: true,
            controller: details.controller,
            child: child,
          );
        } else {
          switch (getPlatform(context)) {
            case TargetPlatform.linux:
            case TargetPlatform.macOS:
            case TargetPlatform.windows:
              assert(details.controller != null);
              return Scrollbar(
                thumbVisibility: true,
                controller: details.controller,
                child: child,
              );
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.iOS:
              // return child;
              assert(details.controller != null);
              return Scrollbar(
                controller: details.controller,
                child: child,
              );
          }
        }
        */
    }
  }
}
