import 'package:flutter/material.dart';

class MusicProgress extends StatefulWidget {
  MusicProgress({Key key}) : super(key: key);
  @override
  MusicProgressState createState() => MusicProgressState();
}

class MusicProgressState extends State<MusicProgress> {
  double curentTime = 0;
  setCurentTime(double value) {
    setState(() {
      curentTime = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: LinearProgressIndicator(
        value: curentTime,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
      ),
    );
  }
}
