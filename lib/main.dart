import 'package:asdasd/pages/MainPage/MainPage.dart';
import 'package:asdasd/router.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '录音机', //87, 92, 159, 1
      theme: ThemeData(primaryColor: Color.fromRGBO(87, 92, 159, 1)),
      home: MainPage(),
      onGenerateRoute: (RouteSettings settings) => generateRoute(settings),
    );
  }
}
