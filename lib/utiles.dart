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
  EdgeInsetsGeometry contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
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
  static Future<String> getRecrodPath({bool isDelete = false}) async {
    Directory directory = (await getExternalCacheDirectories())[0];
    return '${directory.path}${isDelete ? "/delete/" : "/Audio/"}';
  }

  static Future<List<RecroderModule>> getlocalMusic({bool isRecroder = true, MethodChannel channel}) async {
    String FIlepath = await FileUtile.getRecrodPath(isDelete: !isRecroder);
    List<RecroderModule> resList = [];

    /// 递归方式获取录音文件
    getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
      try {
        if (file is File) {
          String filename = file.path.replaceAll(FIlepath, '');
          if (filename.indexOf(RegExp('.wav')) > 0) {
            DateTime dateTime = await file.lastModified();
            var res = await channel.invokeMethod('getSize', {"path": file.path});
            double s = (16000 * (res % (1000 * 60) / 1000)) / 1024;
            RecroderModule rm = RecroderModule(
              title: filename.replaceAll('.wav', ''),
              filepath: file.path,
              recrodingtime: "$res",
              lastModified: '${dateTime.year}年${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
              isPlaying: false,
              isActive: false,
              fileSize: "${s}kb",
            );
            resList.add(rm);
          }
        }
        if (file is Directory) {
          final List<FileSystemEntity> children = file.listSync();
          if (children != null) for (final FileSystemEntity child in children) await getTotalSizeOfFilesInDir(child);
        }
      } catch (e) {
        print(e);
      }
    }

    Directory d = Directory(FIlepath);
    if (d.existsSync())
      await getTotalSizeOfFilesInDir(d);
    else {
      d.createSync();
      await getTotalSizeOfFilesInDir(d);
    }
    return resList;
  }

  // ignore: missing_return
  static Future<RecroderModule> pathTOModule({String path, String newFileName, MethodChannel channel}) async {
    File file = File(path);
    String prePath = await getRecrodPath(), newPath = "$prePath$newFileName.wav";
    file.copySync(newPath);
    await file.delete();
    File newFile = File(newPath);
    if (newFile.existsSync()) {
      DateTime dateTime = await newFile.lastModified();
      var res = await channel.invokeMethod('getSize', {"path": newFile.path});
      double s = (16000 * (res % (1000 * 60) / 1000)) / 1024;
      RecroderModule rm = RecroderModule(
        title: newFileName,
        filepath: newFile.path,
        recrodingtime: "$res",
        lastModified: '${dateTime.year}年${dateTime.month}月${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
        isPlaying: false,
        fileSize: "${s}kb",
        isActive: false,
      );
      return rm;
    }
  }
}
