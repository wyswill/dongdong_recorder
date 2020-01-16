import 'dart:async';

import 'package:asdasd/event_bus.dart';
import 'package:asdasd/pages/list/recrodingFileItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecrodingList extends StatefulWidget {
  RecrodingList({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _RecrodingListState createState() => _RecrodingListState();
}

class _RecrodingListState extends State<RecrodingList> {
  StreamSubscription streamSubscription;
  Map datas = {
    "2019年12月": [
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
    ],
    "2019年11月": [
      {
        'title': "会议",
        "rectimg": 2000,
        "fileSize": "950kb",
        'lastDate': DateTime.now().toLocal().toString(),
        'filePath': 'asdasdds',
        "isPlaying": false
      }
    ],
    "2019年10月": [
      {
        'title': "会议",
        "rectimg": 2000,
        "fileSize": "950kb",
        'lastDate': DateTime.now().toLocal().toString(),
        'filePath': 'asdasdds',
        "isPlaying": false
      }
    ],
  };
  List dataKeys = [];
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  Map curentPlayRecrofing;
  @override
  void initState() {
    super.initState();
    dataKeys = datas.keys.toList();
    streamSubscription = eventBus.on<PlayingState>().listen((event) {
      setState(() {
        this.curentPlayRecrofing['isPlaying'] = event.state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: List.generate(this.dataKeys.length, (int index) {
          return buildRecrodingItem(index);
        }),
      ),
    );
  }

  ///每组录音数据样式
  Widget buildRecrodingItem(int index) {
    String curnetKey = dataKeys[index];
    List curentRecrodingFiles = this.datas[curnetKey];
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
              Map curentFile = curentRecrodingFiles[ind];
              return RecrodingFileItems(
                curentFile: curentFile,
                playRecroding: this.playRecroding,
                index: ind,
              );
            }),
          )
        ],
      ),
    );
  }

  ///播放录音
  void playRecroding({Map curentFile}) {
    if (curentPlayRecrofing != null && curentPlayRecrofing == curentFile) {
      setState(() {
        curentPlayRecrofing['isPlaying'] = !curentPlayRecrofing['isPlaying'];
      });
      eventBus.fire(PlayingFile(curentFile));
      return;
    }
    if (curentPlayRecrofing != null && curentPlayRecrofing['isPlaying']) {
      setState(() {
        curentPlayRecrofing['isPlaying'] = !curentPlayRecrofing['isPlaying'];
        curentFile['isPlaying'] = !curentFile['isPlaying'];
        curentPlayRecrofing = curentFile;
      });
    } else {
      setState(() {
        curentFile['isPlaying'] = !curentFile['isPlaying'];
        curentPlayRecrofing = curentFile;
      });
    }
    eventBus.fire(PlayingFile(curentFile));
  }

  ///向左滑动显示菜单
  void recrodingOffset(double offset) {
    if (offset <= 0) {
      print('asd');
    }
  }
}
