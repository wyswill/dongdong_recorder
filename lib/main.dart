import 'package:flutter/services.dart';
import 'package:flutterapp/pages/MainPage/MainPage.dart';
import 'package:flutterapp/provider.dart';
import 'package:flutterapp/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:flutterapp/utiles.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  return runApp(MultiProvider(
    providers: [ChangeNotifierProvider<recrodListProvider>(create: (_) => recrodListProvider()), ChangeNotifierProvider<transhProvider>(create: (_) => transhProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///和native通讯
  MethodChannel channel = const MethodChannel("com.lanwanhudong");

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Provider.of<recrodListProvider>(context, listen: false).init(await FileUtile.getlocalMusic(channel: channel));
    Provider.of<transhProvider>(context, listen: false).init(await FileUtile.getlocalMusic(isRecroder: false, channel: channel));
  }

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
