import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLine_canvas extends CustomPainter {
  TimeLine_canvas(this.interval);

  final double interval;

  @override
  void paint(Canvas canvas, Size size) {
    double clomeWidth = 30;
    Paint gary = Paint()..color = Colors.grey, write = Paint()..color = Colors.white;
    TextStyle style = TextStyle(color: Colors.black);

    /// 每个柱子的宽度
    int totalWidth = (size.width / clomeWidth).floor();
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.left, // 对齐方式
      fontWeight: FontWeight.w600, // 粗体
      fontStyle: FontStyle.normal, // 正常 or 斜体
      fontSize: 5,
    ));
    int time = 0;
    print(interval);

    /// 挨个画频谱柱子
    for (int i = 0; i < interval; i++) {
      ///时间轴
      Rect timeLine = Rect.fromLTWH((clomeWidth * i).toDouble(), 0, 1, 15);
      if (i % 2 != 0) {
        timeLine = Rect.fromLTWH((clomeWidth * i).toDouble(), 0, 1, 10);
        canvas.drawRect(timeLine, gary);
      } else
        canvas.drawRect(timeLine, write);
      String s = format(Duration(milliseconds: time));
      print(s);
      pb.addText(s);
      time += 500;
      ParagraphConstraints pc = ParagraphConstraints(width: 50);
      Paragraph paragraph = pb.build()..layout(pc);
      canvas.drawParagraph(paragraph, Offset((clomeWidth * i).toDouble(), 20));
    }
  }

  String format(Duration duration) {
    return '${duration.inHours}:${duration.inMinutes.floor()}:${duration.inSeconds}:${duration.inMilliseconds % 1000}';
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
