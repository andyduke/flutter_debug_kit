import 'package:debug_panel/src/pages/log_page/models/log_history.dart';
import 'package:debug_panel/src/pages/log_page/models/log_record.dart';
import 'package:meta/meta.dart';

class DebugPanelLogController {
  @internal
  late final DebugPanelLogHistory history;

  DebugPanelLogController({int maxLength = -1}) {
    history = DebugPanelLogHistory(maxLength: maxLength);
  }

  void debug(String message, {String? tag}) {
    history.add(DebugPanelLogRecord(
      level: DebugPanelLogLevel.debug,
      tag: tag,
      message: message,
      time: DateTime.now(),
    ));
  }

  void criticalError(String message, Object error, {StackTrace? stackTrace, String? tag}) {
    history.add(DebugPanelLogRecord(
      level: DebugPanelLogLevel.critical,
      tag: tag,
      message: message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    ));
  }

  void error(String message, Object error, {StackTrace? stackTrace, String? tag}) {
    history.add(DebugPanelLogRecord(
      level: DebugPanelLogLevel.error,
      tag: tag,
      message: message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    ));
  }

  void warning(String message, {String? tag}) {
    history.add(DebugPanelLogRecord(
      level: DebugPanelLogLevel.warning,
      tag: tag,
      message: message,
      time: DateTime.now(),
    ));
  }

  void info(String message, {String? tag}) {
    history.add(DebugPanelLogRecord(
      level: DebugPanelLogLevel.info,
      tag: tag,
      message: message,
      time: DateTime.now(),
    ));
  }

  void add(DebugPanelLogRecord record) {
    history.add(record);
  }

  void clear() {
    history.clear();
  }
}
