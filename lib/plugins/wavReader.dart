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
    var val = ByteData.view(list.buffer);
    for (int i = 0; i < val.lengthInBytes / 2; i++) {
      int d = val.getInt16(i * 2);
      datas.add(d);
    }

    ///计算音频长度 单位秒
    s = (val.lengthInBytes - 44) / 16000;

    ///计算音频大小kb
    size = ((16000 * s) / 1024).truncateToDouble();

    t = ((val.lengthInBytes - 44) / 8000);
  }

  ///转化数据
  List<int> convert(int width) {
    List<int> data = this.datas.getRange(44, datas.length).toList();
    int g = 11, totalPointCount = g * 10;

    ///数据和屏幕比
    double r = (width / data.length);
    print(r);
    List<int> res = [];

    ///每个间隔的取样区间
    int sr = ((data.length / g) * r).truncate();
    return converts(width);
//
//    ///每个间隔中的指针的取样区间
//    int pr = (sr / 10).truncate();
//
//    ///总的指针数量
//    int pc = (data.length / pr).truncate();
//    int temp = 0;
//
//    for (int i = 0; i < pc; i++) {
//      if (temp < data.length) {
//        int end = temp + pr;
////        print('temp==>$temp,end==>$end');
//        int value = getMinMaxInRange(data.getRange(temp, end).toList());
////        print(value);
//        res.add(value);
//        temp = end;
//      }
//    }
    return res;
  }

  int getMinMaxInRange(List<int> array) {
    double res = 0;
    array.forEach((element) {
      res += element;
    });

    ///防止数组全是0，再除以长度时不够
    if (res == 0)
      return 0;
    else
      return (res / array.length).truncate();
  }

  ///转化数据
  List<int> converts(int width) {
    List<int> data = this.datas.getRange(44, datas.length).toList();
    print(data.length);
    List<int> resList = List(width);
    double flag = (data.length / width);
    print('flag==>$flag,t==>$t');
    int current = 0;
    for (int i = 0; i < width; i++) {
      int start = ~~current;
      current = (current + flag).floor();
      int end = ~~current;
      num res = getMinMaxInRanges(data, start, end);
      resList[i] = res.toInt();
    }
    return resList;
  }

  getMinMaxInRanges(List<int> array, int start, int end) {
    int min = 0, min1 = 0, max = 0, max1 = 0, current, step = ((end - start) / 15).floor();
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
    return (max + max1) / 2;
  }
}
