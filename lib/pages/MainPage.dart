import 'package:flutter/material.dart';
import 'package:flutterapp/pages/songList.dart';
import 'package:flutterapp/pages/trashLsit.dart';

import 'bottom.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
  final arguments;

  MainPage({this.arguments});
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  Map plaingFile;

  @override
  void initState() {
    super.initState();

    ///设置tabbar
    menus[0]['isActive'] = true;
    tabController = TabController(
      vsync: this,
      length: 3,
    );

    ///设置tabView
    tabController.addListener(() {
      this.menus[tabController.index]['isActive'] = true;
      for (int i = 0; i < this.menus.length; i++) {
        if (i == tabController.index) continue;
        this.menus[i]['isActive'] = false;
      }
      setState(() {});
    });
  }

  List<Map> menus = [
    {
      "icon": "asset/toolbar/icon_List",
      "router": 'list',
      "isActive": false,
    },
    {
      "icon": 'asset/toolbar/icon_trash',
      "router": 'list',
      "isActive": false,
    },
    {
      "icon": 'asset/toolbar/icon_Search',
      "router": 'list',
      "isActive": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('录音机')),
      ),
      body: Column(
        children: [
          setTab(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              // ignore: missing_return
              children: List.generate(this.menus.length, (int index) {
                if (index == 0) return SongList();
                if (index == 1) return TrashList();
                if (index == 2) return SongList();
              }),
            ),
          ),
          BottomshowBar()
        ],
      ),
    );
  }

  ///设置tab
  Widget setTab() {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color.fromRGBO(187, 187, 187, 0.4),
                offset: Offset(0, 0),
                blurRadius: 5)
          ],
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: TabBar(
        controller: tabController,
        indicatorWeight: 0.01,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: List.generate(this.menus.length, (int index) {
          Map e = this.menus[index];
          return buildMeneuItem(e['icon'], e['router'], e['isActive'], index);
        }),
      ),
    );
  }

  ///菜单item
  Widget buildMeneuItem(String icon, String routers, bool isActive, int index) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: GestureDetector(
        child: Image.asset(
          isActive ? '${icon}_white.png' : '${icon}_blue.png',
          width: 23,
        ),
        onTap: () {
          if (this.menus[index]['isActive']) return;
          this.menus[index]['isActive'] = true;
          for (int i = 0; i < this.menus.length; i++) {
            if (i == index) continue;
            this.menus[i]['isActive'] = false;
          }
          setState(() {
            tabController.animateTo(index);
          });
        },
      ),
    );
  }
}
