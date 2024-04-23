import 'package:debug_kit/src/pages/page.dart';
import 'package:debug_kit/src/pages/widgets/prop_list.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugKitPanelGeneralPage extends DebugKitPanelPage {
  static const String defaultName = 'general';

  DebugKitPanelGeneralPage({
    super.sections = const {},
  }) : super(
          name: defaultName,
          title: 'General',
          icon: Icons.info_outline,
        );

  @override
  Set<DebugKitPanelPageBaseSection> get sections => {
        // Package info section
        DebugKitPanelPageSection(
          name: 'package_info',
          title: 'Application info',
          builder: (context, controller) => const _PackageInfoDetails(),
        ),

        // Inherited sections
        ...super.sections,
      };
}

/// Package name & version section
class _PackageInfoDetails extends StatefulWidget {
  const _PackageInfoDetails();

  @override
  State<_PackageInfoDetails> createState() => _PackageInfoDetailsState();
}

class _PackageInfoDetailsState extends State<_PackageInfoDetails> {
  final Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: packageInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError) {
            final packageInfo = snapshot.data!;

            return DebugKitPanelPropList(
              properties: [
                DebugKitPanelProperty(label: 'Application name', value: packageInfo.appName),
                DebugKitPanelProperty(label: 'Package name', value: packageInfo.packageName),
                DebugKitPanelProperty(
                  label: 'Version',
                  value: packageInfo.version,
                  extra: packageInfo.buildNumber.isNotEmpty ? TextSpan(text: ' + ${packageInfo.buildNumber}') : null,
                ),
              ],
            );
          } else {
            return Text(
              'Failed to get package information.',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            );
          }
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
