#Offline-small-search  (离线小搜)
离线搜索软件,现支持离线搜题,搜古诗文,搜开发文档,等等.可自行打包离线包.
------------
声明:所有离线包版权归其所有者所有,与本软件及软件开发人员无关,本软件仅提供搜索功能.

本软件采用GPL协议发布,希望所有人都能一起来改进本软件.

###项目地址:
Git@OSC:[http://git.oschina.net/zjzdy/Offline-small-search](http://git.oschina.net/zjzdy/Offline-small-search)

GitHub Mirror:[https://github.com/zjzdy/Offline-small-search](https://github.com/zjzdy/Offline-small-search)

主页: [http://zjzdy.oschina.io/oss/](http://zjzdy.oschina.io/oss/)

当前版本: v2.2.0

##功能及特点
* 离线全文检索,采用高度压缩打包的ZIM文件存储数据
* 可任意自行打包或添加离线包
* 网址自定义,支持外部链接
* 收藏夹,历史纪录
* 搜索单一离线包,一键搜索所有离线包
* 拍照搜索(需下载相关模块)
* 在线翻译(使用有道翻译)(Android平台需要Android 4.4及以上)
* 简体繁体自动转换搜索,无论繁体还是简体都可以找到
* 更多功能等待发现

##下载
####Git@OSC
* Android: [http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Android](http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Android)
* Windows: [http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Windows](http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Windows)
* All: [http://git.oschina.net/zjzdy/Offline-small-search/releases/](http://git.oschina.net/zjzdy/Offline-small-search/releases/)

####GitHub
* Android: [https://github.com/zjzdy/Offline-small-search/tree/master/bin/Android](https://github.com/zjzdy/Offline-small-search/tree/master/bin/Android)
* Windows: [https://github.com/zjzdy/Offline-small-search/tree/master/bin/Windows](https://github.com/zjzdy/Offline-small-search/tree/master/bin/Windows)
* All: [https://github.com/zjzdy/Offline-small-search/releases](https://github.com/zjzdy/Offline-small-search/releases)

####网盘
* 百度网盘: [http://pan.baidu.com/s/1mhnmlEK](http://pan.baidu.com/s/1mhnmlEK) 密码: 396f
* 360云盘: [https://yunpan.cn/cx8yUeFyJypM5](https://yunpan.cn/cx8yUeFyJypM5) 密码: 0205

##共享的离线包地址
注意：离线包版本请用最新版,程序不保证兼容旧版本的离线包.
* 中小学试题离线包 [http://pan.baidu.com/s/1o7KGd8Q](http://pan.baidu.com/s/1o7KGd8Q) 密码: cqwx
* 古诗文离线包 [http://pan.baidu.com/s/1i4P9ZDj](http://pan.baidu.com/s/1i4P9ZDj) 密码: hre8
* 开发文档离线包 [http://pan.baidu.com/s/1geD2PLD](http://pan.baidu.com/s/1geD2PLD) 密码: mc6s
* 开发文档离线包(360云盘分流) [https://yunpan.cn/c6Fn4Ly4SSGqq](https://yunpan.cn/c6Fn4Ly4SSGqq) 密码: 6311
* 离线包打包器 [http://git.oschina.net/zjzdy/Offline_Small_Search_pkg_build](http://git.oschina.net/zjzdy/Offline_Small_Search_pkg_build)
* 如果需要分享离线包,可联系我在此页面添加下载链接
* 因服务器资源有限,程序内的在线下载模块暂不开放离线包的下载,请自行下载添加
* 申明：离线包的内容版权归用原所有者所有,未申明相关版权的请在下载后24小时内删除,产生的后果程序开发者不负任何责任

##软件主要开发者:
* zjzdy(zjzengdongyang@163.com)

##截图
![Main](Screenshots/main.png)

![More_search](Screenshots/more_search.png)

##编译
##Windows版本编译
本过程基于Qt 5.6.1 for Windows(msys2 mingw32)或Qt 5.7.0 for Windows(用msys2 mingw32环境自行编译), OpenCV 3.1.0, Xapian 1.4.0, xz 5.2.2, Leptonica 1.73编写,Windows x86_64(win7及以上)环境运行.

所有代码均在msys2的mingw32_shell中运行.
###0.准备项目
安装必须的软件,下载或克隆项目.
```
pacman -Syu
pacman -S --noconfirm --needed mingw-w64-i686-tesseract-ocr mingw-w64-i686-qt-creator mingw-w64-i686-qt5-static mingw-w64-i686-qt5 mingw-w64-i686-leptonica mingw-w64-i686-opencv mingw-w64-i686-xz mingw-w64-i686-zlib mingw-w64-i686-toolchain base-devel git unzip p7zip xz tar wget zip
git clone http://git.oschina.net/zjzdy/Offline-small-search
cd Offline-small-search/
export ossbuild=$PWD
```
###1.编译 Xapian
到Xapian的官网去下载最新版本的Xapian core

下载地址:[http://xapian.org/download](http://xapian.org/download)

以下使用xapian-core-1.4.0.tar.xz
```
wget http://oligarchy.co.uk/xapian/1.4.0/xapian-core-1.4.0.tar.xz
tar -xf xapian-core-1.4.0.tar.xz
cd xapian-core-1.4.0/
./configure --prefix="${ossbuild}/build-bin/" --enable-backend-inmemory=no --enable-static
make
make install
cd ../
```
###2.编译 zimlib
```
cd zimlib/
./autogen.sh
./configure --prefix="${ossbuild}/build-bin/"
make
make install
cd ../
```
###3.编译 离线小搜
0.对部分头文件进行处理
```
cp /mingw32/include/tesseract/tesscallback.h /mingw32/include/tesseract/tesscallback.h.bak
sed -i 's/template <class T> struct remove_reference;//g' /mingw32/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference { typedef T type; };//g' /mingw32/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference<T&> { typedef T type; };//g' /mingw32/include/tesseract/tesscallback.h
```
1.打开Qt Creator

2.打开Offline_small_search.pro
```
qtcreator Offline_small_search.pro
```
3.选择配置Desktop Qt (static) MinGW-w64 32bit (MSYS2)

4.选择Release

5.点击构建

注意:如果构建之后无法运行,需要重新编译qt库
```
export OPENSSL_LIBS="-lssl -lcrypto -lcrypt32 -lgdi32"
./configure.bat -qt-libjpeg -qt-harfbuzz -qt-libpng -qt-pcre -qt-zlib -no-fontconfig -nomake examples -platform win32-g++ -no-iconv -opensource -confirm-license -openssl-linked -icu -dbus -qt-sql-sqlite -no-sql-ibase -no-sql-psql -no-sql-mysql -no-sql-odbc -qt-freetype -release  -opengl desktop OPENSSL_LIBS="-lssl -lcrypto -lcrypt32 -lgdi32" -prefix "${ossbuild}/build-bin/Qt"
sed -i 's/if OS(WINDOWS)/if OS(WINDOWS) && !COMPILER(GCC)/g' qtwebkit/Source/WTF/wtf/Atomics.h
make
make install
在QtCreator中添加Qt Versions和构建套件(Kits),重复3.1-3.5步骤
```

###4.安装 离线小搜
还原对系统文件的修改
```
rm /mingw32/include/tesseract/tesscallback.h
mv /mingw32/include/tesseract/tesscallback.h.bak /mingw32/include/tesseract/tesscallback.h
```
复制主程序,目录请自行修改
```
mkdir oss_bin
cp ../build-Offline_small_search-Desktop_Qt_MinGW_w64_32bit_MSYS2-Release/release/Offline_small_search.exe oss_bin/
```
拷贝Qt库依赖
未重新编译的Qt库版本
```
cp -r /mingw32/share/qt5/plugins/bearer oss_bin/
cp -r /mingw32/share/qt5/plugins/imageformats oss_bin/
cp -r /mingw32/share/qt5/plugins/mediaservice oss_bin/
cp -r /mingw32/share/qt5/plugins/platforms oss_bin/
cp -r /mingw32/share/qt5/qml/QtMultimedia oss_bin/
cp -r /mingw32/share/qt5/qml/QtQuick oss_bin/
cp -r /mingw32/share/qt5/qml/QtQuick.2 oss_bin/
cp -r /mingw32/share/qt5/qml/QtWebKit oss_bin/
cp -r /mingw32/share/qt5/qml/Qt oss_bin/
cp /mingw32/share/qt5/bin/QtWebProcess.exe oss_bin/
cp /mingw32/bin/Qt5Core.dll oss_bin/
cp /mingw32/bin/Qt5Gui.dll oss_bin/
cp /mingw32/bin/Qt5Multimedia.dll oss_bin/
cp /mingw32/bin/Qt5MultimediaQuick_p.dll oss_bin/
cp /mingw32/bin/Qt5MultimediaWidgets.dll oss_bin/
cp /mingw32/bin/Qt5Network.dll oss_bin/
cp /mingw32/bin/Qt5OpenGL.dll oss_bin/
cp /mingw32/bin/Qt5Positioning.dll oss_bin/
cp /mingw32/bin/Qt5PrintSupport.dll oss_bin/
cp /mingw32/bin/Qt5Qml.dll oss_bin/
cp /mingw32/bin/Qt5Quick.dll oss_bin/
cp /mingw32/bin/Qt5Sensors.dll oss_bin/
cp /mingw32/bin/Qt5Sql.dll oss_bin/
cp /mingw32/bin/Qt5Svg.dll oss_bin/
cp /mingw32/bin/Qt5WebChannel.dll oss_bin/
cp /mingw32/bin/Qt5WebKit.dll oss_bin/
cp /mingw32/bin/Qt5WebKitWidgets.dll oss_bin/
cp /mingw32/bin/Qt5Widgets.dll oss_bin/
cp /mingw32/bin/Qt5XmlPatterns.dll oss_bin/
cp /mingw32/bin/libpcre16-0.dll oss_bin/
cp /mingw32/bin/libpcre-1.dll oss_bin/
cp /mingw32/bin/libgraphite2.dll oss_bin/
cp /mingw32/bin/libharfbuzz-0.dll oss_bin/
cp /mingw32/bin/libfreetype-6.dll oss_bin/
cp /mingw32/bin/libglib-2.0-0.dll oss_bin/
cp /mingw32/bin/libbz2-1.dll oss_bin/
```
重新编译的Qt库版本
```
cp -r ${ossbuild}/build-bin/Qt/plugins/bearer oss_bin/
cp -r ${ossbuild}/build-bin/Qt/plugins/imageformats oss_bin/
cp -r ${ossbuild}/build-bin/Qt/plugins/mediaservice oss_bin/
cp -r ${ossbuild}/build-bin/Qt/plugins/platforms oss_bin/
cp -r ${ossbuild}/build-bin/Qt/qml/QtMultimedia oss_bin/
cp -r ${ossbuild}/build-bin/Qt/qml/QtQuick oss_bin/
cp -r ${ossbuild}/build-bin/Qt/qml/QtQuick.2 oss_bin/
cp -r ${ossbuild}/build-bin/Qt/qml/QtWebKit oss_bin/
cp -r ${ossbuild}/build-bin/Qt/qml/Qt oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/QtWebProcess.exe oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Core.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Gui.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Multimedia.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5MultimediaQuick_p.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5MultimediaWidgets.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Network.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5OpenGL.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Positioning.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5PrintSupport.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Qml.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Quick.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Sensors.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Sql.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Svg.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5WebChannel.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5WebKit.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5WebKitWidgets.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5Widgets.dll oss_bin/
cp ${ossbuild}/build-bin/Qt/bin/Qt5XmlPatterns.dll oss_bin/
```
拷贝其他依赖
```
cp /mingw32/bin/libHalf-2_2.dll oss_bin/
cp /mingw32/bin/libiconv-2.dll oss_bin/
cp /mingw32/bin/libicudt57.dll oss_bin/
cp /mingw32/bin/libicuin57.dll oss_bin/
cp /mingw32/bin/libicuuc57.dll oss_bin/
cp /mingw32/bin/libIex-2_2.dll oss_bin/
cp /mingw32/bin/libIlmImf-2_2.dll oss_bin/
cp /mingw32/bin/libIlmThread-2_2.dll oss_bin/
cp /mingw32/bin/libImath-2_2.dll oss_bin/
cp /mingw32/bin/libjasper-1.dll oss_bin/
cp /mingw32/bin/libjpeg-8.dll oss_bin/
cp /mingw32/bin/libtiff-5.dll oss_bin/
cp /mingw32/bin/libwebp-6.dll oss_bin/
cp /mingw32/bin/libopencv_core310.dll oss_bin/
cp /mingw32/bin/libopencv_imgcodecs310.dll oss_bin/
cp /mingw32/bin/libopencv_imgproc310.dll oss_bin/
cp /mingw32/bin/libopencv_videoio310.dll oss_bin/
cp /mingw32/bin/libopencv_photo310.dll oss_bin/
cp /mingw32/bin/libpng16-16.dll oss_bin/
cp /mingw32/bin/libsqlite3-0.dll oss_bin/
cp /mingw32/bin/libwinpthread-1.dll oss_bin/
cp /mingw32/bin/libgcc_s_dw2-1.dll oss_bin/
cp /mingw32/bin/libstdc++-6.dll oss_bin/
cp /mingw32/bin/libintl-8.dll oss_bin/
cp /mingw32/bin/libxml2-2.dll oss_bin/
cp /mingw32/bin/libxslt-1.dll oss_bin/
cp /mingw32/bin/tbb.dll oss_bin/
cp /mingw32/bin/tbbmalloc.dll oss_bin/
cp /mingw32/bin/libeay32.dll oss_bin/
cp /mingw32/bin/ssleay32.dll oss_bin/
cp /mingw32/bin/liblzma-5.dll oss_bin/
cp /mingw32/bin/zlib1.dll oss_bin/
```
已经安装离线小搜在oss_bin/
------
##Android版本编译
以下内容可以根据最新版本自行修改

本过程基于Qt 5.7.0 for Android, OpenCV 3.1.0, Xapian 1.4.0, xz 5.2.2, e2fsprogs 1.43.1, Leptonica 1.73, tess-two 6.0.2编写, Windows x86_64(win7及以上), ant 1.9.7,android-ndk r12b, android-sdk-windows 25.1.7, jdk1.8.0_92环境运行.

所有代码均在msys2中运行.

msys2下载地址:[http://msys2.github.io/](http://msys2.github.io/)
###0.准备项目
安装必须的软件,下载或克隆项目.

Qt下载地址:[http://www.qt.io/download-open-source/#section-2](http://www.qt.io/download-open-source/#section-2)

下载并安装Qt for Android以及Qt Creator
```
pacman -S --noconfirm --needed base-devel git unzip p7zip xz tar wget python
git clone http://git.oschina.net/zjzdy/Offline-small-search
cd Offline-small-search/
export ossbuild=$PWD
```
###1.Android NDK
到Android NDK的官网去下载对应系统版本的Android NDK到本目录($PWD)下并运行 (注意把windows改成对应的系统)

下载地址:[https://developer.android.com/ndk/downloads/index.html?hl=zh-cn](https://developer.android.com/ndk/downloads/index.html?hl=zh-cn)

以下使用android-ndk-r12b-windows-x86_64.zip
```
wget http://dl.google.com/android/repository/android-ndk-r12b-windows-x86_64.zip
unzip android-ndk-r12b-windows-x86_64.zip
cd android-ndk-r12b/
export NDK_ROOT=$PWD
export PATH=$PWD:$PATH
./build/tools/make_standalone_toolchain.py --arch=arm --stl=gnustl --api=9 --install-dir=../arm-linux-androideabi-4.9
cd ../
mkdir build-bin
mkdir build-bin/lib
mkdir build-bin/include
unzip img_include.zip -d build-bin/include/
```
###2.安装 OpenCV
到OpenCV的官网去下载最新版本的OpenCV android sdk

下载地址:[http://opencv.org/downloads.html](http://opencv.org/downloads.html)

以下使用OpenCV-3.1.0-android-sdk.zip
```
wget https://github.com/Itseez/opencv/releases/download/3.1.0/OpenCV-3.1.0-android-sdk.zip
unzip OpenCV-3.1.0-android-sdk.zip OpenCV-android-sdk/sdk/native/libs/armeabi-v7a/* OpenCV-android-sdk/sdk/native/3rdparty/libs/armeabi-v7a/* -d ./build-bin/lib
cp build-bin/lib/OpenCV-android-sdk/sdk/native/libs/armeabi-v7a/* build-bin/lib/OpenCV-android-sdk/sdk/native/3rdparty/libs/armeabi-v7a/*  ./build-bin/lib
rm -rf build-bin/lib/OpenCV-android-sdk
mv ./build-bin/lib/liblibjasper.a ./build-bin/lib/libjasper.a
mv ./build-bin/lib/liblibjpeg.a ./build-bin/lib/libjpeg.a
mv ./build-bin/lib/liblibpng.a ./build-bin/lib/libpng.a
mv ./build-bin/lib/liblibtiff.a ./build-bin/lib/libtiff.a
mv ./build-bin/lib/liblibwebp.a ./build-bin/lib/libwebp.a
unzip OpenCV-3.1.0-android-sdk.zip OpenCV-android-sdk/sdk/native/jni/include/** -d ./build-bin/include/
cp -rf ./build-bin/include/OpenCV-android-sdk/sdk/native/jni/include/* ./build-bin/include/
rm -rf build-bin/include/OpenCV-android-sdk
```
###3.编译 liblzma
到XZ Utils的官网去下载最新版本的XZ Utils

下载地址:[http://tukaani.org/xz/](http://tukaani.org/xz/)

以下使用xz-5.2.2.tar.xz
```
wget http://tukaani.org/xz/xz-5.2.2.tar.xz
tar -xf xz-5.2.2.tar.xz
cd xz-5.2.2/
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" --disable-xz --disable-xzdec --disable-lzmadec --disable-lzmainfo --disable-lzma-links --disable-scripts --disable-doc 
make
make install
cd ../
```
###4.编译 libuuid
到e2fsprogs的官网去下载最新版本的e2fsprogs

下载地址:[http://e2fsprogs.sourceforge.net](http://e2fsprogs.sourceforge.net/)

以下使用e2fsprogs-1.43.1.tar.xz
```
wget https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.1/e2fsprogs-1.43.1.tar.xz
tar -xf e2fsprogs-1.43.1.tar.xz
cd e2fsprogs-1.43.1/
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" --enable-libuuid
cd lib/uuid
make
make install
cd ../
```

如果在编译util\subst时出错,可以按照下面的文本来修改util/subst.c(只是添加"//"),对编译libuuid基本没有影响.
```
//util/subst.c line 19
//#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
//#endif
//#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
//#endif
//#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
//#endif

//util/subst.c line 436 and 444
			//if (ofd >= 0)
			//	(void) fchmod(ofd, 0444);
```
###5.编译 Xapian
到Xapian的官网去下载最新版本的Xapian core

下载地址:[http://xapian.org/download](http://xapian.org/download)

以下使用xapian-core-1.4.0.tar.xz
```
wget http://oligarchy.co.uk/xapian/1.4.0/xapian-core-1.4.0.tar.xz
tar -xf xapian-core-1.4.0.tar.xz
cd xapian-core-1.4.0/
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" --enable-backend-inmemory=no --enable-static
sed -i 's/HAVE_DECL_SYS_ERRLIST 1/HAVE_DECL_SYS_ERRLIST 0/g' config.h
sed -i 's/HAVE_DECL_SYS_NERR 1/HAVE_DECL_SYS_NERR 0/g' config.h
make
make install
cd ../
```
###6.编译 Leptonica
到Leptonica的官网去下载最新版本的Leptonica

下载地址:[http://www.leptonica.com/download.html](http://www.leptonica.com/download.html)

以下使用leptonica-1.73.tar.gz
```
wget http://www.leptonica.com/source/leptonica-1.73.tar.gz
tar -xf leptonica-1.73.tar.gz
cd leptonica-1.73/
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" 
make
make install
cd ../
```
###7.编译 tess-two
到tess-two的releases去下载最新版本的tess-two

下载地址:[https://github.com/rmtheis/tess-two/releases](https://github.com/rmtheis/tess-two/releases)
```
export winossbuild=`cygpath -m ${ossbuild}`
wget https://github.com/rmtheis/tess-two/archive/6.0.2.tar.gz
tar -xf 6.0.2.tar.gz
cd tess-two-6.0.2/
sed -i 's/LOCAL_SHARED_LIBRARIES/LOCAL_STATIC_LIBRARIES/g' tess-two/jni/com_googlecode_tesseract_android/Android.mk
sed -i 's/BUILD_SHARED_LIBRARY/BUILD_STATIC_LIBRARY/g' tess-two/jni/com_googlecode_tesseract_android/Android.mk
sed -i 's/LEPTONICA_PATH/#LEPTONICA_PATH/g' tess-two/jni/Android.mk
sed -i 's/LIBJPEG_PATH/#LIBJPEG_PATH/g' tess-two/jni/Android.mk
sed -i 's/LIBPNG_PATH/#LIBPNG_PATH/g' tess-two/jni/Android.mk
sed -i 's/NDK_TOOLCHAIN_VERSION := clang/NDK_TOOLCHAIN_VERSION := 4.9/g' tess-two/jni/Application.mk
sed -i 's/APP_ABI/APP_ABI := armeabi-v7a #/g' tess-two/jni/Application.mk
echo "APP_CPPFLAGS += -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -fPIC  -I${winossbuild}/build-bin/include -I${winossbuild}/build-bin/include/leptonica -L${winossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
echo "APP_CFLAGS += -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -fPIC  -I${winossbuild}/build-bin/include -I${winossbuild}/build-bin/include/leptonica -L${winossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
echo "APP_LFLAGS += -Wl,--fix-cortex-a8 -fPIC -L${winossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
echo "APP_LDFLAGS += -Wl,--fix-cortex-a8 -fPIC -L${winossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
rm -rf tess-two/jni/com_googlecode_leptonica_android
rm -rf tess-two/jni/libpng
rm -rf tess-two/jni/libjpeg
cd tess-two/
ndk-build.cmd
cp obj/local/armeabi-v7a/libtess.a ../../build-bin/lib/
mkdir ../../build-bin/include/tesseract
find . -name "*.h" -exec cp {} ../../build-bin/include/tesseract \;
cd ../../
sed -i 's/template <class T> struct remove_reference;//g' build-bin/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference { typedef T type; };//g' build-bin/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference<T&> { typedef T type; };//g' build-bin/include/tesseract/tesscallback.h
```
###8.编译 zimlib
```
cd zimlib/
./autogen.sh
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" 
make
make install
cd ../
```
###9.编译 离线小搜
1.配置好Android (armeabi-v7a) for Qt的环境(包括SDK,NDK,ant,Java)

2.打开Qt Creator

3.打开Offline_small_search.pro

4.选择配置Android for armeabi-v7a (GCC 4.9)

5.选择Release

6.在"项目"选项的"构建步骤"里的"Build Android APK"中的"Android build SDK"选择android-23

7.点击构建

##感谢以下的项目,排名不分先后:
* Qt: [http://www.qt.io/](http://www.qt.io/)
* Zimlib: [http://www.openzim.org/wiki/Zimlib](http://www.openzim.org/wiki/Zimlib) [https://git.wikimedia.org/summary/openzim](https://git.wikimedia.org/summary/openzim)
* Xpian: [http://xapian.org](http://xapian.org)
* libuuid: [http://e2fsprogs.sourceforge.net](http://e2fsprogs.sourceforge.net/)
* OpenCV: [http://www.opencv.org](http://www.opencv.org)
* Tesseract: [https://github.com/tesseract-ocr/tesseract](https://github.com/tesseract-ocr/tesseract)
* Leptonica: [http://www.leptonica.com](http://www.leptonica.com)
* OpenCC: [https://github.com/BYVoid/OpenCC](https://github.com/BYVoid/OpenCC)
* Zeal: [https://zealdocs.org](https://zealdocs.org)
* Dash: [https://kapeli.com](https://kapeli.com)


##已知问题
1. 在浏览内容的界面按返回键有极小几率闪退,如果可复现请开issues(需要提供具体离线包和复现操作).

2. 部分js或css及嵌套html会加载失败(将在3.0版修复)

##TODO
1. 插件功能,自定义一个qml文件和动态链接库,动态加载链接库和qml文件实现扩展功能(3.1)

2. 进行3.0版的重构(此项将于2017年高考完成后进行)
	+ 2.1 采用网页服务器方式进行内容浏览(预计使用Tufao)
	+ 2.2 整理界面代码和业务逻辑
		+ 2.2.1 使用QHash或QMap存储设置以及除离线包外的数据(历史纪录,收藏夹,离线包的部分元数据)
	+ 2.3 支持对docset的索引(SQLite)进行查询(Dash及Zeal)
	
3. 终极目标:对Kiwix,Zeal及Mdict的功能进行整合,能做为一个帮助服务器使用,支持自定义插件(包括在线检索,语音搜索,对显示的内容的操作:如翻译)