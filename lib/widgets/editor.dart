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

class _EditorState extends State<Editor> {
  String currentTime = '0:0:0';
  GlobalKey<MusicProgressState> key = GlobalKey();
  double left = 0, right = 60, audioTimeLength = 0, lw = 30, rw = 30, height = 180, totalTime = 0;
  List<CanvasRectModu> recordingData = [];

  ///和native通讯
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  ///全局颜色
  Color gary = Colors.grey;

  Color get mainColor => Theme.of(context).primaryColor;

  RecroderModule get rm => widget.arguments['rm'];

  int get index => widget.arguments['index'];

  double get windowWidth => MediaQuery.of(context).size.width;
  double singleWidth;

  ///与canvas交互的参数
  CanvasRectModu canvasRectModu;
  int startIndex, endIndex, startTime, endTime;
  String startTimestamp = '00:00:00', endTimestamp = '00:00:00';

  TextStyle get _textStyle => TextStyle(color: Theme.of(context).primaryColor, fontSize: 12);

  @override
  void initState() {
    super.initState();

    ///设置默认标题
    ///读取音频二进制数据
    WavReader reader = WavReader(rm.filepath);
    reader.readAsBytes();

    ///设置音频时长
    audioTimeLength = reader.t;
    totalTime = reader.s * 1000;

    ///等待画布widget构建完毕
    Future.delayed(Duration(microseconds: 400)).then((value) {
      singleWidth = windowWidth / 13;
      List<int> data = reader.datas.skip(44).toList(growable: false);
//      List<int> data = reader.convert((singleWidth * 11).truncate());
      Provider.of<canvasData>(context, listen: false).setData(data);
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Container(),
        ),
        title: Center(child: Text('剪辑')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
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
                      if (x < singleWidth) x = singleWidth;
                      if (offset.dx >= windowWidth - rw) x = windowWidth - rw;
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
                      double x = windowWidth - offset.dx - 1;
                      if (offset.dx <= lw) x = windowWidth - lw;
                      if (offset.dx > windowWidth - singleWidth) x = singleWidth - 1;
                      offsetToTimeSteap(offset.dx.floor(), false);
                      setState(() {
                        rw = x.floorToDouble();
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

  ///底部
  Widget setButtom() {
    return Container(
      height: 140,
      padding: EdgeInsets.only(right: 13, top: 15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)]),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Text(currentTime, style: TextStyle(color: Colors.grey)),
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

  ///播放音乐
  void play() async {
    print(rm.filepath);
  }

  ///开始、结束指针转换函数
  void offsetToTimeSteap(num offset, bool isleft) {
    print(offset);
//    num groups = offset / 30 - 1;
//    double time = totalTime / 10 * groups;
//    String timeStr = '00:00:00';
//    if (time > 0) {
//      timeStr = format(Duration(milliseconds: time.toInt()));
//      setState(() {
//        if (isleft)
//          startTimestamp = timeStr;
//        else
//          endTimestamp = timeStr;
//      });
//    }
  }

  String format(Duration duration) {
    if (duration.inSeconds > 1)
      return '${duration.inHours}:${duration.inMinutes.floor()}:${duration.inSeconds}';
    else
      return '${duration.inMinutes.floor()}:${duration.inSeconds}:${duration.inMilliseconds % 1000}';
  }
}
