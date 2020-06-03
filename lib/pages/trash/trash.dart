import 'package:flutterapp/event_bus.dart';
import 'package:flutterapp/modus/record.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:provider/provider.dart';
import '../../utiles.dart';

class trash extends StatefulWidget {
  trash({Key key}) : super(key: key);

  @override
  _trashState createState() => _trashState();
}

class _trashState extends State<trash> {
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

  List<RecroderModule> datas = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<transhProvider>(builder: (context, conter, child) {
      this.datas = conter.trashs;
      return ListView.separated(
        itemCount: conter.trashs.length,
        itemBuilder: folderItemStyle,
        separatorBuilder: folderseparatorBuilder,
      );
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    eventBus.fire(NullEvent());
    Provider.of<transhProvider>(context, listen: false).reset();
  }

  @override
  void dispose() {
    super.dispose();
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
    return setInk(
      ontap: () {
        showOptions(current, index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            left: current.isActive ? BorderSide(width: 4, color: Theme.of(context).primaryColor) : BorderSide(width: 0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Icon(Icons.play_arrow, color: Colors.grey),
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
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            formatTime(int.parse(current.recrodingtime)),
                            style: textStyle,
                          ),
                        ),
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
  void showOptions(RecroderModule rm, index) {
    Provider.of<transhProvider>(context, listen: false).trashSwitchState(index);
    eventBus.fire(TrashOption(rm, index));
  }
}
