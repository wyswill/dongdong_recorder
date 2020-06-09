import 'dart:async';
import 'dart:io';

import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/pages/recroding/recrod.dart';
import 'package:flutterapp/plugins/AudioPlayer.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:flutterapp/widgets/musicProgress.dart';
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
    {'icon': 'asset/paling/icon_Sheared_blue.png', 'title': '剪辑'},
    {'icon': 'asset/paling/icon_Sheared_blue.png', 'title': '重命名'},
    {'icon': 'asset/paling/icon_Sheared_blue.png', 'title': '删除'},
  ];
  GlobalKey<MusicProgressState> key = GlobalKey();
  Animation<double> animation;
  AnimationController controller;

  double totalTime = 0;
  String currentTime = '0:0:0';
  int index;
  bottomState currentState = bottomState.recode;
  AudioPlayer audioPlayer = AudioPlayer();
  Timer timer;
  int currentPlayingTime = 0;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

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

    ///播放音乐
    streamSubscription = eventBus.on<PlayingFile>().listen((event) async {
      if (plaingFile == null) {
        controller.reset();
        controller.forward();
      } else {
        try {
          if (currentState == bottomState.playRecoding) key.currentState.setCurentTime(0);
        } catch (e) {}

        ///如果当前正在播放，就停止播放，并释放player,否则设置当前播放文件
        if (plaingFile.isPlaying) {
          audioPlayer.pause();
          timer.cancel();
          timer = null;
          plaingFile.isPlaying = false;
        }
      }
      setState(() {
        currentTime = '0:0:0';
        plaingFile = event.file;
        index = event.index;
        totalTime = (plaingFile.recrodingtime);
        this.currentState = bottomState.playRecoding;
        currentPlayingTime = 0;
      });
    });
    ///显示回收站操作选项
    streamSubscription = eventBus.on<TrashOption>().listen((event) async {
      setState(() {
        trashFile = event.rm;
        index = event.index;
        this.currentState = bottomState.deleteFiles;
      });
      controller.reset();
      controller.forward();
    });
    ///回收站页面退出时将panel切换
    streamSubscription = eventBus.on<NullEvent>().listen((event) async {
      if (this.currentState != bottomState.recode) {
        setState(() {
          plaingFile = null;
          this.currentState = bottomState.recode;
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
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, animation.value),
      child: GetPanel(currentState),
    );
  }

  // ignore: missing_return, non_constant_identifier_names
  Widget GetPanel(bottomState state) {
    switch (this.currentState) {
      case bottomState.recode:
        return Container(
          padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
          decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)]),
          child: Center(
            child: setInk(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              bgColor: Theme.of(context).primaryColor,
              highlightColor: Color.fromRGBO(113, 119, 219, 1),
              ontap: showRecroding,
              child: Container(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
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
                        children: playerIocns
                            .map(
                              (e) => Container(
                                width: 70,
                                child: setInk(
                                  ontap: () {
                                    switch (e['title']) {
                                      case "删除":
                                        this.deleteFile();
                                        break;
                                      case "重命名":
                                        this.changeName();
                                        break;
                                      case "剪辑":
                                        this.editor();
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
                                ),
                              ),
                            )
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

  void deleteFile() async {
    RecroderModule _rm = await Provider.of<RecordListProvider>(context, listen: false).deleteFile(index);
    Provider.of<TranshProvider>(context, listen: false).trashs.add(_rm);
  }

  ///删除
  void delete() async {
    await File(trashFile.filepath).delete();
    Provider.of<TranshProvider>(context, listen: false).remove(index);
    setState(() {
      trashFile = null;
      currentState = bottomState.recode;
    });
  }

  ///改名
  void changeName() {
    alert(
      context,
      title: Text('要改名？！！！'),
      content: TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        autofocus: true,
        maxLength: 15,
        decoration: InputDecoration(hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            String newName = _textEditingController.text.trim();
            Provider.of<RecordListProvider>(context, listen: false).reName(index: index, newName: newName);
            Navigator.pop(context);
          },
          child: Text('确定修改'),
        ),
        FlatButton(
          onPressed: () {
            _textEditingController.text = '';
            _focusNode.unfocus();
            Navigator.pop(context);
          },
          child: Text('放弃修改'),
        ),
      ],
    );
  }

  ///还原
  void reset() async {
    File file = File(trashFile.filepath);
    String newpath = await FileUtile.getRecrodPath();
    file.copySync('$newpath${trashFile.title}.wav');
    file.deleteSync();
    trashFile.filepath = '$newpath${trashFile.title}.wav';
    Provider.of<TranshProvider>(context, listen: false).remove(index);
    Provider.of<RecordListProvider>(context, listen: false).addRecrodItem(trashFile);
    cancel();
  }

  ///取消
  void cancel() {
    setState(() {
      trashFile = null;
      currentState = bottomState.recode;
    });
    controller.reset();
    controller.forward();
  }

  /***********播放器设置***********/

  ///播放音乐
  void play() async {
    setState(() {
      this.plaingFile.isPlaying = !this.plaingFile.isPlaying;
    });
    if (plaingFile.isPlaying) {
      audioPlayer.play(this.plaingFile.filepath);
      setPlanProgress();
    } else {
      if (timer != null) timer.cancel();
      timer = null;
      setState(() {
        this.currentPlayingTime = 0;
        this.currentTime = formatTime(currentPlayingTime * 1000);
      });
      key.currentState.setCurentTime(0);
      audioPlayer.pause();
    }
  }

  ///设置进度条
  void setPlanProgress() async {
    int totalMS = (totalTime / 1000).floor();
    timer = Timer.periodic(Duration(seconds: 1), (Timer newtimer) async {
      if (currentPlayingTime < totalMS) {
        setState(() {
          this.currentPlayingTime++;
          this.currentTime = formatTime(currentPlayingTime * 1000);
        });
        key.currentState.setCurentTime(currentPlayingTime / totalMS);
      } else {
        setState(() {
          this.plaingFile.isPlaying = false;
          timer.cancel();
          timer = null;
        });
        audioPlayer.pause();
      }
    });
  }

  ///右上角叉叉
  void closePlayer() {
    controller.reset();
    controller.forward();
    setState(() {
      plaingFile = null;
      this.currentState = bottomState.recode;
    });
    Provider.of<RecordListProvider>(context, listen: false).reset(isNoti: true);
  }

  ///剪辑
  void editor() {
    Navigator.pushNamed(context, '/editor', arguments: {'rm': plaingFile, 'index': index});
  }

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
