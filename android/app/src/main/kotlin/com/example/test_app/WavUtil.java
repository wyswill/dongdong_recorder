package com.example.test_app;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class WavUtil {
  /**
   * 根据本地文件地址获取wav音频时长
   */
  public static long getWavLength(String filePath) {
    byte[] wavdata = getBytes(filePath);
    if (wavdata != null && wavdata.length > 44) {
      int byteRate = byteArrayToInt(wavdata, 28, 31);
      int waveSize = byteArrayToInt(wavdata, 40, 43);
      return waveSize * 1000 / byteRate;
    }
    return 0;
  }

  /**
   * file 2 byte数组
   */
  private static byte[] getBytes(String filePath) {
    byte[] buffer = null;
    try {
      File file = new File(filePath);
      FileInputStream fis = new FileInputStream(file);
      ByteArrayOutputStream bos = new ByteArrayOutputStream(1000);
      byte[] b = new byte[1000];
      int n;
      while ((n = fis.read(b)) != -1) {
        bos.write(b, 0, n);
      }
      fis.close();
      bos.close();
      buffer = bos.toByteArray();
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
    return buffer;
  }

  /**
   * 将byte[]转化为int
   */
  private static int byteArrayToInt(byte[] b, int start, int end) {
    return ByteBuffer.wrap(b, start, end).order(ByteOrder.LITTLE_ENDIAN).getInt();
  }
}
