import 'package:flutterapp/pages/list/recrodingFileItems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider.dart';

class RecordingList extends StatefulWidget {
  RecordingList({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _RecordingListState createState() => _RecordingListState();
}

class _RecordingListState extends State<RecordingList> {
  TextStyle textStyle = TextStyle(fontSize: 10, color: Colors.grey);

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<RecordListProvider>(context, listen: false).reset();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordListProvider>(
      builder: (context, conter, child) {
        return ListView.builder(
          itemCount: conter.recorderFiles.length,
          itemBuilder: (BuildContext context, int index) {
            return RecordingFileItems(
              curentFile: conter.recorderFiles[index],
              index: index,
            );
          },
        );
      },
    );
  }
}
