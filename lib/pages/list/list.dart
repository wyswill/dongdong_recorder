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
  RecroderModule curentPlayRecroding;
  String key;
  int curentindex;
  String cacheFile = '/file_cache/Audio/', path = '';
  MethodChannel channel = const MethodChannel("com.lanwanhudong");
  StreamSubscription streamSubscription;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    path = await FileUtile().getRecrodPath();
    await _getTotalSizeOfFilesInDir(Directory(path));
    dataKeys = datas.keys.toList();
    setState(() {});

    ///event_bus订阅消息
    streamSubscription = eventBus.on<PlayingState>().listen((event) {
      setState(() {
        curentPlayRecroding.isPlaying = event.state;
        curentPlayRecroding.isActive = event.state;
      });
    });
    streamSubscription = eventBus.on<DeleteFileSync>().listen((event) {
      String attr = event.attr;
      int index = event.index;
      setState(() {
        datas[attr].removeAt(index);
      });
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
                playRecroding: this.playRecroding,
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
        String filename = file.path.replaceAll(path, '');
        if (filename.indexOf(RegExp('.wav')) > 0) {
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
  playRecroding({RecroderModule curentFile, int index, String key}) {
    List<RecroderModule> rms = datas[key];
    for (int i = 0; i < rms.length; i++) {
      RecroderModule curentrm = rms[i];
      if (index == i)
        curentrm.isActive = !curentrm.isActive;
      else
        curentrm.isActive = false;
    }
    setState(() {
      key = key;
      curentPlayRecroding = curentFile;
      curentindex = index;
    });
    eventBus.fire(PlayingFile(curentFile));
  }
}
