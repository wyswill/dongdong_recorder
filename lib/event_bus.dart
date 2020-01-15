import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class PlayingFile {
  PlayingFile(this.file);
  final Map file;
}

class PlayingState {
  PlayingState(this.state);
  final bool state;
}
