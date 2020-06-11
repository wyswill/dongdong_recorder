import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    ///每毫秒的间隔
    double singlesw = datalength / 12;

    ///每秒宽度
    double sw = datalength / s;

    ///每一百毫秒的宽度
    double msw = sw / 10;
    print(sw);
    print(msw);
    canvas.translate(singlesw, 0);
    for (int i = 0; i <= s; i++) {
      Rect timeLine = Rect.fromLTWH((sw * i).toDouble(), 0, 0.5, 10);
      canvas.drawRect(timeLine, write);
    }
//      if (i % 10 == 0) {
//        canvas.drawRect(timeLine, write);
////        int currentMs = (i).truncate();
////        drawText(currentMs, Offset((sw * i).toDouble(), 20), pb, canvas);
//      } else {
//        timeLine = Rect.fromLTWH((sw * i).toDouble(), 0, 1, 10);
//        canvas.drawRect(timeLine, gary);
//      }
//    }
  }

  drawText(int currentMs, Offset offset, ParagraphBuilder pb, Canvas canvas) {
    String s = format(Duration(milliseconds: currentMs));
    pb.addText(s);
    ParagraphConstraints pc = ParagraphConstraints(width: 25);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, offset);
  }

  String format(Duration duration) {
    if (duration.inMinutes < 1) return '${duration.inSeconds}.${duration.inMilliseconds % 1000}';
    if (duration.inHours < 1) return '${duration.inMinutes}:${duration.inSeconds}';
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
