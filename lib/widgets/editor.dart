import 'dart:io';

import 'package:flutterapp/canvasData.dart';
import 'package:flutterapp/event_bus.dart';
import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/plugins/WavReader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/widgets/showSoung.dart';
import 'package:provider/provider.dart';
import '../provider.dart';
import '../utiles.dart';
import 'musicProgress.dart';

class Editor extends StatefulWidget {
  Editor({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> with WidgetsBindingObserver {
  FocusNode node = FocusNode();
  TextEditingController controller = TextEditingController();
  List<Map> playerIocns = [
    {'icon': 'asset/palying/icon_timing.png', 'title': '定时'},
    {'icon': 'asset/palying/icon_Circulat_blue.png', 'title': '全部循环'},
    {'icon': 'asset/palying/icon_speed_normal.png', 'title': '倍速'},
    {'icon': 'asset/palying/icon_refresh2.png', 'title': '转文字'},
    {'icon': 'asset/palying/icon_more-menu_blue.png', 'title': '更多'},
  ];
  String currenttime = '0:0:0';
  GlobalKey<MusicProgressState> key = GlobalKey();
  double left = 0, right = 60, audioTimeLength = 0, lw = 30, lww = 0, rw = 30, height = 180, totalTime = 0;
  List<CanvasRectModu> recrodingData = [], templist = [];

  ///和native通讯
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  ///全局颜色
  Color gary = Colors.grey;

  Color get mainColor => Theme.of(context).primaryColor;

  RecroderModule get rm => widget.arguments['rm'];

  int get index => widget.arguments['index'];

  double get windowWidth => MediaQuery.of(context).size.width;

  ///与canvas交互的参数
  CanvasRectModu canvasRectModu;
  int startIndex, endIndex, startTime, endTime;
  String startTimestamp = '00:00:00', endTimestamp = '00:00:00';

  TextStyle get _textStyle => TextStyle(color: Theme.of(context).primaryColor, fontSize: 12);

  @override
  void initState() {
    super.initState();
    controller.text = rm.title;
    WavReader reader = WavReader(rm.filepath);
    reader.readAsBytes();
    audioTimeLength = reader.t;
    totalTime = reader.s * 1000;
    Future.delayed(Duration(microseconds: 400)).then(
      (value) => Provider.of<canvasData>(context, listen: false).setData(reader.convers((windowWidth / 2).floor())),
    );
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        node.unfocus();
      }
    });
  }

  @override
  void deactivate() {
    node.unfocus();
    WidgetsBinding.instance.removeObserver(this);
    super.deactivate();
  }

