package audio.lanwanhudong.com.flutterapp;

import android.content.Intent;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

import audio.lanwanhudong.com.flutterapp.bean.AudioCat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    int bufferSize = AudioTrack.getMinBufferSize(8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
    AudioTrack audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, 8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT, bufferSize, AudioTrack.MODE_STREAM);
    AudioPlayer audioPlayer;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        final Intent it = new Intent(this, MainActivity.class); //你要转向的Activity
        Timer timer = new Timer();
        TimerTask task = new TimerTask() {
            @Override
            public void run() {
                startActivity(it); //执行
            }
        };
        timer.schedule(task, 1500);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        String key = "com.lanwanhudong";
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), key);
        channel.setMethodCallHandler(this::handleMethod);
    }

    /**
     * 处理方法回调监听
     *
     * @param methodCall 方法的参数相关
     * @param result     方法的返回值相关
     */
    private void handleMethod(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "cat":
                String oringPath = Objects.requireNonNull(methodCall.argument("originPath")).toString();
                String savePath = Objects.requireNonNull(methodCall.argument("savePath")).toString() + ".wav";
                double totleS = methodCall.argument("totalS");
                int startTime = methodCall.argument("startTime");
                int endTime = methodCall.argument("endTime");
                try {
                    boolean res = AudioCat.cut(oringPath, savePath, totleS, startTime, endTime, 44);
                    result.success(res);
                } catch (Exception e) {
                    result.error("404", "false", e);
                }
                break;
            case "initPlayer":
                audioPlayer = new AudioPlayer(bufferSize, audioTrack);
                break;
            case "play":
                String playPath = methodCall.argument("path").toString();
                audioPlayer.play(playPath);
                result.success("ok");
                break;
            case "stop":
                System.out.println("stop");
                audioPlayer.stop();
                audioPlayer.release();
                break;
            case "pause":
                System.out.println("暂停");
                try {
                    audioPlayer.pause();
                } catch (Error e) {
                }
                break;
            case "playWithFlag":
                int start = methodCall.argument("start");
                int end = methodCall.argument("end");
                String filePath = methodCall.argument("filePath");
                audioPlayer.playWithFlag(filePath, start, end);
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + methodCall.method);
        }
    }

}
