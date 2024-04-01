import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:debug_kit/debug_kit.dart';
import 'package:flutter/foundation.dart';

class DebugKitLogHistory extends DelegatingList<DebugKitLogRecord> with ChangeNotifier {
  final int maxLength;

  DebugKitLogHistory({this.maxLength = -1}) : super([]);

  @override
  void operator []=(int index, DebugKitLogRecord value) {
    super[index] = value;
    notifyListeners();
  }

  @override
  List<DebugKitLogRecord> operator +(List<DebugKitLogRecord> other) {
    final result = super + other;
    _trimLimit();
    notifyListeners();
    return result;
  }

  @override
  void add(DebugKitLogRecord value) {
    super.add(value);
    _trimLimit();
    notifyListeners();
  }

  @override
  void addAll(Iterable<DebugKitLogRecord> iterable) {
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
  void fillRange(int start, int end, [DebugKitLogRecord? fillValue]) {
    super.fillRange(start, end, fillValue);
    _trimLimit();
    notifyListeners();
  }

  @override
  set first(DebugKitLogRecord value) {
    super.first = value;
    notifyListeners();
  }

  @override
  void insert(int index, DebugKitLogRecord element) {
    super.insert(index, element);
    _trimLimit();
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<DebugKitLogRecord> iterable) {
    super.insertAll(index, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  set last(DebugKitLogRecord value) {
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
  DebugKitLogRecord removeAt(int index) {
    final result = super.removeAt(index);
    notifyListeners();
    return result;
  }

  @override
  DebugKitLogRecord removeLast() {
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
  void removeWhere(bool Function(DebugKitLogRecord) test) {
    super.removeWhere(test);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<DebugKitLogRecord> iterable) {
    super.replaceRange(start, end, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(DebugKitLogRecord) test) {
    super.retainWhere(test);
    notifyListeners();
  }

  @override
  List<DebugKitLogRecord> get reversed => List.unmodifiable(super.reversed);

  @override
  void setAll(int index, Iterable<DebugKitLogRecord> iterable) {
    super.setAll(index, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<DebugKitLogRecord> iterable, [int skipCount = 0]) {
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
  void sort([int Function(DebugKitLogRecord, DebugKitLogRecord)? compare]) {
    super.sort(compare);
    notifyListeners();
  }

  void _trimLimit() {
    if ((maxLength > 0) && (length > maxLength)) {
      super.removeRange(0, length - maxLength);
    }
  }
}
