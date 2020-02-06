import 'dart:io';

import 'package:asdasd/modus/record.dart';
import 'package:asdasd/utiles.dart';
import 'package:asdasd/widgets/listItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Trash extends StatefulWidget {
  Trash({Key key}) : super(key: key);

  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  String cacheFile = '/file_cache/delete/', path = '';
  List<RecroderModule> datas = [];
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    path = await FileUtile().getRecrodPath(isDelete: true);
    if (await Directory(path).exists()) {
      await _getTotalSizeOfFilesInDir(Directory(path));
      setState(() {});
    } else {
      Directory(path).createSync();
      await _getTotalSizeOfFilesInDir(Directory(path));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(datas: datas, isRecrodingFile: true);
  }

  /// 递归方式获取录音文件
  _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        String filename = file.path.replaceAll(path, '');
        if (filename.indexOf(RegExp('.wav')) > 0) {
          DateTime dateTime = await file.lastModified();
          var res = await channel.invokeMethod('getSize', {"path": file.path});
          double s = (res % (1000 * 60) / 1000);
          RecroderModule rm = RecroderModule(
            title: filename,
            filepath: file.path,
            recrodingtime: "$res",
            lastModified:
                '${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
            isPlaying: false,
            fileSize: "${16000 * s / 1024}kb",
          );
          this.datas.add(rm);
          print(datas);
        }
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        if (children != null)
          for (final FileSystemEntity child in children)
            await _getTotalSizeOfFilesInDir(child);
      }
    } catch (e) {
      print(e);
    }
  }
}
