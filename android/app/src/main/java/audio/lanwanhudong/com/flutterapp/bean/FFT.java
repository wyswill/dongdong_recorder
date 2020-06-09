package audio.lanwanhudong.com.flutterapp.bean;

import java.util.ArrayList;

public class FFT {
    public static ArrayList<Double> process(String filepath) {
        ArrayList<Double> res = new ArrayList();
        final WaveFileReader reader = new WaveFileReader(filepath);
        Complex[] pre_list;
        if (reader.isSuccess()) {
            final int[] data = reader.getData()[0]; // 获取第一声道
            pre_list = new Complex[data.length];
            for (int i = 0; i < data.length; i++) {
                int pcm_data = data[i];
                pre_list[i] = new Complex(i, pcm_data);
            }
            Complex[] after_data = fft(pre_list);
            for (Complex complex : after_data) {
                double value = Math.floor(complex.im());
                if (value > 0 && value < 9999999)
                    res.add(value);
            }
        } else {
            System.err.println(filepath + "不是一个正常的wav文件");
        }
        return res;
    }

    public static Complex[] fft(Complex[] x) {
        int n = x.length;

        // 因为exp(-2i*n*PI)=1，n=1时递归原点
        if (n == 1) {
            // 这里和B博客中有一点变化
            return new Complex[]{x[0]};
        }

        // 如果信号数为奇数，使用dft计算
        if (n % 2 != 0) {
            return dft(x);
        }

        // 提取下标为偶数的原始信号值进行递归fft计算
        Complex[] even = new Complex[n / 2];
        for (int k = 0; k < n / 2; k++) {
            even[k] = x[2 * k];
        }
        Complex[] evenValue = fft(even);

        // 提取下标为奇数的原始信号值进行fft计算
        // 节约内存
        Complex[] odd = even;
        for (int k = 0; k < n / 2; k++) {
            odd[k] = x[2 * k + 1];
        }
        Complex[] oddValue = fft(odd);

        // 偶数+奇数
        Complex[] result = new Complex[n];
        for (int k = 0; k < n / 2; k++) {
            double p = -2 * k * Math.PI / n;
            Complex m = new Complex(Math.cos(p), Math.sin(p));
            result[k] = evenValue[k].plus(m.multiple(oddValue[k]));
            result[k + n / 2] = evenValue[k].minus(m.multiple(oddValue[k]));
        }
        return result;
    }

    public static Complex[] dft(Complex[] x) {
        int n = x.length;
        if (n == 1)
            return new Complex[]{x[0]};
        Complex[] result = new Complex[n];
        for (int i = 0; i < n; i++) {
            result[i] = new Complex(0, 0);
            for (int k = 0; k < n; k++) {
                double p = -2 * i * k * Math.PI / n;
                Complex m = new Complex(Math.cos(p), Math.sin(p));
                result[i] = result[i].plus(x[k].multiple(m));
            }
        }
        return result;
    }
}