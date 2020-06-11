import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/plugins/WavReader.dart';
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

String formatTime(int totalTime) {
  Duration duration = Duration(seconds: totalTime);
  int h = duration.inHours, m = duration.inMinutes, ms = totalTime % 1000;
  String res = '$totalTime.$ms';
  if (m > 0) res = '$m:$res';
  if (h > 0) res = '$h:$res';
  return res;
}

class FileUtile {
  ///获取录音路径或是回收站路径
  static Future<String> getRecrodPath({bool isDelete = false}) async {
    Directory directory = (await getExternalCacheDirectories())[0];
    return '${directory.path}${isDelete ? "/delete/" : "/Audio/"}';
  }

  ///读取本地的录音文件，转化为操作List
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
            WavReader reader = WavReader(file.path);
            reader.readAsBytes();
            RecroderModule rm = RecroderModule(
              title: filename.replaceAll('.wav', ''),
              filepath: file.path,
              recrodingtime: reader.s,
              lastModified: '${dateTime.year}年${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
              isPlaying: false,
              isActive: false,
              fileSize: "${reader.size}kb",
              reader: reader,
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

  ///将文件路径转化为操作类
  // ignore: missing_return
  static Future<RecroderModule> pathTOModule({String path, String newFileName, MethodChannel channel}) async {
    File file = File(path);
    String prePath = await getRecrodPath(), newPath = "$prePath$newFileName.wav";
    file.copySync(newPath);
    await file.delete();
    File newFile = File(newPath);
    if (newFile.existsSync()) {
      DateTime dateTime = await newFile.lastModified();
      WavReader reader = WavReader(file.path);
      reader.readAsBytes();
      RecroderModule rm = RecroderModule(
        title: newFileName,
        filepath: newFile.path,
        recrodingtime: reader.s,
        lastModified: timeFromate(dateTime),
        isPlaying: false,
        fileSize: "${reader.size}kb",
        isActive: false,
        reader: reader,
      );
      return rm;
    }
  }

  static String timeFromate(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}

///水波纹控件
Widget setInk({Function ontap, Color bgColor = Colors.white, Color highlightColor, BorderRadiusGeometry borderRadius, Widget child}) {
  return Material(
    borderRadius: borderRadius,
    color: bgColor,
    child: Ink(
      child: InkWell(onTap: ontap, child: child, highlightColor: highlightColor, borderRadius: borderRadius),
    ),
  );
}
