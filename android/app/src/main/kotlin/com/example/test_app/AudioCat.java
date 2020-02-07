package com.example.test_app;

import com.example.test_app.bean.Audio;
import com.example.test_app.util.AudioEditUtil;

import java.io.File;


public class AudioCat {
  String originPath;
  String savePath;
  int startTime;
  int endTime;

  public AudioCat(String originPath, String savePath, int startTime, int endTime) {
    this.originPath = originPath;
    this.savePath = savePath;
    this.startTime = startTime;
    this.endTime = endTime;
  }

  public AudioCat() {
  }

  public void Cat() {
    Audio audio = this.getAudioFromPath(originPath);
    System.out.println("srcWavePath      " + audio.getPath());
    AudioEditUtil.cutAudio(audio, startTime, endTime);
  }

  /**
   * 获取根据解码后的文件得到audio数据
   *
   * @param path
   * @return
   */
  public Audio getAudioFromPath(String path) {
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN) {
      try {
        Audio audio = Audio.createAudioFromFile(new File(path));
        return audio;
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    return null;
  }

}
