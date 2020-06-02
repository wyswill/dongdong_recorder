import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  const Mine({Key key, this.arguments}) : super(key: key);
  final arguments;

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  List<Map<String, String>> data = [
    {"icon": 'asset/setting/icon_help_blue.png', "title": "使用帮助", "router": '/help'},
//    {"icon": 'asset/setting/icon_Instructions_blue.png', "title": "快捷指令", "router": '/'},
    {"icon": 'asset/setting/icon_seeting_blue.png', "title": "录音设置", "router": '/recrodeSetting'},
//    {"icon": 'asset/setting/icon_help_blue.png', "title": "分享给朋友", "router": '/'},
//    {"icon": 'asset/setting/info-sign.png', "title": "关于", "router": '/'},
//    {"icon": 'asset/setting/icon_pencil_b.png', "title": "意见设置", "router": '/'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Center(child: Text('我的')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/mainPage');
              })
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return buildItem(data[index]);
        },
        itemCount: data.length,
      ),
    );
  }

  Widget buildItem(Map<String, String> curent) {
    return GestureDetector(
      onTap: () {
        jump(curent['router']);
      },
      child: Container(
        height: 48,
        margin: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)],
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image.asset(curent['icon'],width: 20,),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(curent['title']),
            ),
            Expanded(
              child: Container(),
            ),
            Icon(Icons.arrow_right)
          ],
        ),
      ),
    );
  }

  jump(String path) {
    Navigator.pushNamed(context, path);
  }
}
