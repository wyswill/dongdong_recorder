import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart' as crypto;
Dio dio = Dio(BaseOptions(
  sendTimeout: 3000,
  connectTimeout: 10000,
  receiveTimeout: 5000,
  responseType: ResponseType.json,
));

Future<Response> Transiton(String filePath) async {
  try {
    File file = File(filePath);
    var data = base64Encode(file.readAsBytesSync());
    Map<String, dynamic> Parame = {
      "app_id": "2129008918",
      "time_stamp": DateTime.now().second,
      "nonce_str": getRadmonStr(),
      "sign": "",
      "format": 2,
      "callback_url": "asd",
      "speech": data.toString()
    };
    Parame['sign'] = await Sign(Parame, "asdS04OpsgwiqYBVkHK");
    Response res = await dio.post(
      "https://api.ai.qq.com/fcgi-bin/aai/aai_wxasrlong",
      data: Parame,
    );
    return res;
  } on DioError catch (e) {
    print(e);
  }
}

Future<String> Sign(Map<String, dynamic> parms, String key) async {
  List<String> mapKeys = parms.keys.toList()..sort();
  String singStr = "";
  mapKeys.forEach((e) {
    var curent = parms[e];
    if (curent != null) {
      singStr += "$e=${Uri.encodeFull(curent.toString())}&";
    }
  });
  singStr += "&app_key=$key";
  return generateMd5(singStr).toUpperCase();
}

String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

String getRadmonStr() {
  String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  int strlenght = 10;

  /// 生成的字符串固定长度
  String left = '';
  for (var i = 0; i < strlenght; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}
