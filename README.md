#Offline-small-search  (离线小搜)
离线搜索软件,现支持离线搜题
------------
声明:所有离线包版权归其所有者所有,与本软件及软件开发人员无关,本软件仅提供搜索功能.

本软件采用GPL协议发布,希望所有人都能一起来改进本软件.

项目地址: [http://git.oschina.net/zjzdy/Offline-small-search](http://git.oschina.net/zjzdy/Offline-small-search)

当前版本: v1.5.15.10

##下载
* Android: [http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin](http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin)
* Android: [http://pan.baidu.com/s/1kTzUHCV](http://pan.baidu.com/s/1kTzUHCV)  密码: d9zp

##共享的离线包地址
* 高中试题离线包 [http://pan.baidu.com/s/1nt5WpaL](http://pan.baidu.com/s/1nt5WpaL) 密码: gyx9

##软件主要开发者:
* zjzdy(zjzengdongyang@163.com)

##编译
待补充

##感谢以下的项目,排名不分先后:
* Qt: [http://www.qt.io/](http://www.qt.io/)
* friso: [http://git.oschina.net/lionsoul/friso](http://git.oschina.net/lionsoul/friso)
* Lucene++: [https://github.com/luceneplusplus/LucenePlusPlus](https://github.com/luceneplusplus/LucenePlusPlus)
* Zimlib: [http://www.openzim.org/wiki/Zimlib](http://www.openzim.org/wiki/Zimlib) [https://git.wikimedia.org/summary/openzim](https://git.wikimedia.org/summary/openzim)

##已知问题
1. 在离线包管理中添加离线包时FileDialog显示错位,但按HOME返回主屏幕再进入即可解决. [QTBUG-48120] (https://bugreports.qt.io/browse/QTBUG-48120)
2. 离线包目录不可以包含中文.
3. 偶尔返回键出错.(发现并且可以复现请报bug,先以修复已经发现的所有出错情况)
4. 第一次进入内容界面字体过大,再次进入则恢复正常.

##TODO
1. 添加拍照搜索(使用OCR) [tesseract](https://github.com/tesseract-ocr/tesseract)
2. 支持更多类型的搜索:古诗文
3. 对横屏和桌面版进行专门适配
4. 整理离线包制作器代码,准备放出及开源
5. 添加数据和设置备份功能
6. 在线更新功能
7. 添加离线包下载模块,采用xml储存下载地址(离线包仓库形式,可自行扩展)