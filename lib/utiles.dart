import 'dart:core';

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
   Duration d = Duration(milliseconds: totalTime);
  return "${d.inHours}:${d.inMinutes}:${d.inSeconds}:${d.inMilliseconds - (d.inSeconds * 1000)}";
}

format2(int totalTime) {
  Duration d = Duration(milliseconds: totalTime);
  return "${d.inHours}:${d.inMinutes}:${d.inSeconds}:${d.inMilliseconds - (d.inSeconds * 1000)}";
}
