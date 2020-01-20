import 'dart:async';
import 'dart:io';
import 'package:asdasd/event_bus.dart';
import 'package:asdasd/modus/record.dart';
import 'package:asdasd/pages/list/recrodingFileItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class RecrodingList extends StatefulWidget {
  RecrodingList({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _RecrodingListState createState() => _RecrodingListState();
}

class _RecrodingListState extends State<RecrodingList> {
  StreamSubscription streamSubscription;
  Map<String, List<RecroderModule>> datas = {};
  List dataKeys = [];
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  RecroderModule curentPlayRecrofing;
  String cacheFile = '/file_cache/Audio/', path = '';
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Directory directory = (await getExternalCacheDirectories())[0];
    path = directory.path + cacheFile;
    await _getTotalSizeOfFilesInDir(Directory(path));
    dataKeys = datas.keys.toList();
    setState(() {});
    streamSubscription = eventBus.on<PlayingState>().listen((event) {
      setState(() {
        this.curentPlayRecrofing.isPlaying = event.state;
      });
    });
    streamSubscription = eventBus.on<DeleteFileSync>().listen((event) {
      String attr = event.attr;
      int index = event.index;
      print(attr);
      print(index);
      setState(() {
        datas[attr].removeAt(index);
      });
      print(datas);
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
          if (this.datas[attr] == null) {
            this.datas[attr] = [];
            this.datas[attr].add(
                  RecroderModule(
                    title: filename,
                    filepath: file.path,
                    recrodingtime: "$res",
                    lastModified:
                        '${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
                    isPlaying: false,
                    fileSize: "${16000 * s / 1024}kb",
                  ),
                );
          } else {
            this.datas[attr].add(
                  RecroderModule(
                    title: filename,
                    filepath: file.path,
                    recrodingtime: "$res",
                    lastModified:
                        '${dateTime.day}日${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
                    isPlaying: false,
                    fileSize: "${16000 * s / 1024}kb",
                  ),
                );
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
  playRecroding({RecroderModule curentFile}) {
    setState(() {
      curentPlayRecrofing = curentFile;
    });
    eventBus.fire(PlayingFile(curentFile));
  }
}
