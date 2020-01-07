import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:crypto/crypto.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'flutter 音频剪辑'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool playStatus = false;
  FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  String trans = 'ffmpeg -i input.mp4 -vn -ar 44100 -ac 2 -f s16le out.pcm';
  List<int> datas = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var data = await rootBundle.load('assets/test.mp3');
    List<int> list =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    datas = list;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                int curent = datas[index];
                return SizedBox(
                  width: curent.toDouble(),
                  height: 20,
                  child: Container(
                    color: Colors.pink,
                  ),
                );
              }, childCount: datas.length),
            ),
          ],
        ),
      ),
    );
  }
}
