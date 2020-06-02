import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:event_bus/event_bus.dart';

import 'modus/record.dart';

EventBus eventBus = EventBus();

class PlayingFile {
  PlayingFile(this.file);

  final RecroderModule file;
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

class TrashDeleted {
  TrashDeleted({this.index});

  final int index;
}

class NullEvent {}

class SetCurentTime {
  final CanvasRectModu canvasRectModu;

  SetCurentTime(this.canvasRectModu);
}
