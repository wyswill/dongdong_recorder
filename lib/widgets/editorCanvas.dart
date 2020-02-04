import 'package:flutter/material.dart';

class EditorCanvas extends CustomPainter {
  EditorCanvas(this.canvasData, this.recriodingTime);
  final double recriodingTime;
  final List<double> canvasData;
  int columns_count = 120;
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = Color.fromRGBO(87, 92, 159, 1));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
