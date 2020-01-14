import 'package:flutter/material.dart';

class MyCanvas extends CustomPainter {
  MyCanvas(this.canvasData);

  final List<double> canvasData;

  // ignore: non_constant_identifier_names
  int columns_count = 60;

  @override
  void paint(Canvas canvas, Size size) {
    init(canvas, size);
  }

  void init(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Colors.blueGrey);
    // 给个好看的颜色
    LinearGradient gradient = LinearGradient(colors: [
      Color.fromRGBO(108, 86, 123, 1),
      Color.fromRGBO(248, 177, 149, 1)
    ], begin: Alignment.bottomCenter, end: Alignment.topCenter);
    // 每个柱子的宽度
    double columnWidth = size.width / columns_count;
    // 幅度比例
    double step = size.height / 250;
    // 挨个画频谱柱子
    for (int i = 0; i < columns_count; i++) {
      double volume = 2.0;
      if (canvasData != null) {
        volume = canvasData[i] * step;
      }
      Rect column = Rect.fromLTWH(
          columnWidth * i, size.height - volume, columnWidth - 10, volume);
      canvas.save();
      canvas.drawRect(column, Paint()..shader = gradient.createShader(column));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(MyCanvas oldDelegate) {
    return oldDelegate.canvasData != canvasData;
  }
}
