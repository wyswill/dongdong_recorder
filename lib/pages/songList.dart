import 'package:flutter/material.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/utiles.dart';
import 'package:flutterapp/wideges/showList.dart';

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  Map<String, List<RecroderModule>> datas = {}; //扫描的歌曲
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    FileUtile fileUtile = FileUtile();
    datas = fileUtile.datas;
  }

  @override
  Widget build(BuildContext context) {
    return showList(
      dataKeys: List.from(datas.keys),
      datas: datas,
    );
  }
}
