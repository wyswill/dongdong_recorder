import 'package:asdasd/event_bus.dart';
import 'package:asdasd/modus/cancasRectModu.dart';
import 'package:asdasd/utiles.dart';
import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recriodingTime);

  final double recriodingTime;
  final List<CanvasRectModu> canvasData;
  int columns_count = 120;

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Color.fromRGBO(87, 92, 159, 1));
    final double middleWidth = size.width / 2;

    /// 每个柱子的宽度
    double columnWidth = 2;

    /// 幅度比例
    double step = size.height / 300;

    ///计算时间轴跨度
    double preMs = 25, spacing = size.width / preMs;

    /// 挨个画频谱柱子
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0;
      CanvasRectModu curent = canvasData[i];
      volume = curent.vlaue * step;

      if (curent.type == CanvasRectTypes.data) {
        if (canvasData.length / 2 == i) {
          eventBus.fire(SetTimestamp(curent.timestamp));
        }
      }

      ///柱子
      Rect column = Rect.fromLTWH((columnWidth + 2) * i,
          (size.height - volume) / 2, columnWidth.ceil().toDouble(), volume);

      ///时间轴
      Rect timeLine = Rect.fromLTWH((columnWidth + spacing) * i, 0, 1, 10);

      ///指针
      Rect pointLine = Rect.fromLTWH(middleWidth, 0, 2, size.height);

      ///画指针的圆点
      canvas.drawCircle(Offset(middleWidth, 0), 8, Paint()..color = Colors.red);
      canvas.drawCircle(
          Offset(middleWidth, size.height), 8, Paint()..color = Colors.red);

      ///波形柱子
      canvas.drawRect(column, Paint()..color = Colors.white);

      ///时间轴
      canvas.drawRect(timeLine, Paint()..color = Colors.white);

      ///指针
      canvas.drawRect(pointLine, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
