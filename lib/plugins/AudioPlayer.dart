import 'package:flutter/services.dart';

class AudioPlayer {
  ///和native交互
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  ///播放状态
  bool statu = false;

  void play(String playeFilePath) async {
    var res = await channel.invokeMethod("play", {"path": playeFilePath});
  }

  void stop() async {
    var res = await channel.invokeMethod("stop");
  }

  void pause() async {
    var res = await channel.invokeMethod("pause");
  }
}
