import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/pages/list/recrodingFileItems.dart';
import 'package:flutterapp/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecrodingList extends StatefulWidget {
  RecrodingList({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _RecrodingListState createState() => _RecrodingListState();
}

class _RecrodingListState extends State<RecrodingList> {
  Map<String, List<RecroderModule>> datas = {};
  List dataKeys = [];
  List<bool> activeManages = [];
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  RecroderModule currentPlayRecording;
  String key;
  int currentIndex;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Modus>(
      builder: (context, conter, child) {
        List keys = conter.recroderFiles.keys.toList();
        return Container(
          child: CustomScrollView(
            slivers: List.generate(keys.length, (int index) {
              return buildRecrodingItem(index, keys, conter.recroderFiles);
            }),
          ),
        );
      },
    );
  }

  ///每组录音数据样式
  Widget buildRecrodingItem(
      int index, List keys, Map<String, List<RecroderModule>> datas) {
    String curnetKey = keys[index];
    List<RecroderModule> curentRecrodingFiles = datas[curnetKey];
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20),
            color: Color.fromRGBO(242, 241, 244, 1),
            child: Text(curnetKey),
          ),
          Column(
            children: List.generate(curentRecrodingFiles.length, (int ind) {
              RecroderModule curentFile = curentRecrodingFiles[ind];
              return RecrodingFileItems(
                curentFile: curentFile,
                index: ind,
                curnetKey: curnetKey,
              );
            }),
          )
        ],
      ),
    );
  }
}
