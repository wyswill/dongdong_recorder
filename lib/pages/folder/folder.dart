import 'package:asdasd/modus/record.dart';
import 'package:asdasd/widgets/listItem.dart';
import 'package:flutter/material.dart';

class Folder extends StatefulWidget {
  Folder({Key key}) : super(key: key);

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  List<RecroderModule> datas = [];

  @override
  Widget build(BuildContext context) {
    return ListItem(datas: datas, isRecrodingFile: false);
  }
}
