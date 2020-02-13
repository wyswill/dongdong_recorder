import 'package:flutter/services.dart';

class AudioPlayer {
  AudioPlayer({this.playeFilePath});

  final String playeFilePath;

  ///和native交互
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  ///播放状态
  bool statu = false;

  void play() async {
    var res = await channel.invokeMethod("playMusic", {"path": playeFilePath});

  }

  void stop() async {
    var res = await channel.invokeMethod("stop");
  }
}
