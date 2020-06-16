import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/utiles.dart';
import 'modus/record.dart';

class RecordListProvider with ChangeNotifier {
  List<RecroderModule> recorderFiles = [];
  int preIndex;

  void reset({bool isNoti = false}) {
    recorderFiles.forEach((element) {
      element.isActive = false;
    });
    preIndex = null;
    if (isNoti) notifyListeners();
  }

  void init(List<RecroderModule> data) {
    recorderFiles = data;
    preIndex = null;
    notifyListeners();
  }

  void addRecrodItem(RecroderModule rm) {
    recorderFiles.add(rm);
    notifyListeners();
  }


  void changeState(int index) {
    if (preIndex != null) recorderFiles[preIndex].isActive = !recorderFiles[preIndex].isActive;
    recorderFiles[index].isActive = !recorderFiles[index].isActive;
    preIndex = index;
    notifyListeners();
  }

  Future<RecroderModule> deleteFile(int index) async {
    reset();
    String deletePath = await FileUtile.getRecrodPath(isDelete: true);
    RecroderModule rm = recorderFiles[index];
    File file = File(rm.filepath);
    file.copySync('$deletePath${rm.title}.wav');
    file.deleteSync();
    rm.reset();
    recorderFiles.removeAt(index);
    rm.filepath = '$deletePath${rm.title}.wav';
    notifyListeners();
    return rm;
  }

  void changeRM(String title, String path, int index) {
    recorderFiles[index].title = title;
    recorderFiles[index].filepath = path;
    notifyListeners();
  }

  void reName({int index, String newName}) async {
    RecroderModule rm = recorderFiles[index];
    String newTime = FileUtile.timeFromate(DateTime.now()), newPath = '${await FileUtile.getRecrodPath()}$newName.wav';
    rm.title = newName;
    rm.lastModified = newTime;
    File file = File(rm.filepath), newFile = file.renameSync(newPath);
    rm.filepath = newPath;
    notifyListeners();
  }
}
