import 'package:asdasd/pages/MainPage/MainPage.dart';
import 'package:flutter/material.dart';

Map routes = {
  "/mainPage": (context, {arguments}) => MainPage(arguments: arguments),
};

generateRoute(RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(
          context,
          arguments: settings.arguments,
        ),
      );
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
}
