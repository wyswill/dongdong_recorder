import 'package:asdasd/widgets/showSoung.dart';
import 'package:flutter/material.dart';

import '../utiles.dart';
import 'musicProgress.dart';

class Editor extends StatefulWidget {
  Editor({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  FocusNode node = FocusNode();
  TextEditingController controller = TextEditingController();
  List<Map> playerIocns = [
    {'icon': 'asset/palying/icon_timing.png', 'title': '定时'},
    {'icon': 'asset/palying/icon_Circulat_blue.png', 'title': '全部循环'},
    {'icon': 'asset/palying/icon_speed_normal.png', 'title': '倍速'},
    {'icon': 'asset/palying/icon_refresh2.png', 'title': '转文字'},
    {'icon': 'asset/palying/icon_more-menu_blue.png', 'title': '更多'},
  ],
      options = [
    {'icon': 'asset/palying/icon_timing.png', 'title': '剪切'},
    {'icon': 'asset/palying/icon_Circulat_blue.png', 'title': '复制'},
    {'icon': 'asset/palying/icon_speed_normal.png', 'title': '粘贴'},
    {'icon': 'asset/palying/icon_Sheared_blue.png', 'title': '删除'},
    {'icon': 'asset/palying/icon_refresh2.png', 'title': '保留'},
  ];
  String currenttime = '0:0:0';
  GlobalKey<MusicProgressState> key = GlobalKey();
  GlobalKey<ShowSounState> showSounkey = GlobalKey();
  double totalTime = 0, left = 0, right = 60, audioTimeLength = 0;
  List<double> recrodingData = [], templist = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: GestureDetector(
            onTap: save,
            child: Text("保存"),
          ),
        ),
        title: Center(
          child: Text('剪辑'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        bottom: this.setInput(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  setCanvas(),
                  setOptions(),
                ],
              ),
            ),
            setButtom(),
          ],
        ),
      ),
      //  bottomNavigationBar:
    );
  }

  ///保存
  void save() {}

  ///数据左右滑动
  recrodingOffset(double offset) {
    double ofs = offset.floorToDouble();
    List<double> newList;
    left += ofs;
    right = (-left) + 195;
    if (-left.floor() < 0) {
      left -= ofs;
      return;
    }
    if (right > templist.length) {
      left -= ofs;
      right = templist.length.toDouble();
      return;
    }
    var newList2 = templist.getRange(-left.floor(), right.floor());
    newList = newList2.toList();
    showSounkey.currentState.setRecrodingData(newList);
  }

  ///设置音频波形画布
  Widget setCanvas() {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails e) {
        double offset = e.delta.dx;
        recrodingOffset(offset);
      },
      child: ShowSoun(key: showSounkey, recriodingTime: this.audioTimeLength,isEditor: true,),
    );
  }

  ///剪辑选项
  Widget setOptions() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey)],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: this.options.map((e) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.access_time,
                size: 22,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                e['title'],
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 12),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  ///输入框
  Widget setInput() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        padding: EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: TextField(
          controller: controller,
          focusNode: node,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '输入录音标题',
              hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }

  ///底部
  Widget setButtom() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 13, top: 15, bottom: 30),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)
      ]),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: this
                  .playerIocns
                  .map((e) => Container(
                          child: GestureDetector(
                        onTap: () {
                          switch (e['title']) {
                            case "定时":
                              this.setTimeout();
                              break;
                            case "全部循环":
                              this.circulation();
                              break;
                            case "倍速":
                              this.pias();
                              break;
                            case "转文字":
                              this.transiton();
                              break;
                            case "更多":
                              this.more();
                              break;
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              e['icon'],
                              width: 20,
                            ),
                            Text(
                              e['title'],
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      )))
                  .toList(),
            ),
          ),
          Row(
            children: <Widget>[
              Text(currenttime, style: TextStyle(color: Colors.grey)),
              Expanded(child: MusicProgress(key: key)),
              Text(formatTime(totalTime.toInt()),
                  style: TextStyle(color: Colors.grey))
            ],
          )
        ],
      ),
    );
  }

  ///播放音乐
  void play() async {
//    setState(() {
//      this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
//    });
//    eventBus.fire(PlayingState(this.plaingFile.isPlaying));
//    if (plaingFile.isPlaying)
//      await audioPlayer.play(plaingFile.filepath, isLocal: true);
//    else
//      await audioPlayer.pause();
  }

  ///定时选择
  void setTimeout() {}

  ///全部循环
  void circulation() {}

  ///倍速
  void pias() {}

  ///转文字
  void transiton() {}

  ///更多
  void more() {}
}
