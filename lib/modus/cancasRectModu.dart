enum CanvasRectTypes { point, data, flag }

class CanvasRectModu {
  final String timestamp;
  final double vlaue;
  final CanvasRectTypes type;

  CanvasRectModu({this.vlaue, this.type, this.timestamp});

  @override
  String toString() {
    return "index====$timestamp    value====$vlaue  type====$type ";
  }
}
