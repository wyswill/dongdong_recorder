package com.example.test_app;


import android.media.MediaPlayer;

import java.io.IOException;

public class AudioPlayer {
    MediaPlayer mediaPlayer;

    public AudioPlayer(String path) throws IOException {
        mediaPlayer = new MediaPlayer();
        mediaPlayer.setDataSource(path);
        mediaPlayer.prepare();
    }

    public void play() {
        if (mediaPlayer.isPlaying())
            mediaPlayer.stop();
        else
            mediaPlayer.start();
    }

    public void stop() {
        mediaPlayer.stop();
    }
}
