import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:asdasd/modus/record.dart';
import 'package:asdasd/pages/recroding/recrod.dart';
import 'package:asdasd/plugins/AudioPlayer.dart';
import 'package:asdasd/plugins/Require.dart';
import 'package:asdasd/widgets/musicProgress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../event_bus.dart';
import '../../utiles.dart';

enum bottomState { recrod, playRecroding, deleteFiles }

class BottomshowBar extends StatefulWidget {
  BottomshowBar({Key key}) : super(key: key);

  @override
  _BottomshowBarState createState() => _BottomshowBarState();
}

class _BottomshowBarState extends State<BottomshowBar>
    with SingleTickerProviderStateMixin {
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
  String currenttime = '0:0:0';
  int index;
  bottomState curentState = bottomState.recrod;
  AudioPlayer audioPlayer = AudioPlayer();
  Timer timer;
  int curentPlayingTime = 0;

  @override
  void initState() {
    super.initState();

    ///动画
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 200, end: 0).animate(controller);
    controller.forward();
    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    streamSubscription = eventBus.on<PlayingFile>().listen((event) async {
      if (plaingFile == null) {
        controller.reset();
        controller.forward();
      }
      try {
        if (curentState == bottomState.playRecroding)
          key.currentState.setCurentTime(0);
      } catch (e) {}
      if (mounted)
        setState(() {
          currenttime = '0:0:0';
          plaingFile = event.file;
          totalTime = double.parse(plaingFile.recrodingtime);
          this.curentState = bottomState.playRecroding;
          curentPlayingTime = 0;
        });
    });
    streamSubscription = eventBus.on<TrashOption>().listen((event) async {
      if (mounted)
        setState(() {
          trashFile = event.rm;
          index = event.index;
          this.curentState = bottomState.deleteFiles;
        });
      controller.reset();
      controller.forward();
    });
    streamSubscription = eventBus.on<NullEvent>().listen((event) async {
      if (this.curentState != bottomState.recrod) {
        if (mounted)
          setState(() {
            plaingFile = null;
            this.curentState = bottomState.recrod;
          });
        controller.reset();
        controller.forward();
      }
    });
    streamSubscription = eventBus.on<DeleteFileSync>().listen((event) async {
      if (this.curentState != bottomState.recrod) {
        if (mounted)
          setState(() {
            plaingFile = null;
            this.curentState = bottomState.recrod;
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
  Widget build(BuildContext context) {
    switch (this.curentState) {
      case bottomState.recrod:
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Container(
            padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)
                ]),
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
          ),
        );
        break;
      case bottomState.playRecroding:
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Stack(
            children: <Widget>[
              ///播放面板
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(right: 13, top: 15, bottom: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 7),
                            blurRadius: 20)
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                              this.plaingFile.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: play,
                          ),
                          Text(currenttime,
                              style: TextStyle(color: Colors.grey)),
                          Expanded(child: MusicProgress(key: key)),
                          Text(formatTime(totalTime.toInt()),
                              style: TextStyle(color: Colors.grey))
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
          ),
        );
        break;
      case bottomState.deleteFiles:
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Container(
            padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)
              ],
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
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(187, 187, 187, 0.4),
                          offset: Offset(0, 0),
                          blurRadius: 5)
                    ],
                  ),
                  child: FlatButton(child: Text('删除'), onPressed: delete),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(187, 187, 187, 0.4),
                          offset: Offset(0, 0),
                          blurRadius: 5)
                    ],
                  ),
                  child: FlatButton(child: Text('还原'), onPressed: reset),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(187, 187, 187, 0.4),
                          offset: Offset(0, 0),
                          blurRadius: 5)
                    ],
                  ),
                  child: FlatButton(child: Text('取消'), onPressed: cancel),
                ),
              ],
            ),
          ),
        );
        break;
    }
  }

  ///删除
  void delete() async {
    await File(trashFile.filepath).delete();
    if (mounted)
      setState(() {
        trashFile = null;
        curentState = bottomState.recrod;
      });
    eventBus.fire(TrashDeleted(index: index));
  }

  ///还原
  void reset() async {
    File file = File(trashFile.filepath);
    FileUtile fileUtile = new FileUtile();
    String newpath = await fileUtile.getRecrodPath();
    String deletePath = await fileUtile.getRecrodPath(isDelete: true);
    Directory directory = Directory(newpath);
    if (!directory.existsSync()) directory.createSync();
    await file
        .copy('$newpath${trashFile.title.replaceAll(deletePath, '')}.wav');
    file.delete();
    cancel();
    eventBus.fire(TrashDeleted(index: index));
  }

  ///取消
  void cancel() {
    if (mounted)
      setState(() {
        trashFile = null;
        curentState = bottomState.recrod;
      });
    controller.reset();
    controller.forward();
  }

  void showSelect() {}

  /***********播放器设置***********/

  ///播放音乐
  void play() async {
    if (mounted)
      setState(() {
        this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
      });
    eventBus.fire(PlayingState(this.plaingFile.isPlaying));
    if (plaingFile.isPlaying) {
      await audioPlayer.play(this.plaingFile.filepath);
      await setPlanProgress();
    } else {
      timer.cancel();
      timer = null;
      if (mounted)
        setState(() {
          this.curentPlayingTime = 0;
          this.currenttime = formatTime(curentPlayingTime * 1000);
        });
      key.currentState.setCurentTime(0);
      await audioPlayer.pause();
    }
  }

  ///设置进度条
  void setPlanProgress() async {
    int totalMS = (totalTime / 1000).floor();
    timer = Timer.periodic(Duration(seconds: 1), (Timer newtimer) async {
      if (curentPlayingTime < totalMS) {
        if (mounted)
          setState(() {
            this.curentPlayingTime++;
            this.currenttime = formatTime(curentPlayingTime * 1000);
          });
        key.currentState.setCurentTime(curentPlayingTime / totalMS);
      } else {
        if (mounted)
          setState(() {
            this.plaingFile.isPlaying = false;
            timer.cancel();
            timer = null;
          });
        eventBus.fire(PlayingState(this.plaingFile.isPlaying));
        await audioPlayer.pause();
      }
    });
  }

  ///右上角叉叉
  void closePlayer() {
    controller.reset();
    controller.forward();
    eventBus.fire(PlayingState(false));
    if (mounted)
      setState(() {
        plaingFile = null;
        this.curentState = bottomState.recrod;
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
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
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
