import 'package:flutterapp/canvasData.dart';
import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:flutterapp/widgets/editorCanvas.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/timeline.dart';
import 'package:provider/provider.dart';

import 'mycanvas.dart';

class ShowSoun extends StatefulWidget {
  ShowSoun({this.key, this.recriodingTime, this.isEditor}) : super(key: key);
  final key;
  final double recriodingTime;
  final bool isEditor;

  @override
  ShowSounState createState() => ShowSounState();
}

class ShowSounState extends State<ShowSoun> {
  List<CanvasRectModu> recrodingData = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: widget.isEditor != null
          ? Consumer<canvasData>(
              builder: (context, conter, child) => CustomPaint(
                foregroundPainter: TimeLine_canvas(widget.recriodingTime),
                painter: EditorCanvas(conter.data, widget.recriodingTime),
              ),
            )
          : CustomPaint(
              isComplex: true,
              painter: MyCanvas(recrodingData, widget.recriodingTime),
            ),
    );
  }

  ///滑动窗口
  setRecrodingData(List<CanvasRectModu> data) {
    setState(() {
      recrodingData = data;
    });
  }

  ///录音实时数据
  double curentHeight = 0;

  setRecrodingSingledata(double data) {
    setState(() {
      curentHeight = data;
    });
  }
}
