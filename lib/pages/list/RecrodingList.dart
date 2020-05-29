import 'package:flutterapp/pages/list/recrodingFileItems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider.dart';

class RecrodingList extends StatefulWidget {
  RecrodingList({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _RecrodingListState createState() => _RecrodingListState();
}

class _RecrodingListState extends State<RecrodingList> {
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<recrodListProvider>(context, listen: false).reset();
  }
  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<recrodListProvider>(
      builder: (context, conter, child) {
        return ListView.builder(
          itemCount: conter.recroderFiles.length,
          itemExtent: 50.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return RecrodingFileItems(
              curentFile: conter.recroderFiles[index],
              index: index,
            );
          },
        );
      },
    );
  }
}
