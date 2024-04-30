import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class LogList<E> extends DelegatingList<E> with ChangeNotifier {
  final int maxLength;

  LogList({this.maxLength = -1}) : super([]);

  @override
  void operator []=(int index, E value) {
    super[index] = value;
    notifyListeners();
  }

  @override
  List<E> operator +(List<E> other) {
    final result = super + other;
    _trimLimit();
    notifyListeners();
    return result;
  }

  @override
  void add(E value) {
    super.add(value);
    _trimLimit();
    notifyListeners();
  }

  @override
  void addAll(Iterable<E> iterable) {
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
  void fillRange(int start, int end, [E? fillValue]) {
    super.fillRange(start, end, fillValue);
    _trimLimit();
    notifyListeners();
  }

  @override
  set first(E value) {
    super.first = value;
    notifyListeners();
  }

  @override
  void insert(int index, E element) {
    super.insert(index, element);
    _trimLimit();
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    super.insertAll(index, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  set last(E value) {
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
  E removeAt(int index) {
    final result = super.removeAt(index);
    notifyListeners();
    return result;
  }

  @override
  E removeLast() {
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
  void removeWhere(bool Function(E) test) {
    super.removeWhere(test);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<E> iterable) {
    super.replaceRange(start, end, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(E) test) {
    super.retainWhere(test);
    notifyListeners();
  }

  @override
  List<E> get reversed => List.unmodifiable(super.reversed);

  @override
  void setAll(int index, Iterable<E> iterable) {
    super.setAll(index, iterable);
    _trimLimit();
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
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
  void sort([int Function(E, E)? compare]) {
    super.sort(compare);
    notifyListeners();
  }

  void _trimLimit() {
    if ((maxLength > 0) && (length > maxLength)) {
      super.removeRange(0, length - maxLength);
    }
  }
}
