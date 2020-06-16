import 'package:flutter/material.dart';

class canvasData with ChangeNotifier {
  List<List<int>> data = [];
  int scaleNum;

  setScaleNum(int num) {
    scaleNum = num;
    notifyListeners();
  }

  setData(List<List<int>> val) {
    data = val;
    notifyListeners();
  }
}
