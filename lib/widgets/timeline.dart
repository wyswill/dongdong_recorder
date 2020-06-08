import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLine_canvas extends CustomPainter {
  TimeLine_canvas(this.interval, this.totaltime);

  final double interval, totaltime;

  @override
  void paint(Canvas canvas, Size size) {
    double clomeWidth = 30;
    Paint gary = Paint()..color = Colors.grey,
        write = Paint()..color = Colors.white;

    /// 每个柱子的宽度
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.left, // 对齐方式
      fontWeight: FontWeight.w600, // 粗体
      fontStyle: FontStyle.normal, // 正常 or 斜体
      fontSize: 7,
    ));
    int time = 0;
    double jiange = totaltime / 10;

    /// 挨个画频谱柱子
    for (int i = 0; i < 13; i++) {
      ///时间轴
      Rect timeLine = Rect.fromLTWH((clomeWidth * i).toDouble(), 0, 1, 15);
      if (i % 2 != 0)
        canvas.drawRect(timeLine, write);
      else {
        timeLine = Rect.fromLTWH((clomeWidth * i).toDouble(), 0, 1, 10);
        canvas.drawRect(timeLine, gary);
      }
      if (i == 12) {
        continue;
      }
      String s = format(Duration(milliseconds: time));
      time += jiange.floor();
//      print(s);
      pb.addText(s);
      ParagraphConstraints pc = ParagraphConstraints(width: 50);
      Paragraph paragraph = pb.build()..layout(pc);
      canvas.drawParagraph(
          paragraph, Offset((clomeWidth * i + 20).toDouble(), 20));
    }
  }

  String format(Duration duration) {
    if(duration.inSeconds>1)return '${duration.inHours}:${duration.inMinutes.floor()}:${duration.inSeconds}';
    else return '${duration.inMinutes.floor()}:${duration.inSeconds}:${duration.inMilliseconds % 1000}';
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
