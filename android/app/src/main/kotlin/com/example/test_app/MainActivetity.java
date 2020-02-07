package com.example.test_app;

import android.os.Bundle;


import com.example.test_app.bean.Audio;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivetity extends FlutterActivity {
  MethodChannel channel;

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
        long size = WavUtil.getWavLength(paths);
        result.success(size);
        break;
      case "cat":
        String oringPath = methodCall.argument("originPath").toString();
        String savePath = methodCall.argument("savePath").toString();
        int startTime = methodCall.argument("startTime");
        int endTime = methodCall.argument("endTime");
        AudioCat audioCat = new AudioCat(oringPath, savePath, startTime, endTime);
        audioCat.Cat();
        result.success("ok");
        break;
      default:
        result.notImplemented();
    }
  }

}
