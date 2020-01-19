import 'package:flutter/material.dart';

import 'mycanvas.dart';

class ShowSoun extends StatefulWidget {
  ShowSoun({this.key, this.recriodingTime}) : super(key: key);
  final key;
  final double recriodingTime;

  @override
  ShowSounState createState() => ShowSounState();
}

class ShowSounState extends State<ShowSoun>
    with SingleTickerProviderStateMixin {
  List<double> recrodingData = [];
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
      child:
          CustomPaint(painter: MyCanvas(recrodingData, widget.recriodingTime)),
    );
  }

  ///滑动窗口
  setRecrodingData(List<double> data) {
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
