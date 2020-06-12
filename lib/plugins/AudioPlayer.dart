import 'package:flutter/services.dart';

class AudioPlayer {
  ///和native交互
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  ///播放状态
  bool statu = false;

  void initPlayer() async {
    channel.invokeMethod('initPlayer');
  }

  void play(String playeFilePath) async {
    this.initPlayer();
    print(playeFilePath);
    statu = true;
    await channel.invokeMethod("play", {"path": playeFilePath});
  }

  void stop() async {
    statu = false;
    await channel.invokeMethod("stop");
  }

  void pause() async {
    statu = false;
    await channel.invokeMethod("pause");
  }

  void playWithFlag(String filePath, int start, int end) async {
    if (statu)
      this.pause();
    else {
      this.initPlayer();
      await channel.invokeMethod('playWithFlag', {'start': start, 'end': end, 'filePath': filePath});
    }
  }
}
