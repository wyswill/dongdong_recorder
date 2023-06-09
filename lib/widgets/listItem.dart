import 'dart:async';

import 'package:asdasd/event_bus.dart';
import 'package:asdasd/modus/record.dart';
import 'package:flutter/material.dart';

import '../utiles.dart';

class ListItem extends StatefulWidget {
  ListItem({Key key, this.datas, this.isRecrodingFile, this.cb})
      : super(key: key);
  final List<RecroderModule> datas;
  final bool isRecrodingFile;
  final Function cb;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  List<RecroderModule> datas;

  bool get isRecrodingFile => widget.isRecrodingFile;
  RecroderModule rm;
  int index;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    datas = widget.datas;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: datas.length,
      itemBuilder: folderItemStyle,
      separatorBuilder: folderseparatorBuilder,
    );
  }

  @override
  void dispose() {
    super.dispose();
    eventBus.fire(NullEvent());
    streamSubscription.cancel();
  }

  ///下划线
  Widget folderseparatorBuilder(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Color.fromRGBO(240, 240, 246, 1),
    );
  }

  ///文件菜单样式
  Widget folderItemStyle(BuildContext context, int index) {
    RecroderModule current = this.datas[index];
    return GestureDetector(
      onTap: () {
        showOptions(current, index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            left: rm != null &&
                    rm.recrodingtime == current.recrodingtime &&
                    rm.isPlaying
                ? BorderSide(width: 4, color: Theme.of(context).primaryColor)
                : BorderSide(width: 0),
          ),
        ),
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
                  Text(current.title),
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
                                  formatTime(int.parse(current.recrodingtime)),
                                  style: textStyle,
                                ),
                              )
                            : Text("个文件", style: textStyle),
                        Text(current.fileSize, style: textStyle),
                        Expanded(child: Container()),
                        Text(current.lastModified, style: textStyle),
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

  ///显示选项
  void showOptions(RecroderModule data, index) {
    eventBus.fire(TrashOption(data, index));
    if (rm == null) {
      setState(() {
        rm = data;
        rm.isPlaying = !rm.isPlaying;
      });
    } else if (rm.recrodingtime == data.recrodingtime)
      return;
    else
      setState(() {
        rm.isPlaying = !rm.isPlaying;
        data.isPlaying = true;
        rm = data;
      });
  }
}
