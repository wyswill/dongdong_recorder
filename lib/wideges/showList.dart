import 'package:flutter/material.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/wideges/recrodingFileItems.dart';

import '../event_bus.dart';

// ignore: must_be_immutable, camel_case_types
class showList extends StatefulWidget {
  showList({Key key, this.dataKeys, this.datas}) : super(key: key);
  List dataKeys;
  Map<String, List<RecroderModule>> datas;
  @override
  _showListState createState() => _showListState();
}

// ignore: camel_case_types
class _showListState extends State<showList> {
  RecroderModule currentPlayRecording;
  int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: List.generate(widget.dataKeys.length, (int index) {
          return buildRecrodingItem(index);
        }),
      ),
    );
  }

  ///每组录音数据样式
  Widget buildRecrodingItem(int index) {
    String curnetKey = widget.dataKeys[index];
    List<RecroderModule> curentRecrodingFiles = widget.datas[curnetKey];
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
                playRecroding: this.playRecording,
                index: ind,
                curnetKey: curnetKey,
              );
            }),
          )
        ],
      ),
    );
  }

  ///播放录音
  playRecording({RecroderModule currentFile, int index, String key}) {
    List<RecroderModule> rms = widget.datas[key];
    for (int i = 0; i < rms.length; i++) {
      RecroderModule currentRm = rms[i];
      if (index == i)
        currentRm.isActive = !currentRm.isActive;
      else
        currentRm.isActive = false;
    }
    if (mounted)
      setState(() {
        key = key;
        currentPlayRecording = currentFile;
        currentIndex = index;
      });
    eventBus.fire(PlayingFile(currentFile));
  }
}
