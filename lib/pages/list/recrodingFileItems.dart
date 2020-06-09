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
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);


  double get time => (widget.curentFile.recrodingtime);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
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
          ],
        ),
      ),
    );
  }

  ///还原滑动
  void cancle() {
    if (Provider.of<RecordListProvider>(context, listen: false).preIndex == widget.index) return;
    Provider.of<RecordListProvider>(context, listen: false).changeState(widget.index);
    eventBus.fire(PlayingFile(widget.curentFile, widget.index));
  }
}
