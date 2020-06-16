import 'dart:async';
import 'dart:io';

import 'package:flutter_plugin_record/flutter_plugin_record.dart';
import 'package:flutter_plugin_record/response.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/utiles.dart';
import 'package:flutterapp/widgets/showSoung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';

class Recrod extends StatefulWidget {
  Recrod({Key key}) : super(key: key);

  @override
  _RecrodState createState() => _RecrodState();
}

class _RecrodState extends State<Recrod> with WidgetsBindingObserver {
  FocusNode node = FocusNode();
  TextEditingController controller;

  FlutterPluginRecord flutterPluginRecord = FlutterPluginRecord();
  bool statu = false;
  String filepath = '', path = '';
  int leng = (130 * 1.1).floor();
  List<int> recrodingData = List<int>.filled((130 * 1.1).floor(), 0, growable: true), templist = [];
  GlobalKey<ShowSounState> key = GlobalKey();
  double left = 0, right = 60;
  double audioTimeLength = 0;
  int h = 0, m = 0, s = 0, temp = 0;
  Timer timer;

  ///和native通讯
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  @override
  void initState() {
    super.initState();
    print(leng);
    flutterPluginRecord.init();
    flutterPluginRecord.responseFromInit.listen(responseFromInitListen);
    flutterPluginRecord.response.listen(strartRecroding);
    flutterPluginRecord.responseFromAmplitude.listen(show);
    DateTime dateTime = DateTime.now();
    String defaultTitle = '${dateTime.year}.${dateTime.month}.${dateTime.day}-${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
    controller = TextEditingController(text: defaultTitle);

    ///获取实例

    ///添加第一帧回调
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        setState(() {
          node.unfocus();
        });
      }
      key.currentState.setRecrodingData(recrodingData);
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    path = await FileUtile.getRecrodPath();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    flutterPluginRecord.dispose();
    node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        title: Center(child: Text('录音')),
        actions: <Widget>[IconButton(icon: Icon(Icons.close), onPressed: exit)],
      ),
      body: WillPopScope(
        onWillPop: exit,
        child: Stack(
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
                    child: Image.asset('asset/flag/icon_flag_white.png', width: 40),
                    onTap: setTimeStap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: setBottonButton(),
    );
  }

  ///设置底部按钮
  Widget setBottonButton() {
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Color.fromRGBO(80, 69, 112, 1), blurRadius: 20, offset: Offset(-20, 0)),
        BoxShadow(color: Color.fromRGBO(80, 69, 112, 1), blurRadius: 15, offset: Offset(-15, 0)),
        BoxShadow(color: Color.fromRGBO(80, 69, 112, 1), blurRadius: 5, offset: Offset(-5, 0)),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          setInk(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            bgColor: Color.fromRGBO(113, 119, 219, 1),
            ontap: reset,
            child: SizedBox(width: 30, height: 30, child: Icon(Icons.refresh, color: Colors.white, size: 20)),
          ),
          setInk(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              bgColor: Theme.of(context).primaryColor,
              highlightColor: Color.fromRGBO(113, 119, 219, 1),
              ontap: startOrStop,
              child: Container(width: 60, height: 60, child: Icon(statu ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 50))),
          setInk(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            bgColor: Color.fromRGBO(113, 119, 219, 1),
            ontap: saveData,
            child: Container(width: 30, height: 30, child: Icon(Icons.stop, color: Colors.white, size: 20)),
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
        decoration: InputDecoration(border: InputBorder.none, hintText: '输入录音标题', hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  ///设置音频波形画布
  Widget setCanvas() {
    return ShowSoun(key: key, recriodingTime: this.audioTimeLength);
  }

  Future<bool> exit() {
    return alert(context, title: Text('确定退出么？'), actions: <Widget>[
      FlatButton(
        child: Text('确定'),
        onPressed: () async {
          if (filepath.isNotEmpty) await File(filepath).delete();
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text(
          '取消',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ]);
  }

  ///重置
  reset() {
    if (statu) {
      this.startOrStop();
      if (filepath.isNotEmpty)
        clean(filepath);
      else
        Future.delayed(Duration(milliseconds: 300), () => {if (filepath.isNotEmpty) clean(filepath)});
    } else {
      setState(() {
        ///消除时间
        h = 0;
        m = 0;
        s = 0;

        /// 消除filepath
        filepath = '';

        ///清除画布
        key.currentState.setRecrodingData([]);
        controller.text = '';
      });
    }
  }

  clean(String path) {
    File file = File(path);
    file.deleteSync();
    setState(() {
      ///消除时间
      h = 0;
      m = 0;
      s = 0;

      /// 消除filepath
      filepath = '';

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
  startOrStop() async {
    if (statu) {
      flutterPluginRecord.stop();
      timer.cancel();
      setState(() {
        statu = false;
      });
    } else {
      flutterPluginRecord.start();
      setState(() {
        h = 0;
        m = 0;
        s = 0;
        statu = true;
        timer = Timer.periodic(Duration(seconds: 1), (newtimer) {
          setState(() {
            s++;
            temp += 60;
            timeFormat();
          });
        });
      });
    }
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
    if (this.statu) {
      flutterPluginRecord.stop();
      timer.cancel();
      await check();
    } else
      await check();
  }

  ///检查标题
  check() async {
    String filename = this.controller.text.trim();
    if (filename == '')
      alert(context, title: Text('警告!'), content: Text('文件标题不能为空'));
    else if (filepath.isNotEmpty) {
      try {
        RecroderModule res = await FileUtile.pathTOModule(path: filepath, newFileName: filename, channel: channel);
        Provider.of<RecordListProvider>(context, listen: false).addRecrodItem(res);
        Navigator.pop(context);
      } catch (e) {
        print(e);
        Provider.of<RecordListProvider>(context, listen: false).init(await FileUtile.getlocalMusic(channel: channel));
        Navigator.pop(context);
      }
    } else {
      alert(context, title: Text('没有录制音频'));
    }
  }

  ///始录制停止录制监听
  strartRecroding(RecordResponse data) async {
    if (data.msg == "onStop") {
      print(data.path);
      setState(() {
        filepath = data.path;
      });
    }
  }

  ///插件回调
  show(RecordResponse data) {
    double value = (double.parse(data.msg) * 250).floorToDouble();
    setdata(value);
  }

  ///录音实时写入波形
  setdata(double value) {
    List<int> newLists = [];
    if (recrodingData.length <= leng) {
      this.recrodingData.add(value.round());
    } else {
      newLists = recrodingData;
      newLists.removeAt(0);
      newLists.add(value.round());
    }
    key.currentState.setRecrodingData(recrodingData);
    templist.add(value.round());
  }
}
