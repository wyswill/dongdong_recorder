import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/utiles.dart';
import 'modus/record.dart';

class recrodListProvider with ChangeNotifier {
  List<RecroderModule> recroderFiles = [];
  int preIndex = null;

  void reset({bool isNoti = false}) {
    recroderFiles.forEach((element) {
      element.isActive = false;
    });
    preIndex = null;
    if (isNoti) notifyListeners();
  }

  void init(List<RecroderModule> data) {
    recroderFiles = data;
    preIndex = null;
    notifyListeners();
  }

  void addRecrodItem(RecroderModule rm) {
    recroderFiles.add(rm);
    notifyListeners();
  }

  void changeState(int index) {
    if (preIndex != null) recroderFiles[preIndex].isActive = !recroderFiles[preIndex].isActive;
    recroderFiles[index].isActive = !recroderFiles[index].isActive;
    preIndex = index;
    notifyListeners();
  }

  Future<RecroderModule> deleteFile(int index) async {
    String deletePath = await FileUtile.getRecrodPath(isDelete: true);
    RecroderModule rm = recroderFiles[index];
    File file = File(rm.filepath);
    file.copySync('$deletePath${rm.title}.wav');
    file.deleteSync();
    rm.reset();
    recroderFiles.removeAt(index);
    rm.filepath = '$deletePath${rm.title}.wav';
    notifyListeners();
    return rm;
  }

  void changeRM(String title, String path, int index) {
    recroderFiles[index].title = title;
    recroderFiles[index].filepath = path;
    notifyListeners();
  }

  void reName({int inidex, String newName}) async {
    RecroderModule rm = recroderFiles[inidex];
    String newTime = FileUtile.timeFromate(DateTime.now()), newPath = '${await FileUtile.getRecrodPath()}$newName.wav';
    rm.title = newName;
    rm.lastModified = newTime;
    File file = File(rm.filepath), newFile = file.renameSync(newPath);
    notifyListeners();
  }
}
