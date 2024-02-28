import 'package:flutter/foundation.dart';

class CustomTabController with ChangeNotifier {
  final int length;

  CustomTabController({
    required this.length,
    int initialIndex = 0,
  })  : assert(length >= 0),
        assert(initialIndex >= 0 && (length == 0 || initialIndex < length)),
        _index = initialIndex,
        _previousIndex = initialIndex;

  CustomTabController._({
    required int index,
    required int previousIndex,
    required this.length,
  })  : _index = index,
        _previousIndex = previousIndex;

  CustomTabController copyWith({
    required int? index,
    required int? length,
    required int? previousIndex,
  }) {
    return CustomTabController._(
      index: index ?? _index,
      length: length ?? this.length,
      previousIndex: previousIndex ?? _previousIndex,
    );
  }

  int get index => _index;
  int _index = 0;
  set index(int newValue) {
    _changeIndex(newValue);
  }

  int get previousIndex => _previousIndex;
  int _previousIndex = -1;

  void _changeIndex(int value) {
    if (value != _index) {
      if ((value >= 0) && (value < length)) {
        _previousIndex = _index;
        _index = value;
        notifyListeners();
      }
    }
  }
}
