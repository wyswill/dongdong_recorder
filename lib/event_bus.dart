import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:event_bus/event_bus.dart';

import 'modus/record.dart';

EventBus eventBus = EventBus();

class PlayingFile {
  PlayingFile(this.file, this.index);

  final RecroderModule file;
  final int index;
}

class TrashOption {
  TrashOption(this.rm, this.index);

  final RecroderModule rm;
  final int index;
}


class NullEvent {}

