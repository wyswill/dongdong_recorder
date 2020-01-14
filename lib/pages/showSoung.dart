import 'package:flutter/material.dart';

import 'mycanvas.dart';

class ShowSoun extends StatefulWidget {
  ShowSoun({this.key}) : super(key: key);
  final key;

  @override
  ShowSounState createState() => ShowSounState();
}

class ShowSounState extends State<ShowSoun> {
  List<double> recrodingData, _cached;
  Offset offset;
  int COLUMNS_COUNT = 50;

  setRecrodingData(List<double> data) {
    setState(() {
      recrodingData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _cached = recrodingData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: CustomPaint(
        painter: MyCanvas(recrodingData),
      ),
    );
  }
}
