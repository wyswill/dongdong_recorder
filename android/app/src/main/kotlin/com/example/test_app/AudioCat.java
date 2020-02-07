package com.example.test_app;

import com.example.test_app.util.DecodeOperateInterface;
import com.example.test_app.util.FileUtils;
import com.example.test_app.util.DecodeEngine;

import java.io.File;

public class AudioCat {
  final String originPath;
  final String savePath;
  final String startTime;
  final String endTime;

  public AudioCat(String originPath, String savePath, String startTime, String endTime) {
    this.originPath = originPath;
    this.savePath = savePath;
    this.startTime = startTime;
    this.endTime = endTime;
  }

  private void decodeAudio(String path, String destPath) {
    final File file = new File(path);

    if (FileUtils.checkFileExist(destPath)) {
      FileUtils.deleteFile(new File(destPath));
    }

    FileUtils.confirmFolderExist(new File(destPath).getParent());

    DecodeEngine.getInstance().convertMusicFileToWaveFile(path, destPath, new DecodeOperateInterface() {
      @Override
      public void updateDecodeProgress(int decodeProgress) {
        String msg = String.format("解码文件：%s，进度：%d", file.getName(), decodeProgress) + "%";
//        EventBus.getDefault().post(new AudioMsg(AudioTaskCreator.ACTION_AUDIO_MIX, msg));
      }

      @Override
      public void decodeSuccess() {

      }

      @Override
      public void decodeFail() {

      }
    });
  }

}
