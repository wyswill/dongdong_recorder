import 'package:flutterapp/canvasData.dart';
import 'package:flutterapp/widgets/editorCanvas.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/timeline.dart';
import 'package:provider/provider.dart';

import 'mycanvas.dart';

class ShowSoun extends StatefulWidget {
  ShowSoun({this.key, this.recriodingTime, this.totalTime, this.isEditor}) : super(key: key);
  final key;
  final double recriodingTime, totalTime;
  final bool isEditor;

  @override
  ShowSounState createState() => ShowSounState();
}

class ShowSounState extends State<ShowSoun> {
  List<int> recrodingData = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: widget.isEditor != null
          ? Consumer<canvasData>(
              builder: (context, conter, child) => CustomPaint(
                foregroundPainter: TimeLine_canvas(conter.data.length, widget.totalTime, conter.scaleNum),
                painter: EditorCanvas(conter.data, widget.recriodingTime),
              ),
            )
          : CustomPaint(
              isComplex: true,
              willChange: true,
              painter: MyCanvas(recrodingData, widget.recriodingTime),
            ),
    );
  }

  ///滑动窗口
  setRecrodingData(List<int> data) {
    setState(() {
      recrodingData = data;
    });
  }
}
