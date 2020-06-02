import 'dart:async';
import 'dart:io';

import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/pages/recroding/recrod.dart';
import 'package:flutterapp/plugins/AudioPlayer.dart';
import 'package:flutterapp/plugins/Require.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:flutterapp/widgets/musicProgress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';
import '../../provider.dart';
import '../../utiles.dart';

enum bottomState { recode, playRecoding, deleteFiles }

class BottomshowBar extends StatefulWidget {
  BottomshowBar({Key key}) : super(key: key);

  @override
  _BottomshowBarState createState() => _BottomshowBarState();
}

class _BottomshowBarState extends State<BottomshowBar> with SingleTickerProviderStateMixin {
  RecroderModule plaingFile, trashFile;
  StreamSubscription streamSubscription;
  List<Map> playerIocns = [
    {'icon': 'asset/palying/icon_Sheared_blue.png', 'title': '剪辑'},
    {'icon': 'asset/palying/icon_refresh2.png', 'title': '转文字'},
  ];
  GlobalKey<MusicProgressState> key = GlobalKey();
  Animation<double> animation;
  AnimationController controller;

  double totalTime = 0;
  String currentTime = '0:0:0';
  int index;
  bottomState curentState = bottomState.recode;
  AudioPlayer audioPlayer = AudioPlayer();
  Timer timer;
  int curentPlayingTime = 0;

  @override
  void initState() {
    super.initState();

    ///动画
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 200, end: 0).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    streamSubscription = eventBus.on<PlayingFile>().listen((event) async {
      if (plaingFile == null) {
        controller.reset();
        controller.forward();
      } else {
        try {
          if (curentState == bottomState.playRecoding) key.currentState.setCurentTime(0);
        } catch (e) {}

        ///如果当前正在播放，就停止播放，并释放player,否则设置当前播放文件
        if (plaingFile.isPlaying) {
          audioPlayer.pause();
          timer.cancel();
          timer = null;
        }
      }
      setState(() {
        currentTime = '0:0:0';
        plaingFile = event.file;
        totalTime = double.parse(plaingFile.recrodingtime);
        this.curentState = bottomState.playRecoding;
        curentPlayingTime = 0;
      });
    });
    streamSubscription = eventBus.on<TrashOption>().listen((event) async {
      setState(() {
        trashFile = event.rm;
        index = event.index;
        this.curentState = bottomState.deleteFiles;
      });
      controller.reset();
      controller.forward();
    });
    streamSubscription = eventBus.on<NullEvent>().listen((event) async {
      if (this.curentState != bottomState.recode) {
        setState(() {
          plaingFile = null;
          this.curentState = bottomState.recode;
        });
        controller.reset();
        controller.forward();
      }
    });
    streamSubscription = eventBus.on<DeleteFileSync>().listen((event) async {
      if (this.curentState != bottomState.recode) {
        setState(() {
          plaingFile = null;
          this.curentState = bottomState.recode;
        });
        controller.reset();
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
    controller.dispose();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, animation.value),
      child: GetPannel(curentState),
    );
  }

