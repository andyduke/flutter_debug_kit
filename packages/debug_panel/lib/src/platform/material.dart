import 'package:flutter/material.dart';

/// Checks for MaterialApp in the widget tree.
bool isMaterialApp(BuildContext context) => context.findAncestorWidgetOfExactType<MaterialApp>() != null;

/// Creates a Material HeroController.
HeroController createMaterialHeroController() => MaterialApp.createMaterialHeroController();
