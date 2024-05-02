import 'package:meta/meta.dart';

abstract class FilterData {
  @override
  @mustBeOverridden
  bool operator ==(covariant FilterData other);

  @override
  @mustBeOverridden
  int get hashCode;
}
