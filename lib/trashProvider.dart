import 'package:flutter/cupertino.dart';

import 'modus/record.dart';

class TranshProvider with ChangeNotifier {
  List<RecroderModule> trashs = [];
  int preIndex;

  void reset() {
    trashs.forEach((element) {
      element.isActive = false;
    });
    preIndex = null;
  }

  void init(List<RecroderModule> data) {
    trashs = data;
    notifyListeners();
  }

  void trashSwitchState(int index) {
    if (preIndex != null) trashs[preIndex].isActive = false;
    trashs[index].isActive = true;
    preIndex = index;
    notifyListeners();
  }

  void remove(int index) {
    reset();
    trashs.removeAt(index);
    notifyListeners();
  }
}
