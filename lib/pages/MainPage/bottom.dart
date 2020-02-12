import 'dart:async';
import 'dart:io';

import 'package:asdasd/modus/record.dart';
import 'package:asdasd/pages/recroding/recrod.dart';
import 'package:asdasd/widgets/musicProgress.dart';

//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:path_provider/path_provider.dart';

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
    {'icon': 'asset/palying/icon_timing.png', 'title': '定时'},
    {'icon': 'asset/palying/icon_Circulat_blue.png', 'title': '全部循环'},
    {'icon': 'asset/palying/icon_speed_normal.png', 'title': '倍速'},
    {'icon': 'asset/palying/icon_Sheared_blue.png', 'title': '剪辑'},
    {'icon': 'asset/palying/icon_refresh2.png', 'title': '转文字'},
    {'icon': 'asset/palying/icon_more-menu_blue.png', 'title': '更多'},
  ];
  GlobalKey<MusicProgressState> key = GlobalKey();
  Animation<double> animation;
  AnimationController controller;

  AudioPlayer audioPlayer;
  double totalTime = 0;
  String currenttime = '0:0:0';
  int index;
  bottomState curentState = bottomState.recrod;

  ///和native通讯
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  @override
  void initState() {
    super.initState();

    ///动画
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 200, end: 0).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    ///音乐播放
    initAudioPlayer();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
  }

//  void initAudioPlayer() {
//    audioPlayer = AudioPlayer();
//
//    audioPlayer.onAudioPositionChanged.listen((Duration d) {
//      double curentProgress = (d.inMilliseconds / totalTime);
//      key.currentState.setCurentTime(curentProgress);
//      setState(() {
//        currenttime = formatTime(d.inMilliseconds);
//      });
//    });
//    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
//      if (s == AudioPlayerState.COMPLETED) {
//        setState(() {
//          this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
//          this.currenttime = formatTime(totalTime.toInt());
//        });
//        eventBus.fire(PlayingState(this.plaingFile.isPlaying));
//        key.currentState.setCurentTime(2);
//      }
//    });
//    audioPlayer.onPlayerError.listen((err) {
//      print(err);
//    });
//  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    streamSubscription = eventBus.on<PlayingFile>().listen((event) async {
      if (plaingFile == null) {
        controller.reset();
        controller.forward();
      }
      currenttime = '0:0:0';
      plaingFile = event.file;
      totalTime = double.parse(plaingFile.recrodingtime);
      initAudioPlayer();
//      await audioPlayer.setUrl(plaingFile.filepath, isLocal: true);
//      await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
      setState(() {
        this.curentState = bottomState.playRecroding;
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
      if (this.curentState != bottomState.recrod) {
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
    audioPlayer.dispose();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.timer),
                      onPressed: showSelect,
                    ),
                  ),
                ),
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
                ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.text_rotation_down),
                      onPressed: () {},
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
    setState(() {
      trashFile = null;
      curentState = bottomState.recrod;
    });
    eventBus.fire(TrashDeleted(index: index));
  }

  ///还原
  void reset() async {
    File file = File(trashFile.filepath);
    String cacheFile = '/file_cache/Audio/',
        newPath = ((await getExternalCacheDirectories())[0]).path;
    Directory directory = Directory(newPath + cacheFile);
    if (!directory.existsSync()) directory.createSync();
    await file.copy('$newPath$cacheFile${trashFile.title}.wav');
    file.delete();
    cancel();
    eventBus.fire(TrashDeleted(index: index));
  }

  ///取消
  void cancel() {
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
    this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
    eventBus.fire(PlayingState(this.plaingFile.isPlaying));
    if (plaingFile.isPlaying) {
//      var res =
//          await channel.invokeMethod("playMusic", {"path", plaingFile.filepath});
      print(plaingFile.filepath);
      await audioPlayer.play(plaingFile.filepath);
//      await audioPlayer.play(plaingFile.filepath, isLocal: true);
    } else {
      await audioPlayer.pause();
//      await audioPlayer.pause();
    }
  }

  ///右上角叉叉
  void closePlayer() {
    controller.reset();
    controller.forward();
    eventBus.fire(PlayingState(false));
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
    Navigator.popAndPushNamed(context, '/editor', arguments: this.plaingFile);
  }

  ///转文字
  void transiton() {}

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
