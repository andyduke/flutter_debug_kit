enum DebugPanelLogLevel {
  info('Info'),
  warning('Warning'),
  error('Error'),
  critical('Critical error'),
  debug('Debug');

  final String name;

  const DebugPanelLogLevel(this.name);

  @override
  String toString() => name;
}

class DebugPanelLogRecord {
  final DebugPanelLogLevel level;
  final String? tag;
  final String message;
  final DateTime time;
  final Object? error;
  final StackTrace? stackTrace;

  DebugPanelLogRecord({
    required this.level,
    this.tag,
    required this.message,
    required this.time,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'DebugPanelLogRecord($level, $message, $time, $error)';
}
