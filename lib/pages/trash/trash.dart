import 'package:asdasd/widgets/listItem.dart';
import 'package:flutter/material.dart';

class Trash extends StatefulWidget {
  Trash({Key key}) : super(key: key);

  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  @override
  Widget build(BuildContext context) {
    List<Map> datas = [
      {
        'title': "会议",
        "rectimg": 2000,
        "fileSize": "950kb",
        'lastDate': DateTime.now().toLocal().toString(),
        'filePath': 'asdasdds',
        "isPlaying": false
      },
      {
        'title': "会议",
        "rectimg": 2000,
        "fileSize": "950kb",
        'lastDate': DateTime.now().toLocal().toString(),
        'filePath': 'asdasdds',
        "isPlaying": false
      },
    ];
    return ListItem(datas: datas, isRecrodingFile: true);
  }
}
