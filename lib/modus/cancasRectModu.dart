enum CanvasRectTypes { point, data, start, end }

class CanvasRectModu {
  final String timestamp;
  final double vlaue;
  final int ms;
  CanvasRectTypes type;
  int index;

  CanvasRectModu({this.vlaue, this.type, this.timestamp, this.index, this.ms});

  @override
  String toString() {
    return "timestamp====$timestamp    value====$vlaue  type====$type  index====$index ms====$ms";
  }
}
