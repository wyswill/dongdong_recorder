import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recriodingTime);

  bool isChanged;

  final double recriodingTime;
  final List<int> canvasData;

  @override
  void paint(Canvas canvas, Size size) {
    /// 每个柱子的宽度
    double columnWidth = 1;
    Paint p = Paint()..color = Colors.white;

    /// 幅度比例
    double proportion = size.height / 600;

    /// 挨个画频谱柱子
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0;
      int current = canvasData[i];
      volume = current * proportion;

      ///柱子
      Rect column = Rect.fromLTWH((columnWidth + 2) * i, (size.height - volume) / 2, columnWidth.ceil().toDouble(), volume);

      ///波形柱子
      canvas.drawRect(column, p);
    }
  }

  @override
  bool shouldRepaint(EditorCanvas oldDelegate) {
    return false;
  }
}
