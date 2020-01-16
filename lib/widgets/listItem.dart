import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  ListItem({Key key, this.datas, this.isRecrodingFile, this.cb})
      : super(key: key);
  final List<Map> datas;
  final bool isRecrodingFile;
  final Function cb;
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  List<Map> get datas => widget.datas;
  bool get isRecrodingFile => widget.isRecrodingFile;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: datas.length,
      itemBuilder: folderItemStyle,
      separatorBuilder: folderseparatorBuilder,
    );
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
    Duration duration;
    if (isRecrodingFile) {
      duration = Duration(milliseconds: curent['rectimg']);
    }
    return GestureDetector(
      onTap: widget.cb,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Icon(isRecrodingFile ? Icons.play_arrow : Icons.folder,
                  color: Colors.grey),
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
                        isRecrodingFile
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  "${duration.inHours}:${duration.inMinutes}:${duration.inSeconds}",
                                  style: textStyle,
                                ),
                              )
                            : Text("${curent['files']}个文件", style: textStyle),
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
      ),
    );
  }
}
