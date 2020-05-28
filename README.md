## 首次进入app

```flow
start=>start: 冷进入app
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





###  问题

> 1. list复用
> 2. 全局数据的保存和恢复问题
> 3. 播放时切换
> 4. 播放和暂停