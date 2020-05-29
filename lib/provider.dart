import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/utiles.dart';
import 'modus/record.dart';

class recrodListProvider with ChangeNotifier {
  List<RecroderModule> recroderFiles = [];

  void init(List<RecroderModule> data) {
    recroderFiles = data;
    notifyListeners();
  }

  void addRecrodItem(RecroderModule rm) {
    recroderFiles.add(rm);
    notifyListeners();
  }

  void changeState(int index) {
    if (!recroderFiles[index].isActive) {
      recroderFiles.forEach((element) {
        element.isActive = false;
      });
      recroderFiles[index].isActive = true;
      notifyListeners();
    }
  }

  Future<RecroderModule> deleteFile(int index) async {
    String deletePath = await FileUtile.getRecrodPath(isDelete: true);
    RecroderModule rm = recroderFiles[index];
    File file = File(rm.filepath);
    file.copySync('$deletePath${rm.title}.wav');
    file.deleteSync();
    rm.reset();
    recroderFiles.removeAt(index);
    notifyListeners();
    return rm;
  }
}
