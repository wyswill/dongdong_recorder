import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recriodingTime);
  final double recriodingTime;
  final List<double> canvasData;
  int columns_count = 120;
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Color.fromRGBO(87, 92, 159, 1));
    // 每个柱子的宽度
    double columnWidth = 2;
    // 幅度比例
    double step = size.height / 300;
    // 挨个画频谱柱子
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0;
      volume = canvasData[i] * step;
      Rect column = Rect.fromLTWH(columnWidth * i, (size.height - volume) / 2,
          columnWidth.ceil().toDouble(), volume);
      volume = canvasData[i] * step;
      canvas.drawRect(column, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
