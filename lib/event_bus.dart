import 'package:asdasd/modus/cancasRectModu.dart';
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

class TrashOption {
  TrashOption(this.rm, this.index);

  final RecroderModule rm;
  final int index;
}

class NullEvent {}

class SetCurentTime {
  final CanvasRectModu canvasRectModu;

  SetCurentTime(this.canvasRectModu);
}
