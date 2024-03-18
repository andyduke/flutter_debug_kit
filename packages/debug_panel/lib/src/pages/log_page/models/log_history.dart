import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:debug_panel/debug_panel.dart';
import 'package:flutter/foundation.dart';

class DebugPanelLogHistory extends DelegatingList<DebugPanelLogRecord> with ChangeNotifier {
  final int maxLength;

  DebugPanelLogHistory({this.maxLength = -1}) : super([]);

  @override
  void operator []=(int index, DebugPanelLogRecord value) {
    super[index] = value;
    notifyListeners();
  }

  @override
  List<DebugPanelLogRecord> operator +(List<DebugPanelLogRecord> other) {
    final result = super + other;
    _trimLimit();
    notifyListeners();
    return result;
  }

  @override
  void add(DebugPanelLogRecord value) {
    super.add(value);
    _trimLimit();
    notifyListeners();
  }

  @override
  void addAll(Iterable<DebugPanelLogRecord> iterable) {
    super.addAll(iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  void clear() {
    super.clear();
    notifyListeners();
  }

  @override
  void fillRange(int start, int end, [DebugPanelLogRecord? fillValue]) {
    super.fillRange(start, end, fillValue);
    _trimLimit();
    notifyListeners();
  }

  @override
  set first(DebugPanelLogRecord value) {
    super.first = value;
    notifyListeners();
  }

  @override
  void insert(int index, DebugPanelLogRecord element) {
    super.insert(index, element);
    _trimLimit();
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<DebugPanelLogRecord> iterable) {
    super.insertAll(index, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  set last(DebugPanelLogRecord value) {
    super.last = value;
    notifyListeners();
  }

  @override
  set length(int newLength) {
    super.length = newLength;
    notifyListeners();
  }

  @override
  bool remove(Object? value) {
    final result = super.remove(value);
    notifyListeners();
    return result;
  }

  @override
  DebugPanelLogRecord removeAt(int index) {
    final result = super.removeAt(index);
    notifyListeners();
    return result;
  }

  @override
  DebugPanelLogRecord removeLast() {
    final result = super.removeLast();
    notifyListeners();
    return result;
  }

  @override
  void removeRange(int start, int end) {
    super.removeRange(start, end);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(DebugPanelLogRecord) test) {
    super.removeWhere(test);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<DebugPanelLogRecord> iterable) {
    super.replaceRange(start, end, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(DebugPanelLogRecord) test) {
    super.retainWhere(test);
    notifyListeners();
  }

  @override
  List<DebugPanelLogRecord> get reversed => List.unmodifiable(super.reversed);

  @override
  void setAll(int index, Iterable<DebugPanelLogRecord> iterable) {
    super.setAll(index, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<DebugPanelLogRecord> iterable, [int skipCount = 0]) {
    super.setRange(start, end, iterable, skipCount);
    _trimLimit();
    notifyListeners();
  }

  @override
  void shuffle([math.Random? random]) {
    super.shuffle(random);
    notifyListeners();
  }

  @override
  void sort([int Function(DebugPanelLogRecord, DebugPanelLogRecord)? compare]) {
    super.sort(compare);
    notifyListeners();
  }

  void _trimLimit() {
    if ((maxLength != -1) && (length > maxLength)) {
      super.removeRange(0, length - maxLength);
    }
  }
}
