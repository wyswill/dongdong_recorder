import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  const Mine({Key key, this.arguments}) : super(key: key);
  final arguments;

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  List<Map<String, dynamic>> data = [
    {"icon": Icons.access_alarms, "title": "使用帮助", "router": '/'},
    {"icon": Icons.access_alarms, "title": "使用帮助", "router": '/'},
    {"icon": Icons.access_alarms, "title": "使用帮助", "router": '/'},
    {"icon": Icons.access_alarms, "title": "使用帮助", "router": '/'},
    {"icon": Icons.access_alarms, "title": "使用帮助", "router": '/'},
    {"icon": Icons.access_alarms, "title": "使用帮助", "router": '/'},
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
          Map<String, dynamic> curent = data[index];
          return buildItem(curent);
        },
        itemCount: data.length,
      ),
    );
  }

  Widget buildItem(Map<String, dynamic> curent) {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color.fromRGBO(187, 187, 187, 0.4),
              offset: Offset(0, 0),
              blurRadius: 5)
        ],
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            curent['icon'],
            color: Theme.of(context).primaryColor,
          ),
          Text(curent['title']),
        ],
      ),
    );
  }
}
