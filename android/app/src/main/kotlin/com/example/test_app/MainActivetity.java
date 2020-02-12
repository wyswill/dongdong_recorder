package com.example.test_app;

import android.os.Bundle;


import com.example.test_app.bean.Audio;
import com.example.test_app.util.AudioEncodeUtil;

import java.io.IOException;

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
                Audio audios = new AudioCat().getAudioFromPath(paths);
                System.out.println("采样率" + audios.getSampleRate());
                System.out.println("声道数" + audios.getChannel());
                System.out.println("采样位数" + audios.getBitNum());
                long size = audios.getTimeMillis();
                result.success(size);
                break;
            case "cat":
                String oringPath = methodCall.argument("originPath").toString();
                String savePath = methodCall.argument("savePath").toString();
                int startTime = (int) methodCall.argument("startTime");
                int endTime = (int) methodCall.argument("endTime");
//                AudioCat audioCat = new AudioCat(oringPath, savePath, startTime, endTime);
//                audioCat.Cat();
                System.out.println("剪辑开始");
                boolean res = AudioCat.cut(oringPath, savePath + ".wav", startTime, endTime, 44);
                System.out.println("剪辑完成！" + res);
                break;
            case "playMusic":
                String playPath = methodCall.argument("path").toString();
                try {
                    AudioPlayer audioPlayer = new AudioPlayer(playPath);
                    audioPlayer.play();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                result.success("ok");
                break;
            default:
                result.notImplemented();
        }
    }

}
