import 'package:flutter/material.dart';

extension DateTimeUtils on DateTime {
  format(BuildContext context) {
    final l = MaterialLocalizations.of(context);
    return '${l.formatCompactDate(this)} $hour:$minute:$second.$millisecond';
  }
}
