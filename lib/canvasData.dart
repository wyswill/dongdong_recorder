import 'package:flutter/material.dart';

class canvasData with ChangeNotifier {
  List<List<double>> data = [];

  setData(List<List<double>> val) {
    data = val;
    notifyListeners();
  }
}
