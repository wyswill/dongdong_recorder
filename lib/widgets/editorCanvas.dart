import 'package:asdasd/event_bus.dart';
import 'package:asdasd/modus/cancasRectModu.dart';
import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recriodingTime);

  final double recriodingTime;
  final List<CanvasRectModu> canvasData;

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
    double preMs = 25;

    /// 挨个画频谱柱子
    for (int i = 0; i < canvasData.length; i++) {
      double volume = 2.0;
      CanvasRectModu curent = canvasData[i];
      volume = curent.vlaue * step;

      ///柱子
      Rect column = Rect.fromLTWH((columnWidth + 2) * i,
          (size.height - volume) / 2, columnWidth.ceil().toDouble(), volume);

      ///时间轴
//      Rect timeLine = Rect.fromLTWH((columnWidth + spacing) * i, 0, 1, 10);

      ///指针
      Rect pointLine = Rect.fromLTWH(middleWidth, 0, 2, size.height);

      ///画指针的圆点
      canvas.drawCircle(Offset(middleWidth, 0), 8, Paint()..color = Colors.red);
      canvas.drawCircle(
          Offset(middleWidth, size.height), 8, Paint()..color = Colors.red);
      canvas.drawRect(pointLine, Paint()..color = Colors.red);
      // canvas.drawRect(timeLine, Paint()..color = Colors.white);

      ///波形柱子
      switch (curent.type) {
        case CanvasRectTypes.data:
          canvas.drawRect(column, Paint()..color = Colors.white);
          break;
        case CanvasRectTypes.start:
          Rect startFlag = Rect.fromLTWH(
            (columnWidth + 2) * i,
            0,
            columnWidth.ceil().toDouble(),
            size.height,
          );
          canvas.drawRect(startFlag, Paint()..color = Colors.yellow);
          break;
        case CanvasRectTypes.end:
          Rect endFlag = Rect.fromLTWH(
            (columnWidth + 2) * i,
            0,
            columnWidth.ceil().toDouble(),
            size.height,
          );
          canvas.drawRect(endFlag, Paint()..color = Colors.red);
          break;
        default:
      }
      if (curent.type == CanvasRectTypes.data) {
        if (i == canvasData.length / 2) {
          curent.index = i;
          eventBus.fire(SetCurentTime(curent));
        }
      }
    }
  }

  @override
  bool shouldRepaint(EditorCanvas oldDelegate) {
    return oldDelegate.canvasData != canvasData;
  }
}
