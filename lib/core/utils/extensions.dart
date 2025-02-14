import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension StringExtensions on String {
  String capitalize() => length > 0
      ? "${this[0].toUpperCase()}${substring(1)}"
      : this;
}