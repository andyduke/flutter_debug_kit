import 'package:debug_kit/src/pages/log_page/models/log_history.dart';
import 'package:debug_kit/src/pages/log_page/models/log_record.dart';
import 'package:meta/meta.dart';

class DebugKitLogController {
  @internal
  late final DebugKitLogHistory history;

  DebugKitLogController({int maxLength = -1}) {
    history = DebugKitLogHistory(maxLength: maxLength);
  }

  void debug(String message, {String? tag}) {
    history.add(DebugKitLogRecord(
      level: DebugKitLogLevel.debug,
      tag: tag,
      message: message,
      time: DateTime.now(),
    ));
  }

  void criticalError(String message, Object error, {StackTrace? stackTrace, String? tag}) {
    history.add(DebugKitLogRecord(
      level: DebugKitLogLevel.critical,
      tag: tag,
      message: message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    ));
  }

  void error(String message, Object error, {StackTrace? stackTrace, String? tag}) {
    history.add(DebugKitLogRecord(
      level: DebugKitLogLevel.error,
      tag: tag,
      message: message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    ));
  }

  void warning(String message, {String? tag}) {
    history.add(DebugKitLogRecord(
      level: DebugKitLogLevel.warning,
      tag: tag,
      message: message,
      time: DateTime.now(),
    ));
  }

  void info(String message, {String? tag}) {
    history.add(DebugKitLogRecord(
      level: DebugKitLogLevel.info,
      tag: tag,
      message: message,
      time: DateTime.now(),
    ));
  }

  void add(DebugKitLogRecord record) {
    history.add(record);
  }

  void clear() {
    history.clear();
  }
}
