enum CanvasRectTypes { point, data, start, end }

class CanvasRectModu {
  final String timestamp;
  final double vlaue;
  CanvasRectTypes type;
  int index;

  CanvasRectModu({this.vlaue, this.type, this.timestamp, this.index});

  @override
  String toString() {
    return "timestamp====$timestamp    value====$vlaue  type====$type  index====$index";
  }
}
