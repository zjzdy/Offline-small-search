#Offline-small-search  (离线小搜)
离线搜索软件,现支持离线搜题
------------
声明:所有离线包版权归其所有者所有,与本软件及软件开发人员无关,本软件仅提供搜索功能.
------------
本软件采用GPL协议发布,希望所有人都能一起来改进本软件.

项目地址: [http://git.oschina.net/zjzdy/Offline-small-search](http://git.oschina.net/zjzdy/Offline-small-search)

当前版本: v1.8.1.15.12 

##下载
* Android: [http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin](http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin)
* Android: [http://pan.baidu.com/s/1kTzUHCV](http://pan.baidu.com/s/1kTzUHCV)  密码: d9zp

##共享的离线包地址
注意：离线包版本请用最新版,程序不保证兼容旧版本的离线包.
* 高中试题离线包 [http://pan.baidu.com/s/1nt5WpaL](http://pan.baidu.com/s/1nt5WpaL) 密码: gyx9

##软件主要开发者:
* zjzdy(zjzengdongyang@163.com)

##编译
待补充

##感谢以下的项目,排名不分先后:
* Qt: [http://www.qt.io/](http://www.qt.io/)
* Zimlib: [http://www.openzim.org/wiki/Zimlib](http://www.openzim.org/wiki/Zimlib) [https://git.wikimedia.org/summary/openzim](https://git.wikimedia.org/summary/openzim)
* Xpian: [http://xapian.org](http://xapian.org)
* OpenCV: [http://www.opencv.org](http://www.opencv.org)
* Tesseract: [https://github.com/tesseract-ocr/tesseract](https://github.com/tesseract-ocr/tesseract)


##已知问题
1. 离线包目录不可以包含中文.
2. 偶尔返回键出错.(发现并且可以复现请报bug,现已修复已经发现的所有出错情况)
3. 部分js或css及嵌套html会加载失败(将在3.0版修复)

##TODO
1. 拍照搜索加速(OCR过慢)
2. 对横屏和桌面版进行专门适配(测试中)
3. 添加数据和设置备份功能
4. 在线更新功能
5. 进行3.0版的重构(此项将于2017年高考完成后进行)
5.1 采用网页服务器方式进行内容浏览(预计使用Tufao)
5.2 整理界面代码和业务逻辑
5.2.1 使用QHash或QMap存储设置以及除离线包外的数据(历史纪录,收藏夹,离线包的部分元数据)
5.3 支持对docset的索引(SQLite)进行查询(Dash及Zeal)
5.4 自由浏览模式,类似Zeal但可以自定义网址