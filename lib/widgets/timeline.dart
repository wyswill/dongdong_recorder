import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utiles.dart';

class TimeLine_canvas extends CustomPainter {
  TimeLine_canvas(this.datalength, this.totaltime, this.scaleNum);

  final double totaltime;
  final int datalength;
  int scaleNum;

  @override
  void paint(Canvas canvas, Size size) {
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.left, // 对齐方式
      fontWeight: FontWeight.normal, // 粗体
      fontStyle: FontStyle.normal, // 正常 or 斜体
      fontSize: 6,
    ));
    Paint gary = Paint()..color = Colors.grey, write = Paint()..color = Colors.white;
//    scale(scaleNum, size.width);

    ///秒数
    int s = (totaltime / 1000).truncate();
    double totlecount = totaltime / 1000;

    ///起始偏移
    double singlesw = size.width / 14;

    ///每秒宽度
    double sw = datalength / s;
    canvas.translate(singlesw, 0);
    for (int i = 0; i <= totlecount; i++) {
      if (i % 10 == 0) {
        Rect timeLine = Rect.fromLTWH((sw * i).toDouble(), 0, 0.5, 15);
        canvas.drawRect(timeLine, write);
        drawText(i, Offset((sw * i).toDouble(), 22), pb, canvas);
      } else {
        Rect timeLine = Rect.fromLTWH((sw * i).toDouble(), 0, 0.5, 10);
        canvas.drawRect(timeLine, gary);
        if (s < 50) drawText(i, Offset((sw * i).toDouble(), 13), pb, canvas);
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

  ///接收缩放系数，根据缩放系数计算时间轴
  ///默认系数为1
  ///大轴和小轴的关系：大轴间隔的1/5是小轴的间隔
  ///屏幕宽度 375
  ///缩放系数 [1-3] default = 1
  scale(int scaleNum, double sw) {
    double maxC = sw / 250 * scaleNum;
    double minC = maxC / 5 * scaleNum;
//    print('$maxC   $minC');
  }

  @override
  bool shouldRepaint(TimeLine_canvas oldDelegate) {
    return scaleNum == oldDelegate.scaleNum;
  }
}
