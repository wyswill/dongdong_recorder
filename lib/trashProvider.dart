import 'package:flutter/cupertino.dart';

import 'modus/record.dart';

class transhProvider with ChangeNotifier {
  List<RecroderModule> trashs = [];

  void init(List<RecroderModule> data) {
    trashs = data;
    notifyListeners();
  }

  void trashSwitchState(RecroderModule rm, int index) {
    trashs.forEach((element) {
      element.isActive = false;
    });
    trashs[index].isActive = !trashs[index].isActive;
    notifyListeners();
  }
}