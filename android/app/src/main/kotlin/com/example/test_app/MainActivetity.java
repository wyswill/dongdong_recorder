package com.example.test_app;

import android.os.Bundle;


import com.example.test_app.bean.Audio;
import com.example.test_app.util.AudioEditUtil;
import com.example.test_app.util.AudioEncodeUtil;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;

import io.flutter.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivetity extends FlutterActivity {
    MethodChannel channel;
    AudioPlayer audioPlayer = new AudioPlayer();

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
            case "playMusic":
                String playPath = methodCall.argument("path").toString();
                String cmd = methodCall.argument("cmd").toString();
                switch (cmd) {
                    case "play":
                        audioPlayer.play(playPath);
                        result.success("ok");
                        break;
                    case "stop":
                        audioPlayer.stop();
                        result.success("ok");
                        break;
                    default:
                        break;
                }

                break;
            default:
                result.notImplemented();
        }
    }

}
