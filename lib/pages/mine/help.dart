import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('使用帮助'), actions: [
        IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {},
        )
      ]),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
