import 'dart:async';
import 'dart:io';

import 'package:flutterapp/canvasData.dart';
import 'package:flutterapp/event_bus.dart';
import 'package:flutterapp/modus/cancasRectModu.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/plugins/AudioPlayer.dart';
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
  double left = 0, right = 60, audioTimeLength = 0, lw = 30, rw = 30, height = 250, totalTime = 0;
  List<CanvasRectModu> recordingData = [];

  ///和native通讯
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  ///全局颜色
  Color gary = Colors.grey;

  Color get mainColor => Theme.of(context).primaryColor;

  RecroderModule get rm => widget.arguments['rm'];

  int get index => widget.arguments['index'];

  double get windowWidth => MediaQuery.of(context).size.width;
  double singleWidth, sw;

  ///与canvas交互的参数
  CanvasRectModu canvasRectModu;
  String startTimestamp = '0:0:0', endTimestamp = '0:0:0', playingTime = '0:0:0';
  int starttime, endtime;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isplaying = false;
  Timer timer = null;
  int currentPlayingTime = 0, totlePlaying = 0;

  TextStyle get _textStyle => TextStyle(color: Theme.of(context).primaryColor, fontSize: 12);

  @override
  void initState() {
    super.initState();

    ///设置默认标题
    ///读取音频二进制数据
    WavReader reader = rm.reader;
    reader.readAsBytes();

    ///设置音频时长
    audioTimeLength = reader.t;
    totalTime = reader.s * 1000;
    endTimestamp = formatTime(rm.recrodingtime.truncate());
    endtime = totalTime.truncate();
    totlePlaying = reader.s.truncate();

    ///等待画布widget构建完毕
    Future.delayed(Duration(microseconds: 400)).then((value) {
      singleWidth = windowWidth / 14;
      lw = rw = singleWidth;
      sw = singleWidth * 12 / (totalTime / 1000).truncate();
      List<List<int>> datas = reader.convert((singleWidth * 12).truncate()).cast<List<int>>();
      Provider.of<canvasData>(context, listen: false).setData(datas);
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
                  height: 250,
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
                      double x = offset.dx;
                      if (x < singleWidth) x = singleWidth;
                      if (offset.dx >= windowWidth - rw) x = windowWidth - rw;
                      offsetToTimeSteap(x - 1, true);
                      setState(() {
                        lw = x - 1;
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
                      if (offset.dx <= lw) x = windowWidth - lw;
                      if (offset.dx > windowWidth - singleWidth) x = singleWidth;
                      offsetToTimeSteap(offset.dx + 1, false);
                      setState(() {
                        rw = x + 1;
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
      height: 80,
      padding: EdgeInsets.only(right: 13, top: 15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(isplaying ? Icons.stop : Icons.play_arrow, color: mainColor), onPressed: playOrPurse),
            Text(playingTime, style: TextStyle(color: Colors.grey)),
            Expanded(child: MusicProgress(key: key)),
            Text(endTimestamp, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  ///音频剪切
  void cut() async {
//    if (startTime == null) {
//      alert(context, title: Text('没有确定开始剪辑的时间'));
//      return;
//    } else if (endTime == null) {
//      alert(context, title: Text('没有确定结束剪辑的时间'));
//      return;
//    } else if (endTime < startTime) {
//      alert(context, title: Text('结束时间不能小于开始时间！'));
//      return;
//    }
//    String originPath = rm.filepath, savePath;
//    DateTime dateTime = DateTime.now();
//    savePath = await FileUtile.getRecrodPath();
//    savePath = "$savePath${rm.title}-${dateTime.year}.${dateTime.month}.${dateTime.day}-${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
//    try {
//      String res = await channel.invokeMethod("cat", {"originPath": originPath, "savePath": savePath, "startTime": startTime, "endTime": endTime});
//      if (res.isNotEmpty) {
//        alert(context, title: Text('剪辑完成！'));
//        Provider.of<RecordListProvider>(context, listen: false).init(await FileUtile.getlocalMusic(channel: channel));
//      } else {
//        alert(context, title: Text('剪辑失败！'));
//      }
//    } catch (e) {
//      print(e);
//    }
  }

  ///播放音乐
  void playOrPurse() async {
    if (isplaying) {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      this.reseProgress();
    } else {
      reseProgress();
      setProgress();
    }
    setState(() {
      isplaying = !isplaying;
    });

    ///和java通信
    //audioPlayer.playWithFlag(rm.filepath, starttime, endtime);
  }

  ///设置进度条
  void setProgress() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer newtimer) async {
      print("totlePlaying==>$totlePlaying,currentPlayingTime==>$currentPlayingTime");
      if (currentPlayingTime <= totlePlaying.truncate() - 1) {
        this.currentPlayingTime++;
        this.playingTime = formatTime(currentPlayingTime);
        key.currentState.setCurentTime(currentPlayingTime / totlePlaying.truncate());
        setState(() {});
      } else {
        key.currentState.setCurentTime(1);
        setState(() {
          isplaying = false;
          timer.cancel();
          timer = null;
        });
//        audioPlayer.pause();
      }
    });
  }

  ///重置进度条
  void reseProgress() {
    setState(() {
      this.currentPlayingTime = 0;
      this.playingTime = formatTime(currentPlayingTime);
    });
    key.currentState.setCurentTime(0);
  }

  ///开始、结束指针转换函数
  ///
  ///每次左右指针移动之后得到开始和结束的时间
  ///再将开始和结束时间发送到java端
  ///
  void offsetToTimeSteap(num offset, bool isleft) {
    ///实际的偏移量=偏移量-基本的偏移量
    int flag = (offset - singleWidth).truncate();
    if (flag == 0) return;

    ///开始或结束时间 = 实际偏移量 / 基本的指针长度
    double time = (flag / sw).abs();
    String timeString = doubleTwo(time);
    setState(() {
      if (isleft) {
        startTimestamp = timeString;
        starttime = (time * 1000).floor();
        currentPlayingTime = starttime;
      } else {
        endTimestamp = timeString;
        endtime = (time * 1000).floor();
      }
      totlePlaying = endtime - starttime;
    });
    this.playOrPurse();
  }

  String doubleTwo(double number) {
    String t = number.toString();
    List<String> end = t.split('.');
    String tp = end[1].substring(0, 2);
    int s = double.parse('${end[0]}.$tp').floor();
    return formatTime(s);
  }
}
