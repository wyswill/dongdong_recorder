import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utiles.dart';

class TimeLine_canvas extends CustomPainter {
  TimeLine_canvas(this.datalength, this.totaltime);

  final double totaltime;
  final int datalength;

  @override
  void paint(Canvas canvas, Size size) {
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.left, // 对齐方式
      fontWeight: FontWeight.normal, // 粗体
      fontStyle: FontStyle.normal, // 正常 or 斜体
      fontSize: 6,
    ));
    Paint gary = Paint()..color = Colors.grey, write = Paint()..color = Colors.white;

    ///秒数
    int s = (totaltime / 1000).truncate();
    double totlecount = totaltime / 1000;

    ///起始偏移
    double singlesw = datalength / 12;

    ///每秒宽度
    double sw = datalength / s;
    canvas.translate(singlesw, 0);
    bool printT = s > 10 ? true : false;
    for (int i = 0; i <= totlecount; i++) {
      if (i % 10 == 0) {
        Rect timeLine = Rect.fromLTWH((sw * i).toDouble(), 0, 0.5, 15);
        canvas.drawRect(timeLine, write);
        if (printT) drawText(i, Offset((sw * i).toDouble(), 20), pb, canvas);
      } else {
        Rect timeLine = Rect.fromLTWH((sw * i).toDouble(), 0, 0.5, 10);
        canvas.drawRect(timeLine, gary);
        if (!printT) drawText(i, Offset((sw * i).toDouble(), 20), pb, canvas);
      }
    }
  }

  drawText(int currents, Offset offset, ParagraphBuilder pb, Canvas canvas) {
    String s = formatTime(currents);
    pb.addText(s);
    ParagraphConstraints pc = ParagraphConstraints(width: 25);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
