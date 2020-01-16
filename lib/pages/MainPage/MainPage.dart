
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
      "icon": Icon(Icons.list),
      "router": 'list',
      "isActive": false,
      "widget": RecrodingList()
    },
    {
      "icon": Icon(Icons.folder),
      "router": 'list',
      "isActive": false,
      "widget": Folder()
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
      "widget": Trash()
    },
    {
      "icon": Icon(Icons.search),
      "router": 'list',
      "isActive": false,
      "widget": Text('asd')
    },
  ];

  TabController tabController;
  Map plaingFile;
  Animation<double> animation;
  AnimationController animationController;

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
    // animationController = AnimationController(
    //     vsync: this, duration: Duration(milliseconds: 1500));
    // controller = new AnimationController(
    //     vsync: this, duration: Duration(milliseconds: 1500));
    // animation = Tween<double>(begin: 0, end: 10).animate(controller);

    // controller.addListener(() {
    //   setState(() {});
    // });
    // controller.forward();

    /// 设置播放
    
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
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
}
