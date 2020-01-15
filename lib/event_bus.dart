import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class PlayingFile {
  PlayingFile(this.file);
  Map file;
}
