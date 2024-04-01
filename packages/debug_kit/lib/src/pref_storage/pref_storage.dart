import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugKitPrefStorage {
  Future<SharedPreferences> get prefs async => _prefs ??= await SharedPreferences.getInstance();
  SharedPreferences? _prefs;

  Future<T?> get<T extends Object>(String name) async {
    final storage = await prefs;

    switch (T) {
      case DateTime:
        final value = storage.get(name) as int?;
        return (value != null) ? (DateTime.fromMillisecondsSinceEpoch(value) as T?) : null;

      case Offset:
        return _parseOffset(storage.getString(name)) as T?;

      case String:
        return storage.getString(name) as T?;

      case int:
        return storage.getInt(name) as T?;

      case double:
        return storage.getDouble(name) as T?;

      case bool:
        return storage.getBool(name) as T?;

      // case List:
      //   return storage.getStringList(name) as T?;

      default:
        throw Exception('[DebugKitPrefStorage.get] Unsupported type: $T');
      // return storage.get(name) as T?;
    }
  }

  Future<void> set<T extends Object?>(String name, T value) async {
    final storage = await prefs;

    final type = value!.runtimeType;
    switch (type) {
      case Offset:
        storage.setString(name, _offsetToString(value as Offset));
        break;

      case String:
        storage.setString(name, value as String);
        break;

      case int:
        storage.setInt(name, value as int);
        break;

      case double:
        storage.setDouble(name, value as double);
        break;

      case bool:
        storage.setBool(name, value as bool);
        break;

      default:
        throw Exception('[DebugKitPrefStorage.set] Unsupported type: $T');
    }
  }

  Offset? _parseOffset(String? value) {
    if (value == null) return null;

    final parts = value.split('|');
    if (parts.length != 2) return null;

    final x = double.tryParse(parts[0]);
    final y = double.tryParse(parts[1]);
    if (x == null || y == null) return null;

    return Offset(x, y);
  }

  String _offsetToString(Offset value) {
    return '${value.dx}|${value.dy}';
  }
}
