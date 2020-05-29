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
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

  double get winWidth => MediaQuery.of(context).size.width;

  int get time => int.parse(widget.curentFile.recrodingtime);

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
            GestureDetector(
              onTap: cancle,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  border: Border(
                    left: widget.curentFile.isActive ? BorderSide(width: 4, color: Theme.of(context).primaryColor) : BorderSide(width: 0),
                    bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(240, 240, 246, 1),
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        icon: widget.curentFile.isPlaying ? Icon(Icons.pause, color: Theme.of(context).primaryColor) : Icon(Icons.play_arrow, color: Colors.grey),
                        onPressed: playMusic,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Text(
                              widget.curentFile.title,
                              style: TextStyle(fontSize: 14),
                            )
                          ]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  formatTime(time.toInt()),
                                  style: textStyle,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  widget.curentFile.fileSize,
                                  style: textStyle,
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                child: Text(
                                  widget.curentFile.lastModified,
                                  style: textStyle,
                                ),
                              )
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
              child: GestureDetector(
                child: Image.asset('asset/edit/icon_moving_white.png', width: 26),
                onTap: () {},
              ),
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: GestureDetector(
                child: Image.asset('asset/edit/icon_delete_white.png', width: 26),
                onTap: deleteFile,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///删除文件
  deleteFile() async {
    RecroderModule _rm = await Provider.of<recrodListProvider>(context, listen: false).deleteFile(widget.index);
    Provider.of<transhProvider>(context, listen: false).trashs.add(_rm);
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
    double offset = controller.offset;
    if (offset > 0) {
      controller.animateTo(0, duration: Duration(milliseconds: 100), curve: Curves.linear);
    } else {
      Provider.of<recrodListProvider>(context, listen: false).changeState(widget.index);
      eventBus.fire(PlayingFile(widget.curentFile));
    }
  }

  ///播放音乐
  void playMusic() {}
}
