import 'package:flutter/material.dart';

class Folder extends StatefulWidget {
  Folder({Key key}) : super(key: key);

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  List<Map> datas = [
    {
      'title': "会议",
      "files": 3,
      "fileSize": "950kb",
      'lastDate': DateTime.now().toLocal().toString(),
    },
    {
      'title': "会议",
      "files": 3,
      "fileSize": "950kb",
      'lastDate': DateTime.now().toLocal().toString(),
    },
    {
      'title': "会议",
      "files": 3,
      "fileSize": "950kb",
      'lastDate': DateTime.now().toLocal().toString(),
    },
  ];
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: datas.length,
        itemBuilder: folderItemStyle,
        separatorBuilder: folderseparatorBuilder);
  }

  Widget folderseparatorBuilder(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Color.fromRGBO(240, 240, 246, 1),
    );
  }

  ///文件菜单样式
  Widget folderItemStyle(BuildContext context, int index) {
    Map curent = this.datas[index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.folder, color: Colors.grey),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(curent['title']),
                SizedBox(
                  child: Row(
                    children: <Widget>[
                      Text("${curent['files']}个文件", style: textStyle),
                      Text(curent['fileSize'], style: textStyle),
                      Expanded(child: Container()),
                      Text(curent['lastDate'], style: textStyle),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
