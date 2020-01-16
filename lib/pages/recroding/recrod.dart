import 'dart:async';

import 'package:asdasd/widgets/showSoung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';
import 'package:flutter_plugin_record/response.dart';

class Recrod extends StatefulWidget {
  Recrod({Key key}) : super(key: key);

  @override
  _RecrodState createState() => _RecrodState();
}

class _RecrodState extends State<Recrod> {
  FocusNode node = FocusNode();
  TextEditingController controller = TextEditingController();

  FlutterPluginRecord flutterPluginRecord = FlutterPluginRecord();
  bool statu = false;
  String filepath = '';
  List<String> paths = [];
  List<double> recrodingData = [
    12,
    3,
    123,
    123,
    1,
    23,
    12,
    31,
    231,
    2,
    12,
    31,
    23,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33,
    3,
    123,
    123,
    1,
    23,
    12,
    31,
    231,
    2,
    12,
    31,
    23,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33,
    3,
    123,
    123,
    1,
    23,
    12,
    31,
    231,
    2,
    12,
    31,
    23,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33,
    3,
    123,
    123,
    1,
    23,
    12,
    31,
    231,
    2,
    12,
    31,
    23,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33,
    3,
    123,
    123,
    1,
    23,
    12,
    31,
    231,
    2,
    12,
    31,
    23,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33,
    3,
    123,
    123,
    1,
    23,
    12,
    31,
    231,
    2,
    12,
    31,
    23,
    2,
    3,
    14,
    12,
    41,
    234,
    12,
    33
  ];
  GlobalKey<ShowSounState> key = GlobalKey();
  double left = 0, right = 60;
  double audioTimeLength = 0;
  MethodChannel channel = const MethodChannel("com.lanwanhudong");
  String recrodinTime = '00:00:00';
  Timer timer;
  @override
  void initState() {
    super.initState();
    flutterPluginRecord.init();
    flutterPluginRecord.responseFromInit.listen(responseFromInitListen);
    flutterPluginRecord.response.listen(strartRecroding);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    flutterPluginRecord.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        title: Center(
          child: Text('录音'),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            setInput(),
            setCanvas(),
            Text(
              recrodinTime,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: setBottonButton(),
    );
  }

  Widget setBottonButton() {
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipOval(
            child: Container(
              width: 40,
              height: 40,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.redo),
                onPressed: setTimer,
              ),
            ),
          ),
          ClipOval(
            child: Container(
              width: 60,
              height: 60,
              color: Colors.white,
              child: IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(statu ? Icons.stop : Icons.mic),
                onPressed: startOrStop,
              ),
            ),
          ),
          ClipOval(
            child: Container(
              width: 40,
              height: 40,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.check),
                onPressed: saveData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///输入框
  Widget setInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
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
    );
  }

  ///设置音频波形画布
  Widget setCanvas() {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails e) {
        double offset = e.delta.dx;
        recrodingOffset(offset);
      },
      child: ShowSoun(key: key, recriodingTime: this.audioTimeLength),
    );
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
    setTimer();
    setState(() {
      statu = !statu;
    });
  }

  ///设置定时器
  setTimer() {
    //在播放
    if (statu) {
      setState(() {
        this.recrodinTime = '';
      });
      timer.cancel();
    } else {
      setState(() {
        statu = true;
        // timer = 
      });
    }
  }

  ///保存录音
  saveData() {}

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
    right = (-left) + 60;
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
}
