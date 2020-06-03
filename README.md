###  问题

 - [x] list复用
 - [x] 全局数据的保存和恢复问题
 - [x] 播放时切换
 - [x] 播放和暂停
- [x] 所有的按钮都没有点击态，看不到是否点击了
- [x] 录音一开始就给个默认文件名，用户可以不改动就用这个名字，可以用日期+时间来做默认名
- [x] 右上角的按钮无功能
- [ ] 点击详情里面添加改名功能
- [ ] 剪辑里面需要添加播放功能，如果是播放中，那松开手指的时候移动到该地方播放
- [ ] 点击开始时间戳和结束时间戳位置和红线位置不一样
- [ ] 剪辑的操作和流程建议模仿华为的录音机，目前的操作很别扭
- [ ] 转文字无功能

## 首次进入app

```flow
start=>start: 冷启动app
checkCache=>condition: 检测缓存路径中缓存文件是否存在
hasCache=>operation: 加载缓存到provider
noCache=>operation: 初始化provider
recrodeList=>operation: 显示录音列表页面
checkRecoderData=>condition: 检测provider中是否存在录音文件数据
renderList=>operation: 加载数据并渲染
initList=>operation: 显示默认界面

start->checkCache
checkCache(yes)->hasCache->recrodeList
checkCache(no)->noCache->recrodeList
recrodeList->checkRecoderData
checkRecoderData(yes)->renderList
checkRecoderData(no)->initList
```

## 录音界面

```flow
start=>start: 开始录音
checkName=>condition: 检测是否有文件名称
inputName=>inputoutput: 输入文件名
startRecroding=>operation: 开始录音
isEndRecroding=>condition: 是否结束录音
saveToGlouble=>operation: 获取录音信息,并保存到全局provide
returPage=>operation: 返回页面
end=>end: 退出录音界面
start->checkName
checkName(no)->inputName
checkName(yes)->startRecroding->isEndRecroding
isEndRecroding(yes)->saveToGlouble->end
isEndRecroding(no)->returPage
```




