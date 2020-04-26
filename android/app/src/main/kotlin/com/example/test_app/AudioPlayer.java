package com.example.test_app;

import android.media.AudioTrack;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.app.FlutterActivity;
import io.flutter.Log;

import static android.content.ContentValues.TAG;

public class AudioPlayer {

  private int bufferSize;
  private AudioTrack audioTrack;
  // 单任务线程池
  private ExecutorService mExecutorService = Executors.newSingleThreadExecutor();

  AudioPlayer(int bufferSize, AudioTrack audioTrack) {
    this.bufferSize = bufferSize;
    this.audioTrack = audioTrack;
  }

  public void play(String filepath) {
    mExecutorService.execute(() -> {
      FileInputStream fis = null;
      try {
        audioTrack.play();
        fis = new FileInputStream(filepath);
        fis.skip(44);
        byte[] buffer = new byte[bufferSize];
        int len = 0;
        while ((len = fis.read(buffer)) != -1) {
          audioTrack.write(buffer, 0, len);
        }
      } catch (Exception e) {
        Log.e(TAG, "playPCMRecord: e : " + e);
      } finally {
        if (audioTrack != null) {
          audioTrack.stop();
        }
        if (fis != null) {
          try {
            fis.close();
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
      }
    });
  }

  public void stop() {
    this.audioTrack.stop();
  }

  public void pause() {
    this.audioTrack.pause();
  }

  public void release() {
    this.audioTrack.release();
  }
}
