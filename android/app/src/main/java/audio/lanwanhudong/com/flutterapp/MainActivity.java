package audio.lanwanhudong.com.flutterapp;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;

import androidx.annotation.NonNull;

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
                String oringPath = methodCall.argument("originPath").toString();
                String savePath = methodCall.argument("savePath").toString() + ".wav";
                int startTime = (int) methodCall.argument("startTime");
                int endTime = (int) methodCall.argument("endTime");
                System.out.println("剪辑开始");
                boolean res = AudioCat.cut(oringPath, savePath, startTime, endTime, 44);
                System.out.println("剪辑完成！" + res);
                result.success(savePath);
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
        }
    }

}
