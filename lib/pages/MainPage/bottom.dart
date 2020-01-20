import 'dart:async';

import 'package:asdasd/modus/record.dart';
import 'package:asdasd/pages/recroding/recrod.dart';
import 'package:asdasd/widgets/musicProgress.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../event_bus.dart';
import '../../utiles.dart';

class BottomshowBar extends StatefulWidget {
  BottomshowBar({Key key}) : super(key: key);

  @override
  _BottomshowBarState createState() => _BottomshowBarState();
}

class _BottomshowBarState extends State<BottomshowBar>
    with SingleTickerProviderStateMixin {
  RecroderModule plaingFile;
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
  AudioPlayer audioPlayer = AudioPlayer();
  double totalTime = 0;
  String currenttime = '0:0:0';
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 200, end: 0).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    streamSubscription = eventBus.on<PlayingFile>().listen((event) async {
      if (plaingFile == null) {
        controller.reset();
        controller.forward();
      }
      currenttime = '0:0:0';
      plaingFile = event.file;
      totalTime = double.parse(plaingFile.recrodingtime);
      await audioPlayer.setUrl(plaingFile.filepath, isLocal: true);
      await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
      setState(() {});
    });
    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      double curentProgress = (d.inMilliseconds / totalTime);
      key.currentState.setCurentTime(curentProgress);
      setState(() {
        currenttime = formatTime(d.inMilliseconds);
      });
    });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (s == AudioPlayerState.COMPLETED) {
        setState(() {
          this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
        });
        eventBus.fire(PlayingState(this.plaingFile.isPlaying));
      }
      if (s == AudioPlayerState.STOPPED) key.currentState.setCurentTime(2);
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
    if (plaingFile != null) {
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
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {},
                                        child: Image.asset(
                                          e['icon'],
                                          width: 25,
                                        ),
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
                                ))
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
                        Text(currenttime, style: TextStyle(color: Colors.grey)),
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
                    onTap: () {
                      setState(() {
                        plaingFile = null;
                      });
                      controller.reset();
                      controller.forward();
                      eventBus.fire(PlayingState(false));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else
      return Transform.translate(
        offset: Offset(0, animation.value),
        child: Container(
          padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
          decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)
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
  }

  ///播放音乐
  void play() async {
    setState(() {
      this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
    });
    eventBus.fire(PlayingState(this.plaingFile.isPlaying));
    if (plaingFile.isPlaying)
      await audioPlayer.play(plaingFile.filepath, isLocal: true);
    else
      await audioPlayer.pause();
  }

  ///定时选择
  void showSelect() {}

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
