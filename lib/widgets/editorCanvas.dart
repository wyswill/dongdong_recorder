import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recriodingTime);

  bool isChanged;

  final double recriodingTime;
  final List<CanvasRectModu> canvasData;

  @override
  void paint(Canvas canvas, Size size) {
    print('画了');
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Color.fromRGBO(87, 92, 159, 1));

    /// 每个柱子的宽度
    double columnWidth = 1;

    /// 幅度比例
    double proportion = size.height / 300;

    /// 挨个画频谱柱子
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0;
      CanvasRectModu curent = canvasData[i];
      volume = curent.vlaue * proportion;
      ///柱子
      Rect column = Rect.fromLTWH((columnWidth + 2) * i, (size.height - volume) / 2, columnWidth.ceil().toDouble(), volume);

      ///时间轴
      ///Rect timeLine = Rect.fromLTWH((columnWidth + spacing) * i, 0, 1, 10);

      ///波形柱子
      canvas.drawRect(column, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(EditorCanvas oldDelegate) {
    isChanged = oldDelegate.canvasData != canvasData;
    return oldDelegate.canvasData != canvasData;
  }
}
