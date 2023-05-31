package com.example.test_app;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Bundle;


import com.example.test_app.bean.Audio;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivetity extends FlutterActivity {
  MethodChannel channel;
  EventChannel eventChannel;
  int bufferSize = AudioTrack.getMinBufferSize(8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
  AudioTrack audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, 8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT, bufferSize, AudioTrack.MODE_STREAM);
  AudioPlayer audioPlayer = new AudioPlayer(bufferSize, audioTrack);

  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    channel = new MethodChannel(getFlutterView(), "com.lanwanhudong");
    channel.setMethodCallHandler(this::handleMethod);
  }


  /**
   * 处理方法回调监听
   *
   * @param methodCall 方法的参数相关
   * @param result     方法的返回值相关
   */
  private void handleMethod(MethodCall methodCall, MethodChannel.Result result) {
    switch (methodCall.method) {//根据方法名进行处理
      case "fft":
        String path = methodCall.argument("path").toString();
        WaveFileReader reader = new WaveFileReader(path);
        if (reader.isSuccess()) {
          double[] _temp = reader.getData();
          result.success(_temp);
        }
        break;
      case "getSize":
        String paths = methodCall.argument("path").toString();
        Audio audios = new AudioCat().getAudioFromPath(paths);
        long size = audios.getTimeMillis();
        result.success(size);
        break;
      case "cat":
        String oringPath = methodCall.argument("originPath").toString();
        String savePath = methodCall.argument("savePath").toString() + ".wav";
        int startTime = (int) methodCall.argument("startTime");
        int endTime = (int) methodCall.argument("endTime");
        System.out.println("剪辑开始");
        boolean res = AudioCat.cut(oringPath, savePath, startTime, endTime, 44);
        System.out.println("剪辑完成！" + res);
        result.success(savePath);
        break;
      case "play":
        String playPath = methodCall.argument("path").toString();
        audioPlayer.play(playPath);
        result.success("ok");
        break;
      case "stop":
        audioPlayer.stop();
        break;
      case "release":
        audioPlayer.release();
        break;
      case "pause":
        System.out.println("暂停");
        audioPlayer.pause();
        break;
      default:
        break;
    }
  }
}
