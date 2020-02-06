import 'package:asdasd/modus/record.dart';
import 'package:asdasd/utiles.dart';
import 'package:flutter/material.dart';

import '../../event_bus.dart';
import '../list/recrodingFileItems.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, List<RecroderModule>> datas = {}, searchResault;

  FocusNode node = FocusNode();
  TextEditingController controller = TextEditingController();
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  List dataKeys = [], searchKeys = [];

  @override
  void didChangeDependencies() async {
    searchResault = {};
    super.didChangeDependencies();
    datas = await FileUtile().getSearchResult();
    dataKeys = datas.keys.toList();
  }

  @override
  void dispose() {
    super.dispose();
    controller.text = '';
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          setInput(),
          Expanded(
            child: CustomScrollView(
              slivers: List.generate(this.searchKeys.length, (int index) {
                return buildRecrodingItem(index);
              }),
            ),
          )
        ],
      ),
    );
  }

  ///每组录音数据样式
  Widget buildRecrodingItem(int index) {
    String curnetKey = searchKeys[index];
    List<RecroderModule> curentRecrodingFiles = this.searchResault[curnetKey];
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20),
            color: Color.fromRGBO(242, 241, 244, 1),
            child: Text(curnetKey),
          ),
          Column(
            children: List.generate(curentRecrodingFiles.length, (int ind) {
              RecroderModule curentFile = curentRecrodingFiles[ind];
              return RecrodingFileItems(
                curentFile: curentFile,
                playRecroding: this.playRecroding,
                index: ind,
                curnetKey: curnetKey,
              );
            }),
          )
        ],
      ),
    );
  }

  ///输入框
  Widget setInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
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
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
        onEditingComplete: EditingComplete,
      ),
    );
  }

  ///展示搜索结果
  Widget showItems(RecroderModule rm) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          left: rm.isPlaying
              ? BorderSide(width: 4, color: Theme.of(context).primaryColor)
              : BorderSide(width: 0),
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
                Text(rm.title),
                SizedBox(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          formatTime(int.parse(rm.recrodingtime)),
                          style: textStyle,
                        ),
                      ),
                      Text(rm.fileSize, style: textStyle),
                      Expanded(child: Container()),
                      Text(rm.lastModified, style: textStyle),
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

  void EditingComplete() {
    String inputStr = controller.text.trim();
    Map<String, List<RecroderModule>> searchMap = {};
    for (int i = 0; i < dataKeys.length; i++) {
      String curnetKey = dataKeys[i];
      List<RecroderModule> curentRecrodingFiles = this.datas[curnetKey],
          searchList = [];
      bool flg;
      curentRecrodingFiles.forEach((RecroderModule ele) {
        flg = ele.title.contains(inputStr);
        if (flg) searchList.add(ele);
      });
      if (flg) {
        searchMap[curnetKey] = searchList;
      }
    }
    setState(() {
      searchKeys = searchMap.keys.toList();
      searchResault = searchMap;
    });
    node.unfocus();
  }

  ///播放录音
  playRecroding({RecroderModule curentFile, int index, String key}) {
//    List<RecroderModule> rms = datas[key];
//    for (int i = 0; i < rms.length; i++) {
//      RecroderModule curentrm = rms[i];
//      if (index == i)
//        curentrm.isActive = !curentrm.isActive;
//      else
//        curentrm.isActive = false;
//    }
//    setState(() {
//      key = key;
//      curentPlayRecroding = curentFile;
//      curentindex = index;
//    });
    eventBus.fire(PlayingFile(curentFile));
  }
}
