import 'package:debug_kit/debug_kit.dart';
import 'package:debug_kit/src/utils/log_list.dart';

class DebugKitLogHistory extends LogList<DebugKitLogRecord> {
  DebugKitLogHistory({super.maxLength = -1});
}
