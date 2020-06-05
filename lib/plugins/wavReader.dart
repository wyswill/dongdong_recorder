import 'dart:io';

import 'package:flutterapp/modus/cancasRectModu.dart';

import '../utiles.dart';

class WavReader {
  final String filepath;
  List datas = [];
  double s = 0, size = 0;

  WavReader(this.filepath);

  readAsBytes() {
    File file = File(this.filepath);
    datas = file.readAsBytesSync().toList();

    ///计算音频长度 单位秒
    s = (datas.length - 44) * 8 / (8000 * 16);

    ///计算音频大小kb
    size = 16000 * (s % 60) / 1024;
  }

  ///将波形按照毫秒的时域进行转换
  ///
  /// 不同机型屏幕适配 转换比例 =  屏幕宽度 / 音频时长(毫秒)
  ///TODO:1.波形一屏展示2.时间轴绘制3.缩放公式完成4.wav剪切功能由java实现转为dart实现

  Future<List<CanvasRectModu>> convers() async {
    List data = this.datas;

    ///获取录音时间
    ///以1毫秒为间隔提取一次数据
    int flag = (this.datas.length / (this.s * 1000)).floor(), stp = 0;
    List res = [];
    for (int i = 0; i < data.length; i++) {
      int curent = data[i];
      if (curent == 0) continue;
      if (stp == flag) {
        int t = (i / flag).floor();
        res.add(CanvasRectModu(
          vlaue: curent.toDouble(),
//          index: i,
//          timestamp: formatTime(t * 100),
//          ms: t * 100,
        ));
        stp = 0;
      }
      stp++;
    }
    return res;
  }
}
