import 'package:asdasd/pages/list/list.dart';
import 'package:flutter/material.dart';

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
      "widget": RecrodingList()
    },
    {
      "icon": Icon(Icons.today),
      "router": 'list',
      "isActive": false,
      "widget": RecrodingList()
    },
    {
      "icon": Icon(Icons.restore_from_trash),
      "router": 'list',
      "isActive": false,
      "widget": RecrodingList()
    },
    {
      "icon": Icon(Icons.search),
      "router": 'list',
      "isActive": false,
      "widget": RecrodingList()
    },
  ];
  TabController tabController;

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

  @override
  void initState() {
    super.initState();
    menus[0]['isActive'] = true;
    tabController = TabController(vsync: this, length: 5);
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
          )
        ],
      ),
      bottomNavigationBar: Container(
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
      ),
    );
  }
}
