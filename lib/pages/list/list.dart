import 'dart:async';
import 'dart:io';

import 'package:asdasd/event_bus.dart';
import 'package:asdasd/modus/record.dart';
import 'package:asdasd/pages/list/recrodingFileItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';

class RecrodingList extends StatefulWidget {
  RecrodingList({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _RecrodingListState createState() => _RecrodingListState();
}

class _RecrodingListState extends State<RecrodingList> {
  StreamSubscription streamSubscription;
  Map datas = {};
  List dataKeys = [];
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  RecroderModule curentPlayRecrofing;
  String cacheFile = '/file_cache/Audio/', path = '';
  List<File> files = [];
  @override
  void initState() {
    super.initState();
    streamSubscription = eventBus.on<PlayingState>().listen((event) {
      setState(() {
        this.curentPlayRecrofing.isPlaying = event.state;
      });
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    datas = Provider.of<Modus>(context).recroderFiles;
    dataKeys = datas.keys.toList();
    Directory directory = (await getExternalCacheDirectories())[0];
    path = directory.path + cacheFile;
    await _getTotalSizeOfFilesInDir(directory);
  }

  /// 递归方式获取录音文件
  _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        // files.add(file);
        print(file.path);
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
    List curentRecrodingFiles = this.datas[curnetKey];
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
              );
            }),
          )
        ],
      ),
    );
  }

  ///播放录音
  void playRecroding({RecroderModule curentFile}) {
    if (curentPlayRecrofing != null && curentPlayRecrofing == curentFile) {
      setState(() {
        curentPlayRecrofing.isPlaying = !curentPlayRecrofing.isPlaying;
      });
      eventBus.fire(PlayingFile(curentFile));
      return;
    }
    if (curentPlayRecrofing != null && curentPlayRecrofing.isPlaying) {
      setState(() {
        curentPlayRecrofing.isPlaying = !curentPlayRecrofing.isPlaying;
        curentFile.isPlaying = !curentFile.isPlaying;
        curentPlayRecrofing = curentFile;
      });
    } else {
      setState(() {
        curentFile.isPlaying = !curentFile.isPlaying;
        curentPlayRecrofing = curentFile;
      });
    }
    eventBus.fire(PlayingFile(curentFile));
  }
}
