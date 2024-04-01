enum DebugKitLogLevel {
  info('Info'),
  warning('Warning'),
  error('Error'),
  critical('Critical error'),
  debug('Debug');

  final String name;

  const DebugKitLogLevel(this.name);

  @override
  String toString() => name;
}

class DebugKitLogRecord {
  final DebugKitLogLevel level;
  final String? tag;
  final String message;
  final DateTime time;
  final Object? error;
  final StackTrace? stackTrace;

  DebugKitLogRecord({
    required this.level,
    this.tag,
    required this.message,
    required this.time,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => 'DebugKitLogRecord($level, $message, $time, $error)';
}
