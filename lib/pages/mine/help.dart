import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  List<Map<String, dynamic>> audioMannerger = [
        {'icon': 'asset/palying/icon_more-menu_blue.png', 'word': '音频文件列表管理'},
        {'icon': "asset/toolbar/icon_folder_blue.png", 'word': '文件夹管理，方便分类'},
        {'icon': "asset/toolbar/icon_calendar_blue.png", 'word': '日历，方便查找回溯'},
        {'icon': "asset/toolbar/icon_trash_blue.png", 'word': '回收站，删除或回复文件'},
        {'icon': "asset/toolbar/icon_Search_blue.png", 'word': '关键词查找文件'},
        {'icon': "asset/icon_Renaming.png", 'word': '重命名文件'},
        {'icon': "asset/icon_share.png", 'word': '移动到文件夹'},
        {'icon': "asset/palying/icon_more-menu_blue.png", 'word': '更多功能：复制、分享、保存到相册、编辑等'},
      ],
      audioRecord = [
        {'icon': "asset/home_recording/icon_Recording_blue.png", 'word': '录音功能'},
        {'icon': "asset/flag/icon_flag.png", 'word': '标记，给音频添加标记，记录重点'},
      ],
      audioPlay = [
        {'icon': "asset/step-forward.png", 'word': '下一个音频'},
        {'icon': "asset/step-backward.png", 'word': '上一个音频'},
        {'icon': "asset/fast_forward.png", 'word': '前进5秒'},
        {'icon': "asset/icon_back_forward.png", 'word': '后退5秒'},
        {'icon': "asset/palying/icon_timing.png", 'word': '定时暂停播放'},
        {'icon': "asset/palying/icon_Circulat_blue.png", 'word': '顺序播放、随机播放、单曲循环'},
        {'icon': "asset/palying/icon_Sheared_blue.png", 'word': '编辑当前音频'},
        {'icon': "asset/palying/icon_refresh2.png", 'word': '语音转文字'},
        {'icon': "asset/icon_share.png", 'word': '分享'},
        {'icon': "asset/palying/icon_more-menu_blue.png", 'word': '更多功能'},
      ],
      audioCute = [
        {'icon': "asset/sheared/icon_Sheared.png", 'word': '剪切'},
        {'icon': "asset/sheared/icon_remove_blue.png", 'word': '删除'},
        {'icon': "asset/sheared/icon_copy_blue.png", 'word': '粘贴'},
        {'icon': "asset/sheared/icon_Pasting_blue.png", 'word': '复制'},
        {'icon': "asset/sheared/icon_saved_blue.png", 'word': '保存'},
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Container(), title: Center(child: Text('使用帮助')), actions: [
        IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context);
            })
      ]),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(left: 30, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SetTitle('音频管理'),
            Column(
              children: List.generate(audioMannerger.length, (index) => itemBuilder(audioMannerger[index]['icon'], audioMannerger[index]['word'], context)),
            ),
            SetTitle('音频录制'),
            Column(
              children: List.generate(audioRecord.length, (index) => itemBuilder(audioRecord[index]['icon'], audioRecord[index]['word'], context)),
            ),
            SetTitle('音频播放'),
            Column(
              children: List.generate(audioPlay.length, (index) => itemBuilder(audioPlay[index]['icon'], audioPlay[index]['word'], context)),
            ),
            SetTitle('音频剪辑'),
            Column(
              children: List.generate(audioCute.length, (index) => itemBuilder(audioCute[index]['icon'], audioCute[index]['word'], context)),
            ),
          ],
        ),
      )),
    );
  }

  ///标题生成器
  Widget SetTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  ///单行生成器
  Widget itemBuilder(String icon, String word, BuildContext context) {
    return Row(children: [Image.asset(icon, width: 20), Text(word)]);
  }
}
