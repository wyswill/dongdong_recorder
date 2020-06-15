import 'package:flutter/material.dart';

class MyCanvas extends CustomPainter {
  MyCanvas(this.canvasData, this.recriodingTime);

  final double recriodingTime;
  final List<int> canvasData;

  @override
  void paint(Canvas canvas, Size size) {
    init(canvas, size);
  }

  void init(Canvas canvas, Size size) {
    // 每个柱子的宽度
    double columnWidth = 2;
    // 挨个画频谱柱子
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0, top;
      int curent = canvasData[i];
      volume = curent.truncateToDouble() - 100;
      if (volume <= 0) volume = 2;
      top = (size.height - volume) / 2;
      Rect column = Rect.fromLTWH((columnWidth + 1) * i, top, columnWidth.roundToDouble(), volume);
      canvas.drawRect(column, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(MyCanvas oldDelegate) {
    return true;
  }
}
