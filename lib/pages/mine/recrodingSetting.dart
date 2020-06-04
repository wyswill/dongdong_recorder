import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecroddSetting extends StatelessWidget {
  List<Map<String, String>> data = [
    {"title": '文件格式', "value": 'wav'},
    {"title": '采样率', "value": '4100'},
    {"title": '声道', "value": '单声道'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Container(), title: Center(child: Text('录音设置')), actions: [
        IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            })
      ]),
      body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text(
                    '${data[index]['title']}:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  Expanded(child: Container()),
                  Text(
                    '${data[index]['value']}',
                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(238, 236, 236, 1),
                    ),
                  ),
                ),
              ),
          itemCount: data.length),
    );
  }
}
