import 'package:flutter/material.dart';

alert(
  BuildContext context, {
  Widget title,
  EdgeInsetsGeometry titlePadding,
  TextStyle titleTextStyle,
  Widget content,
  EdgeInsetsGeometry contentPadding =
      const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
  TextStyle contentTextStyle,
  List<Widget> actions,
  Color backgroundColor,
  double elevation,
  String semanticLabel,
  ShapeBorder shape,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
        content: content,
        contentPadding: contentPadding,
        contentTextStyle: contentTextStyle,
        actions: actions,
        backgroundColor: backgroundColor,
        elevation: elevation,
        semanticLabel: semanticLabel,
        shape: shape,
      );
    },
  );
}

formatTime(int totalTime) {
  int hour = 0;
  int minute = 0;
  int second = 0;
  second = (totalTime / 1000).round();
  if (totalTime <= 1000 && totalTime > 0) {
    second = 1;
  }
  if (second > 60) {
    minute = (second / 60).round();
    second = second % 60;
  }
  if (minute > 60) {
    hour = (minute / 60).round();
    minute = minute % 60;
  }
  return "$hour:$minute:$second";
}
