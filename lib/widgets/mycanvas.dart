import 'package:flutter/material.dart';

class MyCanvas extends CustomPainter {
  MyCanvas(this.canvasData, this.recriodingTime);

  final double recriodingTime;
  final List<double> canvasData;

  int columns_count = 120;

  @override
  void paint(Canvas canvas, Size size) {
    init(canvas, size);
  }

  void init(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Color.fromRGBO(87, 92, 159, 1));
    // 每个柱子的宽度
    double columnWidth = (size.width / columns_count);
    // 幅度比例
    double step = size.height / 250;
    // 挨个画频谱柱子
    if (canvasData != null) {
      for (int i = 0; i < canvasData.length; i++) {
        double volume = 2.0;
        if (i % 2 == 0) continue;
        volume = canvasData[i] * step;
        Rect column = Rect.fromLTWH((columnWidth * i),
            (size.height - volume) / 2, columnWidth.ceil().toDouble(), volume);
        canvas.save();
        canvas.drawRect(column, Paint()..color = Colors.white);
        canvas.restore();
      }
    } else {
      for (int i = 0; i < columns_count; i++) {
        double volume = 2.0;
        if (i % 2 == 0) continue;
        Rect column = Rect.fromLTWH((columnWidth * i),
            (size.height - volume) / 2, columnWidth.ceil().toDouble(), volume);
        canvas.save();
        canvas.drawRect(column, Paint()..color = Colors.white);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(MyCanvas oldDelegate) {
    return oldDelegate.canvasData != canvasData;
  }
}
