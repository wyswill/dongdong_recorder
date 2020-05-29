import 'package:flutter/cupertino.dart';

import 'modus/record.dart';

class transhProvider with ChangeNotifier {
  List<RecroderModule> trashs = [];
  int preIndex = null;

  void init(List<RecroderModule> data) {
    trashs = data;
    notifyListeners();
  }

  void trashSwitchState(int index) {
    if (preIndex != null) trashs[preIndex].isActive = !trashs[preIndex].isActive;
    trashs[index].isActive = !trashs[index].isActive;
    preIndex = index;
    notifyListeners();
  }

  void remove(int index){
    trashs.removeAt(index);
    notifyListeners();
  }
}
