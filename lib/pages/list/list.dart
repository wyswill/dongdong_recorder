import 'dart:async';
import 'dart:io';
import 'package:asdasd/event_bus.dart';
import 'package:asdasd/modus/record.dart';
import 'package:asdasd/pages/list/recrodingFileItems.dart';
import 'package:asdasd/utiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecrodingList extends StatefulWidget {
  RecrodingList({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _RecrodingListState createState() => _RecrodingListState();
}

class _RecrodingListState extends State<RecrodingList> {
  Map<String, List<RecroderModule>> datas = {};
  List dataKeys = [];
  List<bool> activeManages = [];
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  RecroderModule currentPlayRecording;
  String key;
  int currentIndex;
  String cacheFile = '/file_cache/Audio/', path = '';
  MethodChannel channel = const MethodChannel("com.lanwanhudong");
  StreamSubscription streamSubscription;

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    ///初始化文件夹
    await initFlouter();
    dataKeys = datas.keys.toList();
    if (mounted) setState(() {});

    ///event_bus订阅消息
    streamSubscription = eventBus.on<PlayingState>().listen((event) {
      if (mounted)
        setState(() {
          currentPlayRecording.isPlaying = event.state;
          currentPlayRecording.isActive = event.state;
        });
    });
    streamSubscription = eventBus.on<DeleteFileSync>().listen((event) {
      if (mounted) {
        String attr = event.attr;
        int index = event.index;
        datas[attr].removeAt(index);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: List.generate(this.dataKeys.length, (int index) {
          return buildRecrodingItem(index);
        }),
      ),
    );
  }

  ///每组录音数据样式
  Widget buildRecrodingItem(int index) {
    String curnetKey = dataKeys[index];
    List<RecroderModule> curentRecrodingFiles = this.datas[curnetKey];
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20),
            color: Color.fromRGBO(242, 241, 244, 1),
            child: Text(curnetKey),
          ),
          Column(
            children: List.generate(curentRecrodingFiles.length, (int ind) {
              RecroderModule curentFile = curentRecrodingFiles[ind];
              return RecrodingFileItems(
                curentFile: curentFile,
                playRecroding: this.playRecording,
                index: ind,
                curnetKey: curnetKey,
              );
            }),
          )
        ],
      ),
    );
  }

  /// 递归方式获取录音文件
  _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        String filename = file.path.replaceAll(path, '').toLowerCase();
        if (filename.endsWith(".wav") || filename.endsWith('.mp3')) {
          DateTime dateTime = await file.lastModified();
          String attr = '${dateTime.year}年${dateTime.month}月';
          var res = await channel.invokeMethod('getSize', {"path": file.path});
          double s = (res % (1000 * 60) / 1000);
          RecroderModule rm = RecroderModule(
            title: filename.replaceAll('.wav', ''),
            filepath: file.path,
            recrodingtime: "$res",
            lastModified:
                '${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
            isPlaying: false,
            isActive: false,
            fileSize: "${16000 * s / 1024}kb",
          );
          if (this.datas[attr] == null) {
            this.datas[attr] = [];
            this.datas[attr].add(rm);
          } else {
            bool flag = this.datas[attr].any((ele) => ele.title == rm.title);
            if (!flag) this.datas[attr].add(rm);
          }
        }
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        if (children != null)
          for (final FileSystemEntity child in children)
            await _getTotalSizeOfFilesInDir(child);
      }
    } catch (e) {
      print(e);
    }
  }

  ///播放录音
  playRecording({RecroderModule currentFile, int index, String key}) {
    List<RecroderModule> rms = datas[key];
    for (int i = 0; i < rms.length; i++) {
      RecroderModule currentRm = rms[i];
      if (index == i)
        currentRm.isActive = !currentRm.isActive;
      else
        currentRm.isActive = false;
    }
    if (mounted)
      setState(() {
        key = key;
        currentPlayRecording = currentFile;
        currentIndex = index;
      });
    eventBus.fire(PlayingFile(currentFile));
  }

  ///初始化文件夹
  initFlouter() async {
    path = await FileUtile().getRecrodPath(isDelete: false);
    String trashPath = await FileUtile().getRecrodPath(isDelete: true);
    if (!await Directory(path).exists()) await Directory(path).create();
    if (!await Directory(trashPath).exists())
      await Directory(trashPath).create();
    await _getTotalSizeOfFilesInDir(Directory(path));
  }
}
