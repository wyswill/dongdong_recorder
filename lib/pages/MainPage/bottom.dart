import 'dart:async';
import 'dart:io';

import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/pages/recroding/recrod.dart';
import 'package:flutterapp/trashProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';
import '../../provider.dart';
import '../../utiles.dart';

enum bottomState { recode, deleteFiles }

class BottomshowBar extends StatefulWidget {
  BottomshowBar({Key key}) : super(key: key);

  @override
  _BottomshowBarState createState() => _BottomshowBarState();
}

class _BottomshowBarState extends State<BottomshowBar> with SingleTickerProviderStateMixin {
  RecroderModule plaingFile, trashFile;
  StreamSubscription streamSubscription;

  Animation<double> animation;
  AnimationController controller;

  double totalTime = 0;
  int index;
  bottomState currentState = bottomState.recode;
  Timer timer;
  int currentPlayingTime = 0;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  double width = 60;

  @override
  void initState() {
    super.initState();

    ///动画
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 200, end: 0).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    ///显示回收站操作选项
    streamSubscription = eventBus.on<TrashOption>().listen((event) async {
      setState(() {
        trashFile = event.rm;
        index = event.index;
        this.currentState = bottomState.deleteFiles;
      });
      controller.reset();
      controller.forward();
    });

    ///回收站页面退出时将panel切换
    streamSubscription = eventBus.on<NullEvent>().listen((event) async {
      if (this.currentState != bottomState.recode) {
        setState(() {
          plaingFile = null;
          this.currentState = bottomState.recode;
        });
        controller.reset();
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
    controller.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, animation.value),
      child: GetPanel(currentState),
    );
  }

  // ignore: missing_return, non_constant_identifier_names
  Widget GetPanel(bottomState state) {
    switch (this.currentState) {
      case bottomState.recode:
        return Container(
          margin: EdgeInsets.only(bottom: 56),
          child: Center(
            child: setInk(
              elevation: 6,
              shadowColor: Theme.of(context).primaryColor,
              bgColor: Colors.white,
              highlightColor: Color.fromRGBO(113, 119, 219, 1),
              borderRadius: BorderRadius.all(Radius.circular(50)),
              ontap: showRecroding,
              child: Container(
                width: 60,
                height: 60,
                child: Icon(Icons.mic, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        );
        break;
      case bottomState.deleteFiles:
        width = (MediaQuery.of(context).size.width - 99) / 3;
        return Container(
          padding: EdgeInsets.only(top: 13, bottom: 56, left: 33, right: 33),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: width,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)],
                ),
                child: FlatButton(child: Text('删除'), onPressed: delete),
              ),
              Container(
                width: width,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)],
                ),
                child: FlatButton(child: Text('还原'), onPressed: reset),
              ),
              Container(
                width: width,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[BoxShadow(color: Color.fromRGBO(187, 187, 187, 0.4), offset: Offset(0, 0), blurRadius: 5)],
                ),
                child: FlatButton(child: Text('取消'), onPressed: cancel),
              ),
            ],
          ),
        );
        break;
    }
  }

  ///删除
  void delete() async {
    alert(context, title: Text('是否删除当前文件?'), actions: [
      FlatButton(
        onPressed: () async {
          await File(trashFile.filepath).delete();
          Provider.of<TranshProvider>(context, listen: false).remove(index);
          setState(() {
            trashFile = null;
            currentState = bottomState.recode;
          });
          Navigator.pop(context);
        },
        child: Text('确认删除'),
      ),
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('取消'),
      )
    ]);
  }

  ///还原
  void reset() async {
    File file = File(trashFile.filepath);
    String newpath = await FileUtile.getRecrodPath();
    file.copySync('$newpath${trashFile.title}.wav');
    file.deleteSync();
    trashFile.filepath = '$newpath${trashFile.title}.wav';
    Provider.of<TranshProvider>(context, listen: false).remove(index);
    Provider.of<RecordListProvider>(context, listen: false).addRecrodItem(trashFile);
    cancel();
  }

  ///取消
  void cancel() {
    setState(() {
      trashFile = null;
      currentState = bottomState.recode;
    });
    controller.reset();
    controller.forward();
  }

  /***********播放器设置***********/

  /// 跳转到录音页面
  void showRecroding() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomCenter,
            child: Recrod(),
          );
        },
      ),
    );
  }
}
