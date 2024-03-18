import 'package:debug_panel/src/pages/page.dart';
import 'package:debug_panel/src/pages/widgets/prop_list.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugPanelGeneralPage extends DebugPanelPage {
  DebugPanelGeneralPage({
    super.sections = const {},
  }) : super(
          name: 'general',
          title: 'General',
          icon: Icons.info_outline,
        );

  @override
  Set<DebugPanelPageBaseSection> get sections => {
        // Package info section
        DebugPanelPageSection(
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
  State<_PackageInfoDetails> createState() => __PackageInfoDetailsState();
}

class __PackageInfoDetailsState extends State<_PackageInfoDetails> {
  final Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: packageInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError) {
            final packageInfo = snapshot.data!;

            return DebugPanelPropList(
              properties: [
                DebugPanelProperty(label: 'Application name', value: packageInfo.appName),
                DebugPanelProperty(label: 'Package name', value: packageInfo.packageName),
                DebugPanelProperty(
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
