import 'package:flutterapp/modus/record.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';
import '../../provider.dart';
import '../../utiles.dart';

class RecrodingFileItems extends StatefulWidget {
  const RecrodingFileItems({
    Key key,
    this.curentFile,
    this.index,
  }) : super(key: key);
  final RecroderModule curentFile;
  final int index;

  @override
  _RecrodingFileItemsState createState() => _RecrodingFileItemsState();
}

class _RecrodingFileItemsState extends State<RecrodingFileItems> {
  ScrollController controller = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

  double get winWidth => MediaQuery.of(context).size.width;

  double get time => (widget.curentFile.recrodingtime);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: animateScroll,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        controller: controller,
        child: Row(
          children: <Widget>[
            setInk(
              bgColor: Colors.white,
              ontap: cancle,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(
                    left: widget.curentFile.isActive ? BorderSide(width: 4, color: Theme.of(context).primaryColor) : BorderSide(width: 0),
                    bottom: BorderSide(width: 1, color: Color.fromRGBO(240, 240, 246, 1)),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[Text(widget.curentFile.title, style: TextStyle(fontSize: 14))]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Text('${formatTime(widget.curentFile.recrodingtime.toInt())}', style: textStyle),
                              ),
                              Container(margin: EdgeInsets.symmetric(horizontal: 5), child: Text(widget.curentFile.fileSize, style: textStyle)),
                              Expanded(child: Container()),
                              Container(child: Text(widget.curentFile.lastModified, style: textStyle))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: GestureDetector(child: Image.asset('asset/edit/icon_moving_white.png', width: 26), onTap: changeName),
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: GestureDetector(child: Image.asset('asset/edit/icon_delete_white.png', width: 26), onTap: deleteFile),
            ),
          ],
        ),
      ),
    );
  }

  ///改名
  void changeName() {
    alert(
      context,
      title: Text('要改名？！！！'),
      content: TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        autofocus: true,
        maxLength: 15,
        decoration: InputDecoration(hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            String newName = _textEditingController.text.trim();
            Provider.of<RecordListProvider>(context, listen: false).reName(index: widget.index, newName: newName);
            Navigator.pop(context);
            cancle();
          },
          child: Text('确定修改'),
        ),
        FlatButton(
          onPressed: () {
            _textEditingController.text = '';
            _focusNode.unfocus();
            Navigator.pop(context);
          },
          child: Text('放弃修改'),
        ),
      ],
    );
  }

  ///删除文件
  deleteFile() async {
    RecroderModule _rm = await Provider.of<RecordListProvider>(context, listen: false).deleteFile(widget.index);
    Provider.of<TranshProvider>(context, listen: false).trashs.add(_rm);
    cancle();
    eventBus.fire(DeleteFileSync(index: widget.index));
  }

  ///滚动动画
  animateScroll(e) {
    double offset = controller.offset;
    if (offset < winWidth / 6) {
      controller.animateTo(0, duration: Duration(milliseconds: 100), curve: Curves.linear);
    } else {
      controller.animateTo(winWidth + 200, duration: Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  ///还原滑动
  void cancle() {
    if (controller.offset > 0) {
      controller.animateTo(0, duration: Duration(milliseconds: 100), curve: Curves.linear);
    } else {
      if (Provider.of<RecordListProvider>(context, listen: false).preIndex == widget.index) return;
      Provider.of<RecordListProvider>(context, listen: false).changeState(widget.index);
      eventBus.fire(PlayingFile(widget.curentFile, widget.index));
    }
  }
}
