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
        'filePath': 'asdasdds'
      },
      {
        'title': "会议",
        "rectimg": 2000,
        "fileSize": "950kb",
        'lastDate': DateTime.now().toLocal().toString(),
        'filePath': 'asdasdds'
      },
    ],
    "2019年11月": [
      {
        'title': "会议",
        "rectimg": 2000,
        "fileSize": "950kb",
        'lastDate': DateTime.now().toLocal().toString(),
        'filePath': 'asdasdds'
      }
    ],
    "2019年10月": [
      {
        'title': "会议",
        "rectimg": 2000,
        "fileSize": "950kb",
        'lastDate': DateTime.now().toLocal().toString(),
        'filePath': 'asdasdds'
      }
    ],
  };
  List dataKeys = [];
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color.fromRGBO(240, 240, 246, 1)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.grey),
              onPressed: () {
                playRecroding(curentFile: curentFile);
              },
            ),
          ),
          Column(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Container(
                    child: Text(
                      curentFile['lastDate'],
                      style: textStyle,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void playRecroding({Map curentFile}) {}
}
