import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLine_canvas extends CustomPainter {
  TimeLine_canvas(this.recriodingTime);

  final double recriodingTime;

  @override
  void paint(Canvas canvas, Size size) {
    double clomeWidth = 20;
    /// 每个柱子的宽度
    int totalWidth = (size.width / clomeWidth).floor();

    /// 挨个画频谱柱子
    for (int i = 0; i < totalWidth; i++) {
      ///时间轴
      Rect timeLine = Rect.fromLTWH((clomeWidth * i).toDouble(), 0, 1, 10);
      canvas.drawRect(timeLine, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