  @override
  void dispose() async {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Container(),
//          child: GestureDetector(onTap: save, child: Text("保存")),
        ),
        title: Center(child: Text('剪辑')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
//        bottom: this.setInput(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                      color: Theme.of(context).primaryColor,
                      height: height,
                      child: ShowSoun(
                        recriodingTime: this.audioTimeLength,
                        isEditor: true,
                        totalTime: totalTime,
                      )),
                ),
                Positioned(
                  left: 0,
                  width: lw,
                  height: height,
                  child: Draggable(
                    axis: Axis.horizontal,
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      double x = offset.dx.floor().toDouble();
                      if (x < 2) x = 2;
                      if (offset.dx >= windowWidth - rw) x = windowWidth - rw - 2;
                      offsetToTimeSteap(x, true);
                      setState(() {
                        lw = x;
                      });
                    },
                    child: Container(
                      width: lw,
                      height: height,
                      decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 171, 0.4), border: Border(right: BorderSide(width: 1, color: Colors.red))),
                    ),
                    feedback: Container(
                      width: windowWidth,
                      height: height,
                      decoration: BoxDecoration(border: Border(left: BorderSide(width: 1, color: Colors.red))),
                    ),
                    childWhenDragging: Container(),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Draggable(
                    axis: Axis.horizontal,
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      double x = windowWidth - offset.dx;
                      if (offset.dx <= lw) x = windowWidth - lw - 2;
                      if (x < 0) x = 2;
                      offsetToTimeSteap(offset.dx.floor(), false);
                      setState(() {
                        rw = x.floor().toDouble();
                      });
                    },
                    child: Container(
                      width: rw,
                      height: height,
                      decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 171, 0.4), border: Border(left: BorderSide(width: 1, color: Colors.red))),
                    ),
                    feedback: Container(
                      width: 1,
                      height: height,
                      decoration: BoxDecoration(border: Border(left: BorderSide(width: 1, color: Colors.red))),
                    ),
                    childWhenDragging: Container(),
                  ),
                ),
              ],
            ),
          ),
          setOptions(),
        ],
      ),
      bottomNavigationBar: setButtom(),
    );
  }

  ///剪辑选项
  Widget setOptions() {
    return Container(
      width: windowWidth,
      height: 60,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, blurRadius: 3)], color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: cut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Image.asset('asset/sheared/icon_Sheared.png', width: 20), Text('剪切音频', style: _textStyle)],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Text(startTimestamp ?? '', style: _textStyle), Text('开始时间', style: _textStyle)],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Text(endTimestamp ?? '', style: _textStyle), Text('结束时间', style: _textStyle)],
          ),
        ],
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
        child: TextField(
          controller: controller,
          focusNode: node,
          decoration: InputDecoration(border: InputBorder.none, hintText: '输入录音标题', hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }

  ///底部
  Widget setButtom() {
    return Container(
      height: 200,
      padding: EdgeInsets.only(right: 13, top: 15, bottom: 30),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)]),
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
                        child: Column(children: <Widget>[Image.asset(e['icon'], width: 20), Text(e['title'], style: _textStyle)]),
                      )))
                  .toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Text(currenttime, style: TextStyle(color: Colors.grey)),
                Expanded(child: MusicProgress(key: key)),
                Text('${formatTime(rm.recrodingtime.toInt())}', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.skip_previous, color: gary), onPressed: () {}),
              IconButton(icon: Icon(Icons.replay, color: gary), onPressed: () {}),
              IconButton(icon: Icon(Icons.play_arrow, color: mainColor), onPressed: () {}),
              IconButton(icon: Icon(Icons.refresh, color: gary), onPressed: () {}),
              IconButton(icon: Icon(Icons.skip_next, color: gary), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  ///音频剪切
  void cut() async {
    if (startTime == null) {
      alert(context, title: Text('没有确定开始剪辑的时间'));
      return;
    } else if (endTime == null) {
      alert(context, title: Text('没有确定结束剪辑的时间'));
      return;
    } else if (endTime < startTime) {
      alert(context, title: Text('结束时间不能小于开始时间！'));
      return;
    }
    String originPath = rm.filepath, savePath;
    DateTime dateTime = DateTime.now();
    savePath = await FileUtile.getRecrodPath();
    savePath = "$savePath${rm.title}-${dateTime.year}.${dateTime.month}.${dateTime.day}-${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
    try {
      String res = await channel.invokeMethod("cat", {"originPath": originPath, "savePath": savePath, "startTime": startTime, "endTime": endTime});
      if (res.isNotEmpty) {
        alert(context, title: Text('剪辑完成！'));
        Provider.of<RecordListProvider>(context, listen: false).init(await FileUtile.getlocalMusic(channel: channel));
      } else {
        alert(context, title: Text('剪辑失败！'));
      }
    } catch (e) {
      print(e);
    }
  }

  ///保存
  void save() async {
    String newTitle = controller.text.trim();

    ///没有更改名称
    if (newTitle.compareTo(this.rm.title) == 0) {
      Navigator.pop(context);
    }

    ///修改了名称
    else {
      File file = File(this.rm.filepath);
      String newPath = '${await FileUtile.getRecrodPath()}$newTitle.wav';
      await file.copy(newPath);
      await file.delete();
      Provider.of<RecordListProvider>(context, listen: false).changeRM(newTitle, newPath, index);
      Navigator.pop(context);
    }
  }

  ///数据左右滑动
  recrodingOffset(double offset) {
    double ofs = offset.floorToDouble();
    List<CanvasRectModu> newList;
    left += ofs;
    right = (-left) + 120;
    if (-left.floor() < 0) {
      left -= ofs;
      return;
    }
    if (right > recrodingData.length) {
      left -= ofs;
      right = recrodingData.length.toDouble();
      return;
    }
    var newList2 = recrodingData.getRange(-left.floor(), right.floor());
    print(newList);
    newList = newList2.toList();
//    showSounkey.currentState.setRecrodingData(newList);
  }

  ///播放音乐
  void play() async {
    print(rm.filepath);
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

  void offsetToTimeSteap(num offset, bool isleft) {
    num groups = offset / 30 - 1;
    double time = totalTime / 10 * groups;
    String timeStr = '00:00:00';
    if (time > 0) {
      timeStr = format(Duration(milliseconds: time.toInt()));
      setState(() {
        if (isleft)
          startTimestamp = timeStr;
        else
          endTimestamp = timeStr;
      });
    }
  }

  String format(Duration duration) {
    if (duration.inSeconds > 1)
      return '${duration.inHours}:${duration.inMinutes.floor()}:${duration.inSeconds}';
    else
      return '${duration.inMinutes.floor()}:${duration.inSeconds}:${duration.inMilliseconds % 1000}';
  }
}
