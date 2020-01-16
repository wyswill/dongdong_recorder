import 'package:asdasd/widgets/listItem.dart';
import 'package:flutter/material.dart';

class Folder extends StatefulWidget {
  Folder({Key key}) : super(key: key);

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  List<Map> datas = [
    {
      'title': "会议",
      "files": 3,
      "fileSize": "950kb",
      'lastDate': DateTime.now().toLocal().toString(),
    },
    {
      'title': "会议",
      "files": 3,
      "fileSize": "950kb",
      'lastDate': DateTime.now().toLocal().toString(),
    },
    {
      'title': "会议",
      "files": 3,
      "fileSize": "950kb",
      'lastDate': DateTime.now().toLocal().toString(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListItem(datas: datas, isRecrodingFile: false);
  }
}
