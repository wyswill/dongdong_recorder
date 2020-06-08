import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLine_canvas extends CustomPainter {
  TimeLine_canvas(this.recriodingTime);

  final double recriodingTime;

  @override
  void paint(Canvas canvas, Size size) {
    /// 每个柱子的宽度
    double columnWidth = (size.width / recriodingTime) * 500;
    int totalWidth = (recriodingTime / columnWidth).floor();

    /// 挨个画频谱柱子
    for (int i = 0; i < totalWidth; i++) {
      ///时间轴
      Rect timeLine = Rect.fromLTWH((columnWidth + 2) * i, 0, 1, 10);
      canvas.drawRect(timeLine, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
