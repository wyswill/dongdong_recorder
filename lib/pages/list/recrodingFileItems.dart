import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/plugins/AudioPlayer.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:flutterapp/widgets/musicProgress.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

import '../../provider.dart';
import '../../utiles.dart';

class RecordingFileItems extends StatefulWidget {
  const RecordingFileItems({
    Key key,
    this.curentFile,
    this.index,
  }) : super(key: key);
  final RecroderModule curentFile;
  final int index;

  @override
  _RecordingFileItemsState createState() => _RecordingFileItemsState();
}

class _RecordingFileItemsState extends State<RecordingFileItems> with SingleTickerProviderStateMixin {
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  List<Map> playerIocns = [
    {'icon': 'asset/paling/icon_Sheared_blue.png', 'title': '剪辑'},
    {'icon': 'asset/sheared/icon_copy_blue.png', 'title': '重命名'},
    {'icon': 'asset/sheared/icon_remove_blue.png', 'title': '删除'},
    {'icon': 'asset/share-alt.png', 'title': '分享'},
  ];
  AudioPlayer audioPlayer = AudioPlayer();
  String currentTime = '0:0:0';
  GlobalKey<MusicProgressState> key = GlobalKey();
  Timer timer;
  double totalTime = 0, height = 60;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  int currentPlayingTime = 0;

  @override
  void initState() {
    totalTime = widget.curentFile.recrodingtime;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return setInk(
      bgColor: Colors.white,
      ontap: cancle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width,
        height: widget.curentFile.isActive ? 115 : 60,
        padding: EdgeInsets.only(left: 10, right: 20),
        decoration: BoxDecoration(
          border: Border(
            left: widget.curentFile.isActive ? BorderSide(width: 6, color: Theme.of(context).primaryColor) : BorderSide(width: 0),
            bottom: BorderSide(width: 1, color: Color.fromRGBO(240, 240, 246, 1)),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: widget.curentFile.isActive ? 5 : 15, top: 5),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(right: 10),
                      child: IconButton(
                        iconSize: 25,
                        padding: EdgeInsets.all(0),
                        icon: Icon(this.widget.curentFile.isPlaying ? Icons.pause : Icons.play_arrow, color: Theme.of(context).primaryColor),
                        onPressed: play,
                      ),
                    ),
                    Text(
                      widget.curentFile.title,
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text('${formatTime(widget.curentFile.recrodingtime.truncate())}', style: textStyle),
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 5), child: Text(widget.curentFile.fileSize, style: textStyle)),
                  Expanded(child: Container()),
                  Container(child: Text(widget.curentFile.lastModified, style: textStyle))
                ],
              ),
              Offstage(
                offstage: !widget.curentFile.isActive,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(currentTime, style: TextStyle(color: Colors.grey)),
                        Expanded(child: MusicProgress(key: key, margin: EdgeInsets.symmetric(vertical: 10))),
                        Text(formatTime(widget.curentFile.recrodingtime.truncate()), style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: playerIocns
                            .map(
                              (e) => Container(
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
                                      case "分享":
                                        this.shear();
                                        break;
                                    }
                                  },
                                  child: Column(
                                    children: <Widget>[Image.asset(e['icon'], width: 25), Text(e['title'], style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12))],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void shear() {
    ShareExtend.share(widget.curentFile.filepath, "wav");
  }

  ///还原滑动
  void cancle() {
    if (Provider.of<RecordListProvider>(context, listen: false).preIndex == widget.index) return;
    Provider.of<RecordListProvider>(context, listen: false).changeState(widget.index);
  }

  void deleteFile() {
    checkIsPlaingAndDoOtherThing().then((value) async {
      RecroderModule _rm = await Provider.of<RecordListProvider>(context, listen: false).deleteFile(widget.index);
      Provider.of<TranshProvider>(context, listen: false).trashs.add(_rm);
    });
  }

  ///剪辑
  void editor() {
    checkIsPlaingAndDoOtherThing().then((value) => Navigator.pushNamed(context, '/editor', arguments: {'rm': widget.curentFile, 'index': widget.index}));
  }

  ///播放音乐
  void play() async {
    if (widget.curentFile.isPlaying) {
      audioPlayer.pause();
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      this.reseProgress();
    } else {
      this.reseProgress();
      setPlanProgress();
      audioPlayer.play(this.widget.curentFile.filepath);
    }
    setState(() {
      this.widget.curentFile.isPlaying = !this.widget.curentFile.isPlaying;
    });
  }

  ///设置进度条
  void setPlanProgress() async {
    timer = Timer.periodic(Duration(seconds: 1), (Timer newtimer) async {
      if (currentPlayingTime <= totalTime.truncate() - 1) {
        this.currentPlayingTime++;
        this.currentTime = formatTime(currentPlayingTime);
        key.currentState.setCurentTime(currentPlayingTime / totalTime.truncate());
        setState(() {});
      } else {
        key.currentState.setCurentTime(1);
        setState(() {
          widget.curentFile.isPlaying = false;
          timer.cancel();
          timer = null;
        });
        audioPlayer.pause();
      }
    });
  }

  ///重置进度条
  void reseProgress() {
    setState(() {
      this.currentPlayingTime = 0;
      this.currentTime = formatTime(currentPlayingTime);
    });
    key.currentState.setCurentTime(0);
  }

  ///播放中时进行其他操作
  Future checkIsPlaingAndDoOtherThing() async {
    if (widget.curentFile.isPlaying) {
      audioPlayer.pause();
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      this.widget.curentFile.isPlaying = false;
      this.reseProgress();
    }
  }

  ///改名
  void changeName() {
    checkIsPlaingAndDoOtherThing().then(
      (value) => alert(
        context,
        title: Text('请输入要修改的名称:'),
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
            onPressed: () async {
              String newName = _textEditingController.text.trim();
              if (newName.isNotEmpty) {
                String newpath = await Provider.of<RecordListProvider>(context, listen: false).reName(index: widget.index, newName: newName);
                widget.curentFile.title = newName;
                widget.curentFile.filepath = newpath;
                _textEditingController.clear();
                Navigator.pop(context);
              } else
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
      ),
    );
  }
}
