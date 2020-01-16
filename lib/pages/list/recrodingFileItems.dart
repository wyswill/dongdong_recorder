import 'package:flutter/material.dart';

class RecrodingFileItems extends StatefulWidget {
  const RecrodingFileItems(
      {Key key, this.playRecroding, this.curentFile, this.index})
      : super(key: key);
  final Map curentFile;
  final Function playRecroding;
  final int index;

  @override
  _RecrodingFileItemsState createState() => _RecrodingFileItemsState();
}

class _RecrodingFileItemsState extends State<RecrodingFileItems> {
  ScrollController controller = ScrollController();
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

  double get winWidth => MediaQuery.of(context).size.width;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(milliseconds: widget.curentFile['rectimg']);
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
                    left: widget.curentFile['isPlaying']
                        ? BorderSide(
                            width: 4, color: Theme.of(context).primaryColor)
                        : BorderSide(width: 0),
                    bottom: BorderSide(
                        width: 1, color: Color.fromRGBO(240, 240, 246, 1)),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        icon: widget.curentFile['isPlaying']
                            ? Icon(Icons.pause,
                                color: Theme.of(context).primaryColor)
                            : Icon(Icons.play_arrow, color: Colors.grey),
                        onPressed: () {
                          widget.playRecroding(curentFile: widget.curentFile);
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Text(
                              widget.curentFile['title'],
                              style: TextStyle(fontSize: 14),
                            )
                          ]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
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
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  widget.curentFile['fileSize'],
                                  style: textStyle,
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                child: Text(
                                  widget.curentFile['lastDate'],
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
              child: IconButton(
                  icon: Icon(Icons.person_pin, color: Colors.white),
                  onPressed: () {}),
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: IconButton(
                  icon: Icon(Icons.person_pin, color: Colors.white),
                  onPressed: () {}),
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: IconButton(
                  icon: Icon(Icons.person_pin, color: Colors.white),
                  onPressed: () {}),
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: IconButton(
                  icon: Icon(Icons.person_pin, color: Colors.white),
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  ///滚动动画
  animateScroll(e) {
    double offset = controller.offset;
    if (offset < winWidth / 4) {
      controller.animateTo(0,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    } else {
      controller.animateTo(winWidth + 200,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  ///
  void cancle() {
    double offset = controller.offset;
    if (offset > 0) {
      controller.animateTo(0,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    } else
      return;
  }
}
