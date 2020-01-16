import 'dart:io';
import 'package:asdasd/widgets/showSoung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';
import 'package:flutter_plugin_record/response.dart';

class Recroding extends StatefulWidget {
  @override
  _RecrodingState createState() => _RecrodingState();
}

class _RecrodingState extends State<Recroding> {
  FlutterPluginRecord flutterPluginRecord = FlutterPluginRecord();
  bool statu = false;
  String filepath = '';
  List<String> paths = [];
  List<double> recrodingData;
  GlobalKey<ShowSounState> key = GlobalKey();
  double left = 0, right = 60;
  double audioTimeLength = 0;
  MethodChannel channel = const MethodChannel("com.lanwanhudong");
  FlutterFFmpeg fFmpeg = FlutterFFmpeg();

  @override
  void initState() {
    super.initState();
    flutterPluginRecord.init();
    flutterPluginRecord.responseFromInit.listen(responseFromInitListen);
    flutterPluginRecord.response.listen(strartRecroding);
  }

  ///初始化回调监听
  responseFromInitListen(data) {
    if (data)
      print('初始化成功');
    else
      print('初始化失败');
  }

  ///播放或暂停
  startOrStop() {
    if (statu)
      flutterPluginRecord.stop();
    else {
      flutterPluginRecord.start();
      recrodingData = [];
    }
    setState(() {
      statu = !statu;
    });
  }

  ///始录制停止录制监听
  strartRecroding(RecordResponse data) {
    if (data.msg == "onStop") {
      setState(() {
        filepath = data.path;
        paths.add(filepath);
      });
    } else if (data.msg == "onStart") {
      print("开始录音----------------------");
    }
  }

  lodeData() async {
    File file = File(filepath);
    if (await file.exists()) {
      var data = await channel.invokeMethod('fft', {"path": filepath});
      recrodingData = await transfrom(data.toList());
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('还没录音')));
    }
  }

  ///将数字音频信号转换成毫秒位单位的值
  Future<List> transfrom(List data) async {
    double recrodingtime = (data.length / 8000) * 100, temp = 0;
    int flag = (data.length / recrodingtime).floor(), stp = 0;
    List<double> res = [];
    print("音频时长:$recrodingtime ms");
    setState(() {
      audioTimeLength = recrodingtime;
    });
    for (int i = 0; i < data.length; i++) {
      if (stp == flag) {
        double avg = temp / stp;
        res.add(avg);
        stp = 0;
        temp = 0;
      }
      temp += data[i];
      stp++;
    }
    return res;
  }

  ///数据左右滑动
  recrodingOffset(double offset) {
    double ofs = offset.floorToDouble();
    List<double> newList;
    left += ofs;
    right = (-left) + 100;
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
    key.currentState.setRecrodingData(newList);
  }

  @override
  void dispose() {
    super.dispose();
    flutterPluginRecord.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Text(statu ? "结束录音" : "开始录音"),
          IconButton(
            icon: Icon(statu ? Icons.stop : Icons.play_arrow),
            onPressed: startOrStop,
          ),
          Text("播放"),
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              flutterPluginRecord.play();
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: FlatButton(
              color: Colors.blue,
              child: Text('展示声音特征'),
              onPressed: () async {
                await lodeData();
                recrodingOffset(0);
              },
            ),
          ),
          Text("录音时长----- ${audioTimeLength / 1000} 秒"),
          GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails e) {
              double offset = e.delta.dx;
              recrodingOffset(offset);
            },
            child: ShowSoun(key: key, recriodingTime: this.audioTimeLength),
          ),
        ],
      ),
    );
  }
}
