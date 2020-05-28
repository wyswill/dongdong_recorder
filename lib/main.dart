import 'package:flutterapp/pages/MainPage/MainPage.dart';
import 'package:flutterapp/provider.dart';
import 'package:flutterapp/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Modus>(create: (_) => Modus()),
      ChangeNotifierProvider<transhProvider>(create: (_) => transhProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '咚咚录音机',
      theme: ThemeData(primaryColor: Color.fromRGBO(87, 92, 159, 1)),
      home: MainPage(),
      onGenerateRoute: (RouteSettings settings) => generateRoute(settings),
    );
  }
}
