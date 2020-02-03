import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  Editor({this.key, this.arguments}) : super(key: key);
  final key;
  final arguments;

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
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
            onPressed: () {Navigator.pop(context);},
          )
        ],
      ),
      body: Container(
        child: Text('asfasdfasd'),
      ),
    );
  }

  ///保存
  void save() {}
}
