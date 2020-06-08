import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recriodingTime);

  bool isChanged;

  final double recriodingTime;
  final List<int> canvasData;

  @override
  void paint(Canvas canvas, Size size) {
    print('画了');
    print(recriodingTime);

    /// 每个柱子的宽度
    double columnWidth = 1;

    /// 幅度比例
    double proportion = size.height / 300;

    /// 挨个画频谱柱子
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0;
      int current = canvasData[i];
      volume = current * proportion;
      if (current == 0) continue;
      ///柱子
      Rect column = Rect.fromLTWH((columnWidth + 2) * i, (size.height - volume) / 2, columnWidth.ceil().toDouble(), volume);
      ///波形柱子
      canvas.drawRect(column, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(EditorCanvas oldDelegate) {
    return false;
  }
}
