import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'modus/record.dart';

alert(
  BuildContext context, {
  Widget title,
  EdgeInsetsGeometry titlePadding,
  TextStyle titleTextStyle,
  Widget content,
  EdgeInsetsGeometry contentPadding =
      const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
  TextStyle contentTextStyle,
  List<Widget> actions,
  Color backgroundColor,
  double elevation,
  String semanticLabel,
  ShapeBorder shape,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
        content: content,
        contentPadding: contentPadding,
        contentTextStyle: contentTextStyle,
        actions: actions,
        backgroundColor: backgroundColor,
        elevation: elevation,
        semanticLabel: semanticLabel,
        shape: shape,
      );
    },
  );
}

formatTime(int totalTime) {
  Duration d = Duration(milliseconds: totalTime);
  return "${d.inHours}:${d.inMinutes}:${d.inSeconds}";
}

class FileUtile {
  Map<String, List<RecroderModule>> datas = {};
  MethodChannel channel = const MethodChannel("com.lanwanhudong");
  String path = '';

  static Future<String> getRecrodPath({bool isDelete = false}) async {
    Directory directory = (await getExternalCacheDirectories())[0];
    return '${directory.path}${isDelete ? "/delete/" : "/Audio/"}';
  }

  /// 递归方式获取录音文件
  getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        String filename = file.path.replaceAll(path, '');
        if (filename.indexOf(RegExp('.wav')) > 0) {
          DateTime dateTime = await file.lastModified();
          String attr = '${dateTime.year}年${dateTime.month}月';
          var res = await channel.invokeMethod('getSize', {"path": file.path});
          double s = (res % (1000 * 60) / 1000);
          RecroderModule rm = RecroderModule(
            title: filename.replaceAll('.wav', ''),
            filepath: file.path,
            recrodingtime: "$res",
            lastModified:
                '${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
            isPlaying: false,
            isActive: false,
            fileSize: "${16000 * s / 1024}kb",
          );
          if (this.datas[attr] == null) {
            this.datas[attr] = [];
            this.datas[attr].add(rm);
          } else {
            bool flag = this.datas[attr].any((ele) => ele.title == rm.title);
            if (!flag) this.datas[attr].add(rm);
          }
        }
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        if (children != null)
          for (final FileSystemEntity child in children)
            await getTotalSizeOfFilesInDir(child);
      }
    } catch (e) {
      print(e);
    }
  }

  ///获取搜索结果
  Future<Map<String, List<RecroderModule>>> getSearchResult() async {
    await getRecrodPath();
    await getTotalSizeOfFilesInDir(Directory(path));
    return this.datas;
  }

  static Future<Map> pathTOModule(
      {String path, String newFileName, MethodChannel channel}) async {
    File file = File(path);
    String prePath = await getRecrodPath(),
        newPath = "$prePath$newFileName.wav";
    file.copySync(newPath);
    await file.delete();
    File newFile = File(newPath);
    if (newFile.existsSync()) {
      DateTime dateTime = await newFile.lastModified();
      String attr = '${dateTime.year}年${dateTime.month}月';
      var res = await channel.invokeMethod('getSize', {"path": newFile.path});
      double s = (16000 * (res % (1000 * 60) / 1000)) / 1024;
      RecroderModule rm = RecroderModule(
        title: newFileName,
        filepath: newFile.path,
        recrodingtime: "$res",
        lastModified:
            '${dateTime.month}月${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
        isPlaying: false,
        fileSize: "${s}kb",
        isActive: false,
        attr: attr
      );
      return {"attr": attr, 'rm': rm};
    }
  }
}
