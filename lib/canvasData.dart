import 'package:flutter/material.dart';
class canvasData with ChangeNotifier {
  List<int> data = [];

  setData(List<int> val) {
    data = val;
    notifyListeners();
  }
}
