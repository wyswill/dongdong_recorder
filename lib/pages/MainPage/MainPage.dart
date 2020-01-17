import 'package:asdasd/pages/folder/folder.dart';
import 'package:asdasd/pages/list/list.dart';
import 'package:asdasd/pages/trash/trash.dart';
import 'package:flutter/material.dart';

import 'bottom.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  List<Map> menus = [
    {
      "icon": "asset/toolbar/icon_List",
      "router": 'list',
      "isActive": false,
      "widget": RecrodingList()
    },
    {
      "icon": 'asset/toolbar/icon_folder',
      "router": 'list',
      "isActive": false,
      "widget": Folder()
    },
    {
      "icon": "asset/toolbar/icon_calendar",
      "router": 'list',
      "isActive": false,
      "widget": Text('asd')
    },
    {
      "icon": 'asset/toolbar/icon_trash',
      "router": 'list',
      "isActive": false,
      "widget": Trash()
    },
    {
      "icon": 'asset/toolbar/icon_Search',
      "router": 'list',
      "isActive": false,
      "widget": Text('asd')
    },
  ];

  TabController tabController;
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
  }

  @override
  void dispose() {
    super.dispose();
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
          BottomshowBar()
        ],
      ),
    );
  }

  ///菜单item
  Widget buildMeneuItem(String icon, String routers, bool isActive, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
}
