import 'package:flutter/material.dart';
import 'modus/record.dart';

class Modus with ChangeNotifier {
  Map curentPlayRecrofing;
  Map<String, List<RecroderModule>> recroderFiles = {};

  void addRecrodItem(String attr, RecroderModule rm) {
    if (recroderFiles[attr] == null) {
      recroderFiles[attr] = [rm];
      notifyListeners();
    } else {
      bool flag = recroderFiles[attr].any((ele) => ele.title == rm.title);
      if (!flag) recroderFiles[attr].add(rm);
    }
  }

  void changeState(String attr, int index) {
    if (!recroderFiles[attr][index].isActive) {
      recroderFiles[attr].forEach((element) {
        element.isActive = false;
      });
      recroderFiles[attr][index].isActive = true;
      notifyListeners();
    }
  }

  RecroderModule deleteFile(String attr, int index) {
    RecroderModule rm = recroderFiles[attr][index];
    rm.reset();
    recroderFiles[attr].removeAt(index);
    notifyListeners();
    return rm;
  }
}
