import 'package:debug_panel/src/widgets/filtered_list_view/models/filter_data.dart';
import 'package:flutter/widgets.dart';

class FilteredListController<F extends FilterData> with ChangeNotifier {
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
      notifyListeners();
    }
  }
}
