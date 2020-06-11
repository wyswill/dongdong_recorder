import 'dart:io';

import 'dart:typed_data';

class WavReader {
  final String filepath;
  List<int> datas = [];
  double s = 0, size = 0, t = 0;

  WavReader(this.filepath);

  readAsBytes() {
    File file = File(this.filepath);

    Uint8List list = file.readAsBytesSync();
    var val = list.buffer.asInt16List();
    for (int i = 0; i < val.lengthInBytes / 2; i++) {
      int d = val[i];
      datas.add(d);
    }

    ///音频数据总长度=音频总时长*每毫秒的字节数
    ///每毫秒字节数=16
    ///总毫秒时长 = 音频数据长度/16
    ///
    ///计算音频长度 单位秒
    s = (val.lengthInBytes - 44) / 16000;

    ///计算音频大小kb
    size = ((16000 * s) / 1024).truncateToDouble();

    t = ((val.lengthInBytes - 44) / 8000);
  }

  ///转化数据
  List<List<int>> convert(int width) {
    List<int> data = this.datas.getRange(44, datas.length).toList();
    List<List<int>> resList = [];
    int flag = 256;
    int current = 0;
    for (int i = 0; i < width; i++) {
      int end = current + flag;
      if (end > data.length) break;
      List res = getMinMaxInRanges(data.getRange(current, end).toList());
      resList.add(res);
      current += flag;
    }
    return resList;
  }

  List<int> getMinMaxInRanges(List<int> array) {
    int max = 0, min = 0;
    array.forEach((element) {
      if (element < min) min = element;
      if (element > max) max = element;
    });
    return [min, max];
  }
}
