import 'dart:typed_data';

///FFT 快速傅里叶变换
class FFT {
  static Future<List<int>> fft(Uint8List data, double endeTime) async {
    Set<int> set = Set();
    List<int> res = [];
    List<int> riff = data.sublist(0, 12).toList();
    List<int> _data = data.skip(44).toList();
    print(endeTime);

    /// 每8个bit 做一个踩点
    int bitWidth = 8;
    for (int i = 0; i < _data.length; i += bitWidth) {
      int right = i + 8;
      if (right >= _data.length) right = _data.length;
      List<int> temp = _data.getRange(i, right).toList();

      ///每8个bit取一次平均值
      int avreg = temp.reduce((curent, next) => curent + next);
//      res.add((avreg / temp.length).floor());
      res.add((avreg / temp.length).floor());
    }
    return res;
  }
}
