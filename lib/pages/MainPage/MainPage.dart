import 'dart:async';

import 'package:asdasd/pages/list/list.dart';
import 'package:flutter/material.dart';
import 'package:asdasd/event_bus.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  List<Map> menus = [
    {
      "icon": Icon(Icons.list),
      "router": 'list',
      "isActive": false,
      "widget": RecrodingList()
    },
    {
      "icon": Icon(Icons.insert_drive_file),
      "router": 'list',
      "isActive": false,
      "widget": Text('asd')
    },
    {
      "icon": Icon(Icons.today),
      "router": 'list',
      "isActive": false,
      "widget": Text('asd')
    },
    {
      "icon": Icon(Icons.restore_from_trash),
      "router": 'list',
      "isActive": false,
      "widget": Text('asd')
    },
    {
      "icon": Icon(Icons.search),
      "router": 'list',
      "isActive": false,
      "widget": Text('asd')
    },
  ],
      playerIocns = [
    {'icon': Icons.timer, 'title': '定时'},
    {'icon': Icons.four_k, 'title': '倍速'},
    {'icon': Icons.cancel, 'title': '剪辑'},
    {'icon': Icons.translate, 'title': '转文字'},
    {'icon': Icons.list, 'title': '更多'},
  ];

  TabController tabController;
  StreamSubscription streamSubscription;
  Map plaingFile;

  @override
  void initState() {
    super.initState();

    ///设置tabbar
    menus[0]['isActive'] = true;
    tabController = TabController(vsync: this, length: 5);

    ///设置tabView
    tabController.addListener(() {
      setState(() {
        this.menus[tabController.index]['isActive'] = true;
        for (int i = 0; i < this.menus.length; i++) {
          if (i == tabController.index) continue;
          this.menus[i]['isActive'] = false;
        }
      });
    });

    /// 设置播放
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
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_circle),
        title: Center(child: Text('录音机')),
        actions: <Widget>[Icon(Icons.list)],
      ),
      body: Column(
        children: <Widget>[
          setTab(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: List.generate(this.menus.length, (int index) {
                Map curent = this.menus[index];
                return curent['widget'];
              }),
            ),
          ),
          setBottom()
        ],
      ),
    );
  }

  ///菜单item
  Widget buildMeneuItem(Widget icon, String routers, bool isActive, int index) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: IconButton(
        icon: icon,
        color: isActive ? Colors.white : Theme.of(context).primaryColor,
        onPressed: () {
          if (this.menus[index]['isActive']) return;
          setState(() {
            tabController.animateTo(index);
            this.menus[index]['isActive'] = true;
            for (int i = 0; i < this.menus.length; i++) {
              if (i == index) continue;
              this.menus[i]['isActive'] = false;
            }
          });
        },
      ),
    );
  }

  ///设置tab
  Widget setTab() {
    return Container(
      height: 40,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 5)
          ],
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: TabBar(
        controller: tabController,
        indicatorWeight: 0.01,
        tabs: List.generate(this.menus.length, (int index) {
          Map e = this.menus[index];
          return buildMeneuItem(e['icon'], e['router'], e['isActive'], index);
        }),
      ),
    );
  }

  ///设置底部
  Widget setBottom() {
    if (plaingFile != null) {
      Duration duration = Duration(milliseconds: plaingFile['rectimg']);
      return Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(right: 13, top: 15, bottom: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)
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
                          eventBus
                              .fire(PlayingState(this.plaingFile['isPlaying']));
                        }),
                    Text('0:0:0', style: TextStyle(color: Colors.grey)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
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
                      this.plaingFile = null;
                    });
                    eventBus.fire(PlayingState(false));
                  },
                ),
              ),
            ),
          )
        ],
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
