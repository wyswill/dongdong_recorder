import 'package:flutter/material.dart';
import 'package:flutterapp/pages/list/RecrodingList.dart';
import 'package:flutterapp/pages/search/search.dart';
import 'package:flutterapp/pages/trash/trash.dart';
import 'bottom.dart';

class MainPage extends StatefulWidget {
  MainPage({this.arguments});

  final arguments;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  List<Map> menus = [
    {"icon": "asset/toolbar/icon_List", "router": 'list', "isActive": false},
    {"icon": 'asset/toolbar/icon_trash', "router": 'list', "isActive": false},
    {"icon": 'asset/toolbar/icon_Search', "router": 'list', "isActive": false},
  ];
  List<Widget> pages = [RecrodingList(), Trash(), SearchPage()];
  PageController pageController;
  TabController tabController;
  Map plaingFile;
  int preIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(() {
      setState(() {
        pageController.animateToPage(tabController.index, duration: Duration(milliseconds: 200), curve: ElasticOutCurve(4));
      });
    });
    pageController = new PageController(initialPage: preIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/mine');
              },
            ),
            Padding(padding: EdgeInsets.only(left: 89), child: Text('咚咚录音机'))
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          setTab(),
          Expanded(
            child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: changeHandler,
                itemBuilder: (context, index) {
                  return Offstage(
                    child: pages[index],
                    offstage: index != preIndex,
                  );
                }),
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
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)], borderRadius: BorderRadius.all(Radius.circular(2))),
      child: TabBar(
        controller: tabController,
        indicatorColor: Color.fromRGBO(87, 92, 159, 1),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: List.generate(this.menus.length, (int index) {
          Map e = this.menus[index];
          return Tab(
            child: Image.asset(
              e['isActive'] ? '${e['icon']}_white.png' : '${e['icon']}_blue.png',
              width: 25,
            ),
          );
        }),
      ),
    );
  }

  void changeHandler(int index) {
    tabController.animateTo(index, duration: Duration(milliseconds: 200), curve: ElasticOutCurve(4));
    setState(() {
      preIndex = index;
    });
  }
}
