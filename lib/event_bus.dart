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
