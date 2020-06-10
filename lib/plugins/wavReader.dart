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

  ///转化数据
  List<int> convert(int width) {
    List<int> data = this.datas.getRange(44, datas.length).toList();
    int g = 11;

    ///数据和屏幕比
    double r = (width / data.length);
    print(r);

    ///每个间隔的取样区间
    int sr = ((data.length / g) * r).truncate();

    ///每个间隔中的指针的取样区间
    int pr = (sr / 5).truncate();

    ///总的指针数量
    int pc = (data.length / pr).truncate();
    int temp = 0;
    List<int> res = [];
    for (int i = 0; i < pc; i++) {
      if (temp < data.length) {
        int end = temp + pr;
//        print('temp==>$temp,end==>$end');
        int value = getMinMaxInRange(data.getRange(temp, end).toList());
//        print(value);
        res.add(value);
        temp = end;
      }
    }
    return res;
  }

  int getMinMaxInRange(List<int> array) {
    double res = 0;
    array.forEach((element) {
      res += element;
    });
    if (res == 0)
      return 0;
    else
      return (res / array.length).truncate();
  }
}