  Widget GetPannel(bottomState state) {
    switch (this.curentState) {
      case bottomState.recode:
        return Container(
          padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
          decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  width: 60,
                  height: 60,
                  color: Theme.of(context).primaryColor,
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.mic),
                    onPressed: showRecroding,
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case bottomState.playRecoding:
        return Stack(
          children: <Widget>[
            ///播放面板
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
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
                                      case "剪辑":
                                        this.editor();
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
                        IconButton(
                          icon: Icon(
                            this.plaingFile.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: play,
                        ),
                        Text(currentTime, style: TextStyle(color: Colors.grey)),
                        Expanded(child: MusicProgress(key: key)),
                        Text(formatTime(totalTime.toInt()), style: TextStyle(color: Colors.grey))
                      ],
                    )
                  ],
                ),
              ),
            ),

            ///右上角叉叉
            Positioned(
              right: 0,
              child: ClipOval(
                child: Container(
                  width: 20,
                  height: 20,
                  color: Theme.of(context).primaryColor,
                  child: GestureDetector(
                    child: Icon(Icons.close, size: 20, color: Colors.white),
                    onTap: closePlayer,
                  ),
                ),
              ),
            )
          ],
        );
        break;
      case bottomState.deleteFiles:
        return Container(
          padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)],
                ),
                child: FlatButton(child: Text('删除'), onPressed: delete),
              ),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)],
                ),
                child: FlatButton(child: Text('还原'), onPressed: reset),
              ),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)],
                ),
                child: FlatButton(child: Text('取消'), onPressed: cancel),
              ),
            ],
          ),
        );
        break;
    }
  }

  ///删除
  void delete() async {
    await File(trashFile.filepath).delete();
    Provider.of<transhProvider>(context, listen: false).remove(index);
    setState(() {
      trashFile = null;
      curentState = bottomState.recode;
    });
  }

  ///还原
  void reset() async {
    File file = File(trashFile.filepath);
    String newpath = await FileUtile.getRecrodPath();
    file.copySync('$newpath${trashFile.title}.wav');
    file.deleteSync();
    trashFile.filepath = '$newpath${trashFile.title}.wav';
    Provider.of<transhProvider>(context, listen: false).remove(index);
    Provider.of<recrodListProvider>(context, listen: false).addRecrodItem(trashFile);
    cancel();
  }

  ///取消
  void cancel() {
    setState(() {
      trashFile = null;
      curentState = bottomState.recode;
    });
    controller.reset();
    controller.forward();
  }

  void showSelect() {}

  /***********播放器设置***********/

  ///播放音乐
  void play() async {
    setState(() {
      this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
    });
    eventBus.fire(PlayingState(this.plaingFile.isPlaying));
    if (plaingFile.isPlaying) {
      audioPlayer.play(this.plaingFile.filepath);
      setPlanProgress();
    } else {
      timer.cancel();
      timer = null;
      setState(() {
        this.curentPlayingTime = 0;
        this.currentTime = formatTime(curentPlayingTime * 1000);
      });
      key.currentState.setCurentTime(0);
      audioPlayer.pause();
    }
  }

  ///设置进度条
  void setPlanProgress() async {
    int totalMS = (totalTime / 1000).floor();
    timer = Timer.periodic(Duration(seconds: 1), (Timer newtimer) async {
      if (curentPlayingTime < totalMS) {
        setState(() {
          this.curentPlayingTime++;
          this.currentTime = formatTime(curentPlayingTime * 1000);
        });
        key.currentState.setCurentTime(curentPlayingTime / totalMS);
      } else {
        setState(() {
          this.plaingFile.isPlaying = false;
          timer.cancel();
          timer = null;
        });
        eventBus.fire(PlayingState(this.plaingFile.isPlaying));
        audioPlayer.pause();
      }
    });
  }

  ///右上角叉叉
  void closePlayer() {
    controller.reset();
    controller.forward();
    eventBus.fire(PlayingState(false));
    setState(() {
      plaingFile = null;
      this.curentState = bottomState.recode;
    });
  }

  ///定时选择
  void setTimeout() {}

  ///全部循环
  void circulation() {}

  ///倍速
  void pias() {}

  ///剪辑
  void editor() {
    Navigator.pushNamed(context, '/editor', arguments: this.plaingFile);
  }

  ///转文字
  void transiton() async {
    Response res = await Transiton(plaingFile.filepath);
    print(res.data);
    if (res.data['ret'] != 0) {
      alert(context, title: Text('语音识别错误'), content: Text(res.data['msg']));
    } else {
      var task_id = res.data['data']['task_id'];
    }
  }

  ///更多
  void more() {}

/*******************************/

  /// 跳转到录音页面
  void showRecroding() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomCenter,
            child: Recrod(),
          );
        },
      ),
    );
  }
}
