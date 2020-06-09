import 'package:flutterapp/modus/record.dart';
import 'package:flutterapp/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../event_bus.dart';
import '../list/recrodingFileItems.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode node = FocusNode();
  TextEditingController controller = TextEditingController();
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);
  List<RecroderModule> datas = [];

  @override
  void dispose() {
    super.dispose();
    controller.text = '';
    controller.dispose();
    node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('TranshProvider');
    return Container(
      child: Column(
        children: <Widget>[
          setInput(),
          Expanded(
            child: ListView.builder(
              itemCount: datas.length,
              itemExtent: 50.0,
              itemBuilder: (context, index) {
                return RecordingFileItems(
                  curentFile: datas[index],
                  index: index,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ///输入框
  Widget setInput() {
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
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
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          icon: Icon(Icons.search),
        ),
        onEditingComplete: editingComplete,
      ),
    );
  }

  ///输入完成
  editingComplete() {
    String inputTitle = controller.text;
    List<RecroderModule> searchResault = [];
    List<RecroderModule> list = Provider.of<RecordListProvider>(context, listen: false).recorderFiles;
    list.forEach((element) {
      if (element.title.contains(inputTitle)) {
        element.reset();
        searchResault.add(element);
      }
    });
    setState(() {
      datas = searchResault;
      node.unfocus();
    });
  }

  ///播放录音
  playRecroding({RecroderModule curentFile, int index, String key}) {
    eventBus.fire(PlayingFile(curentFile,index));
  }
}
