import 'package:flutter/material.dart';

import 'mycanvas.dart';

class ShowSoun extends StatefulWidget {
  ShowSoun({this.key, this.recriodingTime}) : super(key: key);
  final key;
  final double recriodingTime;

  @override
  ShowSounState createState() => ShowSounState();
}

class ShowSounState extends State<ShowSoun> {
  List<double> recrodingData, cached;
  Offset offset;

  setRecrodingData(List<double> data) {
    setState(() {
      recrodingData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    cached = recrodingData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: CustomPaint(
        painter: MyCanvas(recrodingData, widget.recriodingTime),
      ),
    );
  }
}
