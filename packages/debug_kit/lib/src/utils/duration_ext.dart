extension DurationUtils on Duration {
  format() {
    if (inDays > 0) {
      return '$inDays d, $inHours h, $inMinutes m';
    } else if (inHours > 0) {
      return '$inHours h, $inMinutes m';
    } else if (inMinutes > 0) {
      return '$inMinutes m';
    } else if (inSeconds > 0) {
      return '$inSeconds s';
    } else if (inMilliseconds > 0) {
      return '$inMilliseconds ms';
    } else {
      return '$inMilliseconds.$inMicroseconds ms';
    }
  }
}
