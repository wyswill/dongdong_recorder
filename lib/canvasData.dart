import 'package:flutter/material.dart';

class canvasData with ChangeNotifier {
  List<List<int>> data = [];

  setData(List<List<int>> val) {
    data = val;
    notifyListeners();
  }
}
