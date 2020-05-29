package audio.lanwanhudong.com.flutterapp;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import audio.lanwanhudong.com.flutterapp.bean.Audio;
import audio.lanwanhudong.com.flutterapp.bean.AudioCat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private MethodChannel channel;
  private String key = "com.lanwanhudong";
  int bufferSize = AudioTrack.getMinBufferSize(8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
  AudioTrack audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, 8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT, bufferSize, AudioTrack.MODE_STREAM);
  AudioPlayer audioPlayer = new AudioPlayer(bufferSize, audioTrack);
  @Override
  public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
    super.onCreate(savedInstanceState, persistentState);
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    channel = new MethodChannel(flutterEngine.getDartExecutor(), key);
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
    }
  }

}