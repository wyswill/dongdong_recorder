import 'package:asdasd/modus/cancasRectModu.dart';
import 'package:asdasd/modus/record.dart';
import 'package:asdasd/widgets/showSoung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utiles.dart';
import 'musicProgress.dart';

class Editor extends StatefulWidget {
  Editor({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  FocusNode node = FocusNode();
  TextEditingController controller = TextEditingController();
  List<Map> playerIocns = [
    {'icon': 'asset/palying/icon_timing.png', 'title': '定时'},
    {'icon': 'asset/palying/icon_Circulat_blue.png', 'title': '全部循环'},
    {'icon': 'asset/palying/icon_speed_normal.png', 'title': '倍速'},
    {'icon': 'asset/palying/icon_refresh2.png', 'title': '转文字'},
    {'icon': 'asset/palying/icon_more-menu_blue.png', 'title': '更多'},
  ],
      options = [
    {'icon': 'asset/sheared/icon_Sheared.png', 'title': '剪切'},
    {'icon': 'asset/sheared/icon_Pasting_blue.png', 'title': '复制'},
    {'icon': 'asset/sheared/icon_copy_blue.png', 'title': '粘贴'},
    {'icon': 'asset/sheared/icon_remove_blue.png', 'title': '删除'},
    {'icon': 'asset/sheared/icon_saved_blue.png', 'title': '保留'},
  ];
  String currenttime = '0:0:0';
  GlobalKey<MusicProgressState> key = GlobalKey();
  GlobalKey<ShowSounState> showSounkey = GlobalKey();
  double left = 0, right = 60, audioTimeLength = 0;
  List<CanvasRectModu> recrodingData = [], templist = [];
  MethodChannel channel = const MethodChannel("com.lanwanhudong");
  Color gary = Colors.grey;

  Color get mainColor => Theme.of(context).primaryColor;

  RecroderModule get rm => widget.arguments;

  @override
  void initState() {
    super.initState();
    controller.text = rm.title;
    node.addListener(() {
      print("焦点被几激活了");
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var data =
        await this.channel.invokeListMethod('fft', {"path": rm.filepath});
    recrodingData = await transfrom(data.toList());
    recrodingOffset(0);
  }

  @override
  void dispose() {
    controller.dispose();
    node.unfocus();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: GestureDetector(
            onTap: save,
            child: Text("保存"),
          ),
        ),
        title: Center(
          child: Text('剪辑'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        bottom: this.setInput(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    height: 190,
                    child: setCanvas(),
                  ),
                ],
              ),
            ),
            setOptions(),
          ],
        ),
      ),
      bottomNavigationBar: setButtom(),
    );
  }

  ///设置音频波形画布
  Widget setCanvas() {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails e) {
        double offset = e.delta.dx;
        recrodingOffset(offset);
      },
      child: ShowSoun(
        key: showSounkey,
        recriodingTime: this.audioTimeLength,
        isEditor: true,
      ),
    );
  }

  ///剪辑选项
  Widget setOptions() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey)],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: this.options.map((e) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                e['icon'],
                width: 20,
              ),
              Text(
                e['title'],
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 12),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  ///输入框
  Widget setInput() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        padding: EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: TextField(
          controller: controller,
          focusNode: node,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '输入录音标题',
              hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }

  ///底部
  Widget setButtom() {
    return Container(
      height: 200,
      padding: EdgeInsets.only(right: 13, top: 15, bottom: 30),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey, offset: Offset(0, 7), blurRadius: 20)
      ]),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: this
                  .playerIocns
                  .map((e) => Container(
                          child: GestureDetector(
                        onTap: () {
                          switch (e['title']) {
                            case "定时":
                              this.setTimeout();
                              break;
                            case "全部循环":
                              this.circulation();
                              break;
                            case "倍速":
                              this.pias();
                              break;
                            case "转文字":
                              this.transiton();
                              break;
                            case "更多":
                              this.more();
                              break;
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              e['icon'],
                              width: 20,
                            ),
                            Text(
                              e['title'],
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      )))
                  .toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Text(currenttime, style: TextStyle(color: Colors.grey)),
                Expanded(child: MusicProgress(key: key)),
                Text(formatTime(int.parse(rm.recrodingtime)),
                    style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    color: gary,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.replay,
                    color: gary,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: mainColor,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: gary,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: gary,
                  ),
                  onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  ///保存
  void save() {}

  ///数据左右滑动
  recrodingOffset(double offset) {
    double ofs = offset.floorToDouble();
    List<CanvasRectModu> newList;
    left += ofs;
    right = (-left) + 120;
    if (-left.floor() < 0) {
      left -= ofs;
      return;
    }
    if (right > recrodingData.length) {
      left -= ofs;
      right = recrodingData.length.toDouble();
      return;
    }
    var newList2 = recrodingData.getRange(-left.floor(), right.floor());
    newList = newList2.toList();
    showSounkey.currentState.setRecrodingData(newList);
  }

  ///播放音乐
  void play() async {}

  ///定时选择
  void setTimeout() {}

  ///全部循环
  void circulation() {}

  ///倍速
  void pias() {}

  ///转文字
  void transiton() {}

  ///更多
  void more() {}

  List<CanvasRectModu> addHeadOrTail(List<CanvasRectModu> arr) {
    int columns_count = 80;
    for (int i = 0; i < columns_count; i++) {
      arr.add(CanvasRectModu(vlaue: 2, type: CanvasRectTypes.point));
    }
    return arr;
  }

  ///将波形按照毫秒的时域进行转换
  Future<List> transfrom(List data) async {
    ///获取录音时间
    double recrodingtime = (data.length / 8000) * 100;

    ///总数据长度除以录音时长
    int flag = (data.length / recrodingtime).floor(), stp = 0;
    List<CanvasRectModu> res = [];
    res = addHeadOrTail(res);
    for (int i = 0; i < data.length; i++) {
      if ((i + 1) < data.length) {
        double curent = data[i],
            next = data[i + 1],
            cha = curent - next,
            flag2 = 0;
        if (stp == flag) {
          if (cha > flag2) res.add(CanvasRectModu(vlaue: curent));
          stp = 0;
        }
        stp++;
      }
    }
    res = addHeadOrTail(res);
    return res;
  }
}
