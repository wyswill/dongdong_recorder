package com.example.test_app;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;

import java.io.FileInputStream;
import java.io.IOException;

import io.flutter.Log;

import static android.content.ContentValues.TAG;

public class AudioPlayer {

    int bufferSize = AudioTrack.getMinBufferSize(8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
    AudioTrack audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, 8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT, bufferSize, AudioTrack.MODE_STREAM);
    boolean isPlaying, isStop;

    public void play(String filepath) {
        FileInputStream fis = null;
        try {
            audioTrack.play();
            fis = new FileInputStream(filepath);
            fis.skip(44);
            byte[] buffer = new byte[bufferSize];
            int len = 0;
            isPlaying = true;
            while ((len = fis.read(buffer)) != -1 && !isStop) {
                audioTrack.write(buffer, 0, len);
            }
        } catch (Exception e) {
            Log.e(TAG, "playPCMRecord: e : " + e);
        } finally {
            isPlaying = false;
            isStop = false;
            if (audioTrack != null) {
                audioTrack.stop();
                audioTrack.release();
            }
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public void stop() {
        isPlaying = false;
        isStop = false;
        if (audioTrack != null) {
            audioTrack.stop();
            audioTrack.release();
        }
    }
}
