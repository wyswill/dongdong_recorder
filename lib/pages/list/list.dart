import 'package:asdasd/event_bus.dart';
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
              return recrodingFileItems(curentFile: curentFile);
            }),
          )
        ],
      ),
    );
  }

  ///每个单个的录音文件样式
  Widget recrodingFileItems({Map curentFile}) {
    Duration duration = Duration(milliseconds: curentFile['rectimg']);
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        border: Border(
          left: curentFile['isPlaying']
              ? BorderSide(width: 4, color: Theme.of(context).primaryColor)
              : BorderSide(width: 0),
          bottom: BorderSide(width: 1, color: Color.fromRGBO(240, 240, 246, 1)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: IconButton(
              icon: curentFile['isPlaying']
                  ? Icon(Icons.stop, color: Theme.of(context).primaryColor)
                  : Icon(Icons.play_arrow, color: Colors.grey),
              onPressed: () {
                playRecroding(curentFile: curentFile);
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Text(
                    curentFile['title'],
                    style: TextStyle(fontSize: 14),
                  )
                ]),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "${duration.inHours}:${duration.inMinutes}:${duration.inSeconds}",
                        style: textStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        curentFile['fileSize'],
                        style: textStyle,
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      child: Text(
                        curentFile['lastDate'],
                        style: textStyle,
                      ),
                    )
                  ],
                )
              ],
            ),
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
}
