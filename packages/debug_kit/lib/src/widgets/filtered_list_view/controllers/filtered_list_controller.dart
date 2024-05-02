import 'package:debug_kit/src/widgets/filtered_list_view/models/filter_data.dart';
import 'package:flutter/widgets.dart';

typedef FilteredListFetcher<F extends FilterData, T> = Future<List<T>> Function(
  FilteredListController<F, T> controller,
);

class FilteredListController<F extends FilterData, T> with ChangeNotifier {
  final FilteredListFetcher<F, T> onFetch;

  FilteredListController({required this.onFetch});

  Future<List<T>>? _data;

  bool get reloading => _reloading;
  bool _reloading = false;

  String? get search => _search;
  String? _search;

  F? get filter => _filter;
  F? _filter;

  void apply({String? search, F? filter}) {
    bool shouldNotify = false;

    if (search != null && search != _search) {
      _search = search;
      shouldNotify = true;
    }

    if (filter != null && filter != _filter) {
      _filter = filter;
      shouldNotify = true;
    }

    if (shouldNotify) {
      _data = null;
      notifyListeners();
    }
  }

  void reset({bool search = true, bool filter = true}) {
    bool shouldNotify = false;

    if (search) {
      _search = null;
      shouldNotify = true;
    }

    if (filter) {
      _filter = null;
      shouldNotify = true;
    }

    if (shouldNotify) {
      _data = null;
      notifyListeners();
    }
  }

  Future<List<T>> fetch() {
    return _data ??= onFetch(this);
  }

  Future<List<T>> reload() {
    if (!_reloading && _data != null) {
      _reloading = true;
      _data = null;

      final result = fetch().whenComplete(() {
        // Throttling reload to avoid flickering
        Future.delayed(const Duration(milliseconds: 40), () {
          _reloading = false;
        });
      });

      // The _data variable has changed in fetch(), listeners need to be notified
      notifyListeners();

      return result;
    } else {
      return _data!;
    }
  }

  @override
  bool operator ==(covariant FilteredListController other) => (search == other.search) && (filter == other.filter);

  @override
  int get hashCode => Object.hash(search, filter);

  @override
  String toString() =>
      'FilteredListController(search: ${(search?.isNotEmpty ?? false) ? search : '<empty>'}, filter: $filter)';
}
