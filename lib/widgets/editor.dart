import 'dart:async';
import 'dart:io';

import 'package:flutterapp/event_bus.dart';
import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/widgets/showSoung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  GlobalKey<ShowSounState> showSounkey = GlobalKey();
  double left = 0, right = 60, audioTimeLength = 0, lw = 2, rw = 2, height = 180;
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
  String startTimestamp, endTimestamp;

  TextStyle get _textStyle => TextStyle(color: Theme.of(context).primaryColor, fontSize: 12);

  @override
  void initState() {
    super.initState();
    controller.text = rm.title;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var data = await this.channel.invokeListMethod('fft', {"path": rm.filepath});
    recrodingData = await transfrom(data.toList());
    recrodingOffset(0);
    eventBus.on<SetCurentTime>().listen((val) {
      setState(() {
        canvasRectModu = val.canvasRectModu;
      });
    });
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
          child: GestureDetector(onTap: save, child: Text("保存")),
        ),
        title: Center(child: Text('剪辑')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
        bottom: this.setInput(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: height,
                    child: setCanvas(),
                  ),
                ),
                Positioned(
                  top: 20,
                  child: Draggable(
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      double x = offset.dx;
                      if (x < 0) x = 2;
                      setState(() {
                        lw = x;
                      });
                    },
                    axis: Axis.horizontal,
                    child: Container(
                      width: lw,
                      height: height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 171, 0.4), border: Border(right: BorderSide(width: 1, color: Colors.red))),
                    ),
                    feedback: Container(
                      width: 2,
                      height: height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Color.fromRGBO(168, 168, 171, 0.4), border: Border(right: BorderSide(width: 1, color: Colors.white))),
                    ),
                    childWhenDragging: Container(),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 0,
                  child: Draggable(
                    axis: Axis.horizontal,
                    child: Container(
                      width: rw,
                      height: height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                    feedback: Container(
                      width: rw,
                      height: height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                    childWhenDragging: Container(),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(startTimestamp != null ? startTimestamp : "0:0:0"),
                          ),
                          Text('开始时间戳')
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(canvasRectModu != null ? canvasRectModu.timestamp : "0:0:0"),
                          ),
                          Text('当前时间戳', style: TextStyle(color: Colors.red))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(endTimestamp != null ? endTimestamp : "0:0:0"),
                          ),
                          Text('结束时间戳')
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          setOptions(),
        ],
      ),
      bottomNavigationBar: setButtom(),
    );
  }

  ///设置音频波形画布
  Widget setCanvas() {
    return ShowSoun(
      key: showSounkey,
      recriodingTime: this.audioTimeLength,
      isEditor: true,
    );
//    return GestureDetector(
//      onHorizontalDragUpdate: (DragUpdateDetails e) {
//        double offset = e.delta.dx;
//        recrodingOffset(offset);
//      },
//      child:
//    );
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
          GestureDetector(
            onTap: setStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Image.asset('asset/flag/icon_flag.png', width: 20), Text('开始时间戳', style: _textStyle)],
            ),
          ),
          GestureDetector(
            onTap: setEnd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Image.asset('asset/flag/icon_flag_blue.png', width: 20), Text('结束时间戳', style: _textStyle)],
            ),
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
              children: <Widget>[Text(currenttime, style: TextStyle(color: Colors.grey)), Expanded(child: MusicProgress(key: key)), Text(formatTime(int.parse(rm.recrodingtime)), style: TextStyle(color: Colors.grey))],
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
        Provider.of<recrodListProvider>(context, listen: false).init(await FileUtile.getlocalMusic(channel: channel));
      } else {
        alert(context, title: Text('剪辑失败！'));
      }
    } catch (e) {
      print(e);
    }
  }

  ///设置截取开始指针
  setStart() {
    if (canvasRectModu != null) {
      int index = canvasRectModu.index + (-left.floor()) - 11;
      if (startIndex == null) {
        recrodingData[index].type = CanvasRectTypes.start;
      } else {
        recrodingData[startIndex].type = CanvasRectTypes.data;
        recrodingData[index].type = CanvasRectTypes.start;
      }
      setState(() {
        startIndex = index;
        startTimestamp = canvasRectModu.timestamp;
        startTime = canvasRectModu.ms;
      });
    }
  }

  ///设置结束指针
  setEnd() {
    if (canvasRectModu != null) {
      int index = canvasRectModu.index + (-left.floor()) - 11;
      if (endIndex == null) {
        recrodingData[index].type = CanvasRectTypes.end;
      } else {
        recrodingData[endIndex].type = CanvasRectTypes.data;
        recrodingData[index].type = CanvasRectTypes.end;
      }
      setState(() {
        endIndex = index;
        endTimestamp = canvasRectModu.timestamp;
        endTime = canvasRectModu.ms;
      });
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
      Provider.of<recrodListProvider>(context, listen: false).changeRM(newTitle, newPath, index);
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
    newList = newList2.toList();
    showSounkey.currentState.setRecrodingData(newList);
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

  List<CanvasRectModu> addHeadOrTail(List<CanvasRectModu> arr) {
    int columnsCount = 80;
    for (int i = 0; i < columnsCount; i++) {
      arr.add(CanvasRectModu(vlaue: 2, type: CanvasRectTypes.point, timestamp: "0:0:0"));
    }
    return arr;
  }

  ///将波形按照毫秒的时域进行转换
  Future<List> transfrom(List data) async {
    ///获取录音时间
    double recrodingtime = (data.length / 8000) * 100;

    ///以1毫秒为间隔提取一次数据
    int flag = (data.length / recrodingtime).floor() * 10, stp = 0;
    List<CanvasRectModu> res = [];
//    res = addHeadOrTail(res);
    for (int i = 0; i < data.length; i++) {
      double curent = data[i];
      if (stp == flag) {
        int t = (i / flag).floor().toInt();
        res.add(CanvasRectModu(
          vlaue: curent,
          type: CanvasRectTypes.data,
          index: i,
          timestamp: formatTime(t * 100),
          ms: t * 100,
        ));
        stp = 0;
      }
      stp++;
    }
//    res = addHeadOrTail(res);
    return res;
  }
}
