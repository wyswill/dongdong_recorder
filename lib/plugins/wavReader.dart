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
//    print(data);
    return [];
  }

  int getMinMaxInRange(array) {}
}
