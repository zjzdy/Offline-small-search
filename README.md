#Offline-small-search  (离线小搜)
离线搜索软件,现支持离线搜题
------------
声明:所有离线包版权归其所有者所有,与本软件及软件开发人员无关,本软件仅提供搜索功能.
------------
本软件采用GPL协议发布,希望所有人都能一起来改进本软件.

项目地址: [http://git.oschina.net/zjzdy/Offline-small-search](http://git.oschina.net/zjzdy/Offline-small-search)

当前版本: v1.9.0 

##下载
* Android: [http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin](http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin)

##共享的离线包地址
注意：离线包版本请用最新版,程序不保证兼容旧版本的离线包.
* 高中试题离线包 [http://pan.baidu.com/s/1nt5WpaL](http://pan.baidu.com/s/1nt5WpaL) 密码: gyx9
* 离线包打包器 [http://git.oschina.net/zjzdy/Offline_Small_Search_pkg_build](http://git.oschina.net/zjzdy/Offline_Small_Search_pkg_build)
* 如果需要分享离线包,可联系我在此页面添加下载链接
* 因服务器资源有限,程序内的在线下载模块暂不开放离线包的下载,请自行下载添加
* 申明：离线包的内容版权归用原所有者所有,未申明相关版权的请在下载后24小时内删除,产生的后果程序开发者不负任何责任

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
2. 打开文件对话框后返回键失效
3. 部分js或css及嵌套html会加载失败(将在3.0版修复)

##TODO
1. 拍照搜索加速(OCR过慢)
2. 让启动界面消失的白屏
3. 在线更新功能
4. 完成所有预期功能,春节发布2.0版
* 5. 进行3.0版的重构(此项将于2017年高考完成后进行)
* 5.1 采用网页服务器方式进行内容浏览(预计使用Tufao)
* 5.2 整理界面代码和业务逻辑
* 5.2.1 使用QHash或QMap存储设置以及除离线包外的数据(历史纪录,收藏夹,离线包的部分元数据)
* 5.3 支持对docset的索引(SQLite)进行查询(Dash及Zeal)
* 5.4 自由浏览模式,类似Zeal但可以自定义网址