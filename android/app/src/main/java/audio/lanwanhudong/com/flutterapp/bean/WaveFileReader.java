package audio.lanwanhudong.com.flutterapp.bean;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;

public class WaveFileReader {
    private String filename = null;
    private int[][] data = null;
    private int len = 0;
    private String chunkdescriptor = null;
    static private int lenchunkdescriptor = 4;
    private String waveflag = null;
    static private int lenwaveflag = 4;
    private String fmtubchunk = null;
    static private int lenfmtubchunk = 4;
    private int numchannels = 0;
    private long samplerate = 0;
    private int bitspersample = 0;
    private String datasubchunk = null;
    static private int lendatasubchunk = 4;
    private long subchunk2size = 0;
    private FileInputStream fis = null;
    private BufferedInputStream bis = null;
    private boolean issuccess = false;

    public WaveFileReader(final String filename) {
        this.initReader(filename);
    }

    // 判断是否创建wav读取器成功
    public boolean isSuccess() {
        return issuccess;
    }

    // 获取每个采样的编码长度，8bit或者16bit
    public int getBitPerSample() {
        return this.bitspersample;
    }

    // 获取采样率
    public long getSampleRate() {
        return this.samplerate;
    }

    // 获取声道个数，1代表单声道 2代表立体声
    public int getNumChannels() {
        return this.numchannels;
    }

    // 获取数据长度，也就是一共采样多少个
    public int getDataLen() {
        return this.len;
    }

    // 获取数据
    // 数据是一个二维数组，[n][m]代表第n个声道的第m个采样值
    public int[][] getData() {
        return this.data;
    }

    private void initReader(final String filename) {
        this.filename = filename;
        try {
            fis = new FileInputStream(this.filename);
            bis = new BufferedInputStream(fis);
            this.chunkdescriptor = readString(lenchunkdescriptor);
            if (!chunkdescriptor.endsWith("RIFF"))
                throw new IllegalArgumentException("RIFF miss, " + filename + " is not a wave file.");
            readLong();
            this.waveflag = readString(lenwaveflag);
            if (!waveflag.endsWith("WAVE"))
                throw new IllegalArgumentException("WAVE miss, " + filename + " is not a wave file.");
            this.fmtubchunk = readString(lenfmtubchunk);
            if (!fmtubchunk.endsWith("fmt "))
                throw new IllegalArgumentException("fmt miss, " + filename + " is not a wave file.");
            readLong();
            readInt();
            this.numchannels = readInt();
            this.samplerate = readLong();
            readLong();
            readInt();
            this.bitspersample = readInt();
            this.datasubchunk = readString(lendatasubchunk);
            if (!datasubchunk.endsWith("data"))
                throw new IllegalArgumentException("data miss, " + filename + " is not a wave file.");
            this.subchunk2size = readLong();
            this.len = (int) (this.subchunk2size / (this.bitspersample / 8) / this.numchannels);
            this.data = new int[this.numchannels][this.len];
            for (int i = 0; i < this.len; ++i) {
                for (int n = 0; n < this.numchannels; ++n) {
                    if (this.bitspersample == 8) {
                        this.data[n][i] = bis.read();
                    } else if (this.bitspersample == 16) {
                        this.data[n][i] = this.readInt();
                    }
                }
            }
            issuccess = true;
        } catch (final Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (bis != null)
                    bis.close();
                if (fis != null)
                    fis.close();
            } catch (final Exception e1) {
                e1.printStackTrace();
            }
        }
    }

    private String readString(final int len) {
        final byte[] buf = new byte[len];
        try {
            if (bis.read(buf) != len)
                throw new IOException("no more data!!!");
        } catch (final IOException e) {
            e.printStackTrace();
        }
        return new String(buf);
    }

    private int readInt() {
        final byte[] buf = new byte[2];
        int res = 0;
        try {
            if (bis.read(buf) != 2)
                throw new IOException("no more data!!!");
            res = (buf[0] & 0x000000FF) | (((int) buf[1]) << 8);
        } catch (final IOException e) {
            e.printStackTrace();
        }
        return res;
    }

    private long readLong() {
        long res = 0;
        try {
            final long[] l = new long[4];
            for (int i = 0; i < 4; ++i) {
                l[i] = bis.read();
                if (l[i] == -1) {
                    throw new IOException("no more data!!!");
                }
            }
            res = l[0] | (l[1] << 8) | (l[2] << 16) | (l[3] << 24);
        } catch (final IOException e) {
            e.printStackTrace();
        }
        return res;
    }
}