import 'dart:async';

import 'package:flutter/material.dart';

import '../../event_bus.dart';

class BottomshowBar extends StatefulWidget {
  BottomshowBar({Key key}) : super(key: key);
  @override
  _BottomshowBarState createState() => _BottomshowBarState();
}

class _BottomshowBarState extends State<BottomshowBar> {
  Map plaingFile;
  StreamSubscription streamSubscription;
  List<Map> playerIocns = [
    {'icon': Icons.timer, 'title': '定时'},
    {'icon': Icons.four_k, 'title': '倍速'},
    {'icon': Icons.cancel, 'title': '剪辑'},
    {'icon': Icons.translate, 'title': '转文字'},
    {'icon': Icons.list, 'title': '更多'},
  ];
  @override
  void initState() {
    super.initState();
    streamSubscription = eventBus.on<PlayingFile>().listen((event) {
      setState(() {
        plaingFile = event.file;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (plaingFile != null) {
      Duration duration = Duration(milliseconds: plaingFile['rectimg']);
      return Transform.translate(
        offset: Offset(0, 0),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(right: 13, top: 15, bottom: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 7),
                          blurRadius: 20)
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: this
                            .playerIocns
                            .map((e) => Container(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {},
                                        child: Icon(
                                          e['icon'],
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        e['title'],
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              this.plaingFile['isPlaying']
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                this.plaingFile['isPlaying'] =
                                    !this.plaingFile['isPlaying'];
                              });
                              eventBus.fire(
                                  PlayingState(this.plaingFile['isPlaying']));
                            }),
                        Text('0:0:0', style: TextStyle(color: Colors.grey)),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Text(
                            "${duration.inHours}:${duration.inMinutes}:${duration.inSeconds}",
                            style: TextStyle(color: Colors.grey))
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: ClipOval(
                child: Container(
                  width: 20,
                  height: 20,
                  color: Theme.of(context).primaryColor,
                  child: GestureDetector(
                    child: Icon(Icons.close, size: 20, color: Colors.white),
                    onTap: () {
                      setState(() {
                        plaingFile = null;
                      });
                      eventBus.fire(PlayingState(false));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else
      return Container(
        padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
        decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.timer),
                  onPressed: () {},
                ),
              ),
            ),
            ClipOval(
              child: Container(
                width: 60,
                height: 60,
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.mic),
                  onPressed: () {},
                ),
              ),
            ),
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.text_rotation_down),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      );
  }
}
