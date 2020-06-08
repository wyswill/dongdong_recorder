import 'dart:io';

class WavReader {
  final String filepath;
  List datas = [];
  double s = 0, size = 0, t = 0;

  WavReader(this.filepath);

  readAsBytes() {
    File file = File(this.filepath);
    datas = file.readAsBytesSync().toList();

    ///计算音频长度 单位秒
    s = (datas.length - 44) * 8 / (8000 * 16);

    ///计算音频大小kb
    size = ((16000 * s) / 1024).floorToDouble();

    ///计算500毫秒有多少组
    t = (datas.length / 8000);
  }

  ///500毫秒一帧，组成初始化的数据
  List<int> convers(int width) {
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
      num res = getMinMaxInRange(data, start, end);
      resList[i] = res.toInt();
    }
    return resList;
  }

  getMinMaxInRange(array, int start, int end) {
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
