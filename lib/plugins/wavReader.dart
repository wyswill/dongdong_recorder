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

    ///计算音频长度 单位秒
    s = (val.lengthInBytes - 44) / 16000;

    ///计算音频大小kb
    size = ((16000 * s) / 1024).truncateToDouble();

    t = ((val.lengthInBytes - 44) / 8000);
  }

  ///转化数据
  List<List<double>> convert(int width) {
    List<int> data = this.datas.getRange(44, datas.length).toList();
    List<List<double>> resList = List(width);
    double flag = (data.length / width);
    int current = 0;
    for (int i = 0; i < width; i++) {
      int start = ~~current;
      current = (current + flag).floor();
      int end = ~~current;
      List res = getMinMaxInRanges(data, start, end);
      resList[i] = res;
    }
    return resList;
  }

  List<double> getMinMaxInRanges(List<int> array, int start, int end) {
    int min = 0, min1 = 0, max = 0, max1 = 0, current, step = ((end - start) / 30).floor();
    for (var i = start; i < end; i = i + step) {
      current = array[i];
      if (current < min) {
        min1 = min;
        min = current;
      } else if (current > max) {
        max1 = max;
        max = current;
      }
    }
    return [(min + min1) / 2, (max + max1) / 2];
  }
}
