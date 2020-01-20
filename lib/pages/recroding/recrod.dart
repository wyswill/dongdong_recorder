import 'dart:async';
import 'dart:io';

import 'package:asdasd/utiles.dart';
import 'package:asdasd/widgets/showSoung.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';
import 'package:flutter_plugin_record/response.dart';
import 'package:path_provider/path_provider.dart';

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
  String filepath = '', cacheFile = '/file_cache/Audio/', path = '';
  List<double> recrodingData = [], templist = [];
  GlobalKey<ShowSounState> key = GlobalKey();
  double left = 0, right = 60;
  double audioTimeLength = 0;
  int h = 0, m = 0, s = 0, temp = 0;
  Timer timer;
  @override
  void initState() {
    super.initState();
    flutterPluginRecord.init();
    flutterPluginRecord.responseFromInit.listen(responseFromInitListen);
    flutterPluginRecord.response.listen(strartRecroding);
    flutterPluginRecord.responseFromAmplitude.listen(show);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Directory directory = (await getExternalCacheDirectories())[0];
    path = directory.path + cacheFile;
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
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                setInput(),
                setCanvas(),
                Text(
                  '$h:$m:$s',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
                GestureDetector(
                  child:
                      Image.asset('asset/flag/icon_flag_white.png', width: 40),
                  onTap: setTimeStap,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: setBottonButton(),
    );
  }

  ///设置底部按钮
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
            child: GestureDetector(
              child: Image.asset('asset/icon_repeat.png', width: 40),
              onTap: reset,
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

  ///重置
  reset() {
    setState(() {
      ///消除时间
      h = 0;
      m = 0;
      s = 0;

      ///清除画布
      key.currentState.setRecrodingData([]);
      controller.text = '';
    });
  }

  ///设置时间戳
  setTimeStap() {}

  ///初始化回调监听
  responseFromInitListen(data) {
    if (data)
      print('初始化成功');
    else
      print('初始化失败');
  }

  ///播放或暂停
  startOrStop() {
    if (statu) {
      flutterPluginRecord.stop();
      timer.cancel();
    } else {
      flutterPluginRecord.start();
      recrodingData = [];
      setState(() {
        h = 0;
        m = 0;
        s = 0;
        timer = Timer.periodic(Duration(seconds: 1), (newtimer) {
          setState(() {
            s++;
            temp += 60;
            timeFormat();
          });
        });
      });
    }
    setState(() {
      statu = !statu;
    });
  }

  ///时间转换
  timeFormat() {
    if (s == 60) {
      m++;
      s = 0;
    }
    if (m == 60) {
      h++;
      m = 0;
    }
  }

  ///保存录音
  saveData() async {
    String filename = this.controller.text.trim();
    if (filename == '')
      alert(context, title: Text('警告!'), content: Text('文件标题不能为空'));
    else {
      File file = File(filepath);
      file.copySync("$path$filename.wav");
      file.delete();
      Navigator.pop(context);
    }
  }

  ///始录制停止录制监听
  strartRecroding(RecordResponse data) {
    if (data.msg == "onStop") {
      setState(() {
        filepath = data.path;
      });
    }
  }

  show(RecordResponse data) {
    double value = (double.parse(data.msg) * 250).floorToDouble();
    setdata(value);
  }

  ///录音实时写入波形
  setdata(double value) {
    List<double> newLists = [];
    if (recrodingData.length < 195) {
      this.recrodingData.add(value);
      key.currentState.setRecrodingData(recrodingData);
    } else {
      newLists = recrodingData;
      newLists.removeAt(0);
      newLists.add(value);
      key.currentState.setRecrodingData(newLists);
    }
    templist.add(value);
  }

  ///将数字音频信号转换成毫秒位单位的值
  Future<List> transfrom(List data) async {
    double recrodingtime = (data.length / 8000) * 1000, temp = 0;
    int flag = (data.length / (s * 1000)).floor(), stp = 0;
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
    key.currentState.setRecrodingData(newList);
  }
}
