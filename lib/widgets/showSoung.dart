import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:flutterapp/widgets/editorCanvas.dart';
import 'package:flutter/material.dart';

import 'mycanvas.dart';

class ShowSoun extends StatefulWidget {
  ShowSoun({this.key, this.recriodingTime, this.isEditor}) : super(key: key);
  final key;
  final double recriodingTime;
  final bool isEditor;

  @override
  ShowSounState createState() => ShowSounState();
}

class ShowSounState extends State<ShowSoun>
    with SingleTickerProviderStateMixin {
  List<CanvasRectModu> recrodingData = [];
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: CustomPaint(
        painter: widget.isEditor != null
            ? EditorCanvas(recrodingData, widget.recriodingTime)
            : MyCanvas(recrodingData, widget.recriodingTime),
      ),
    );
  }

  ///滑动窗口
  setRecrodingData(List<CanvasRectModu> data) {
    setState(() {
      recrodingData = data;
      controller.forward();
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
