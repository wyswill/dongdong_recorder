package com.example.test_app;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.io.RandomAccessFile;

import record.wilson.flutter.com.flutter_plugin_record.utils.FileTool;

public class WaveHeaderHelper {

    private static void writeHeader(OutputStream out, int sampleRate, int encoding, int channel) throws IOException {
        writeString(out, "RIFF"); // chunk id
        writeInt(out, 0); // chunk size
        writeString(out, "WAVE"); // format
        writeString(out, "fmt "); // subchunk 1 id
        writeInt(out, 16); // subchunk 1 size
        writeShort(out, (short) 1); // audio format (1 = PCM)
        writeShort(out, (short) channel); // number of channels
        writeInt(out, sampleRate); // sample rate
        writeInt(out, sampleRate * channel * encoding >> 3); // byte rate
        writeShort(out, (short) (channel * encoding >> 3)); // block align
        writeShort(out, (short) encoding); // bits per sample
        writeString(out, "data"); // subchunk 2 id
        writeInt(out, 0); // subchunk 2 size
    }

    private static void writeWaveHeaderLength(File f) {
        RandomAccessFile raf = null;
        try {
            raf = new RandomAccessFile(f, "rw");
            long length = f.length();
            long chunkSize = length - 8;
            long subChunkSize = length - 44;
            raf.seek(4);
            raf.write((int) (chunkSize >> 0));
            raf.write((int) (chunkSize >> 8));
            raf.write((int) (chunkSize >> 16));
            raf.write((int) (chunkSize >> 24));
            raf.seek(40);
            raf.write((int) (subChunkSize >> 0));
            raf.write((int) (subChunkSize >> 8));
            raf.write((int) (subChunkSize >> 16));
            raf.write((int) (subChunkSize >> 24));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            FileTool.closeIO(raf);
        }
    }

    private static void writeInt(final OutputStream output, final int value) throws IOException {
        output.write(value >> 0);
        output.write(value >> 8);
        output.write(value >> 16);
        output.write(value >> 24);
    }

    private static void writeShort(final OutputStream output, final short value) throws IOException {
        output.write(value >> 0);
        output.write(value >> 8);
    }

    private static void writeString(final OutputStream output, final String value) throws IOException {
        for (int i = 0; i < value.length(); i++) {
            output.write(value.charAt(i));
        }
    }
}
