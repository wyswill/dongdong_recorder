import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recordingTime);

  bool isChanged;

  final double recordingTime;
  final List<List<int>> canvasData;

  @override
  void paint(Canvas canvas, Size size) {
    /// 每个柱子的宽度
    double columnWidth = 1;
    Paint p = Paint()..color = Colors.white;
    canvas.translate(size.width / 13, 0);

    /// 挨个画频谱柱子
    double left = 0;
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0;
      List<int> current = canvasData[i];
      volume = (current[0] + current[1]) * 0.01;
      if (volume > size.height) volume = size.height - 250;
      double heigh = (size.height - volume) / 2;

      ///柱子
      Rect column = Rect.fromLTWH(left, heigh, columnWidth, volume);
      left += 1;

      ///波形柱子
      canvas.drawRect(column, p);
    }
  }

  @override
  bool shouldRepaint(EditorCanvas oldDelegate) {
    return false;
  }
}
