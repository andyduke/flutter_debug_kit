import 'package:flutter/cupertino.dart';

/// Checks for CupertinoApp in the widget tree.
bool isCupertinoApp(BuildContext context) => context.findAncestorWidgetOfExactType<CupertinoApp>() != null;

/// Creates a Cupertino HeroController.
HeroController createCupertinoHeroController() => CupertinoApp.createCupertinoHeroController();
