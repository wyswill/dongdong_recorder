import 'package:event_bus/event_bus.dart';

import 'modus/record.dart';

EventBus eventBus = EventBus();

class PlayingFile {
  PlayingFile(this.file);

  final RecroderModule file;
}

class PlayingState {
  PlayingState(this.state);

  final bool state;
}

class DeleteFileSync {
  DeleteFileSync({this.index, this.attr});

  final int index;
  final String attr;
}

class Trash_option {
  Trash_option(this.rm, this.index);

  final RecroderModule rm;
  final int index;
}

class NullEvent {}

class SetTimestamp {
  final String timestamp;

  SetTimestamp(this.timestamp);
}
