import 'package:flutter/material.dart';
import 'modus/record.dart';

class Modus with ChangeNotifier {
  Map curentPlayRecrofing;
  Map<String, List<RecroderModule>> recroderFiles = {};
}
