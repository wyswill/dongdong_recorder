package audio.lanwanhudong.com.flutterapp;

import android.media.AudioTrack;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

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

    /***
     * 根据开始和结束的标识来播放实时的音频数据
     * @ps:1ms数据长度为16，则，startFlag = startTime ->startMs * 16。endFlag = endTime -> endMs * 16
     * playData = (dataLength - startTime) --> endTime
     * @param start 开始的数据下标
     * @param end 结束的数据下标
     * @param filePath 要播放的文件路径
     */
    public void playWithFlag(String filePath, int start, int end) {
        mExecutorService.execute(() -> {
            FileInputStream fileInputStream = null;
            try {
                audioTrack.play();
                fileInputStream = new FileInputStream(filePath);
                fileInputStream.skip(44 + start);
                byte[] buffer = new byte[bufferSize];
                int len = 0;
                while ((len = fileInputStream.read(buffer)) != -1 && len <= end) {
                    audioTrack.write(buffer, 0, len);
                }
            } catch (Exception e) {
                Log.e(TAG, "playPCMRecord: e : " + e);
            } finally {
                if (audioTrack != null) {
                    audioTrack.stop();
                }
                if (fileInputStream != null) {
                    try {
                        fileInputStream.close();
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
